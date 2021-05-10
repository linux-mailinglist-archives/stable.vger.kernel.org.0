Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D838B3785CB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhEJLBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234624AbhEJK4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AA9C6193A;
        Mon, 10 May 2021 10:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643654;
        bh=TgVC4UPVRHZNBIu5csNjWVaW5ddsvCz1lELdgxWi99I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIDaTZab3czQnHJX6xmIq/Nd8muNi3dHW4V64dEqxDYy7Vjm5BQDwsN5n28vXRkKb
         dWzx88pw7Q6BtxX7oEdGrwYv8orFZZystNH+VqDgK4TwYHnX3DOCd6rnzHENxOpSSh
         5eQ0HVgAeqLZuE5FMpkNxe6g5bxY0zK+Mv5KjEWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 104/342] platform/x86: ISST: Account for increased timeout in some cases
Date:   Mon, 10 May 2021 12:18:14 +0200
Message-Id: <20210510102013.537269794@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 5c782817a981981917ec3c647cf521022ee07143 ]

In some cases when firmware is busy or updating, some mailbox commands
still timeout on some newer CPUs. To fix this issue, change how we
process timeout.

With this change, replaced timeout from using simple count with real
timeout in micro-seconds using ktime. When the command response takes
more than average processing time, yield to other tasks. The worst case
timeout is extended upto 1 milli-second.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20210330220840.3113959-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel_speed_select_if/isst_if_mbox_pci.c  | 33 +++++++++++++------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c b/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c
index a2a2d923e60c..df1fc6c719f3 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_mbox_pci.c
@@ -21,12 +21,16 @@
 #define PUNIT_MAILBOX_BUSY_BIT		31
 
 /*
- * The average time to complete some commands is about 40us. The current
- * count is enough to satisfy 40us. But when the firmware is very busy, this
- * causes timeout occasionally.  So increase to deal with some worst case
- * scenarios. Most of the command still complete in few us.
+ * The average time to complete mailbox commands is less than 40us. Most of
+ * the commands complete in few micro seconds. But the same firmware handles
+ * requests from all power management features.
+ * We can create a scenario where we flood the firmware with requests then
+ * the mailbox response can be delayed for 100s of micro seconds. So define
+ * two timeouts. One for average case and one for long.
+ * If the firmware is taking more than average, just call cond_resched().
  */
-#define OS_MAILBOX_RETRY_COUNT		100
+#define OS_MAILBOX_TIMEOUT_AVG_US	40
+#define OS_MAILBOX_TIMEOUT_MAX_US	1000
 
 struct isst_if_device {
 	struct mutex mutex;
@@ -35,11 +39,13 @@ struct isst_if_device {
 static int isst_if_mbox_cmd(struct pci_dev *pdev,
 			    struct isst_if_mbox_cmd *mbox_cmd)
 {
-	u32 retries, data;
+	s64 tm_delta = 0;
+	ktime_t tm;
+	u32 data;
 	int ret;
 
 	/* Poll for rb bit == 0 */
-	retries = OS_MAILBOX_RETRY_COUNT;
+	tm = ktime_get();
 	do {
 		ret = pci_read_config_dword(pdev, PUNIT_MAILBOX_INTERFACE,
 					    &data);
@@ -48,11 +54,14 @@ static int isst_if_mbox_cmd(struct pci_dev *pdev,
 
 		if (data & BIT_ULL(PUNIT_MAILBOX_BUSY_BIT)) {
 			ret = -EBUSY;
+			tm_delta = ktime_us_delta(ktime_get(), tm);
+			if (tm_delta > OS_MAILBOX_TIMEOUT_AVG_US)
+				cond_resched();
 			continue;
 		}
 		ret = 0;
 		break;
-	} while (--retries);
+	} while (tm_delta < OS_MAILBOX_TIMEOUT_MAX_US);
 
 	if (ret)
 		return ret;
@@ -74,7 +83,8 @@ static int isst_if_mbox_cmd(struct pci_dev *pdev,
 		return ret;
 
 	/* Poll for rb bit == 0 */
-	retries = OS_MAILBOX_RETRY_COUNT;
+	tm_delta = 0;
+	tm = ktime_get();
 	do {
 		ret = pci_read_config_dword(pdev, PUNIT_MAILBOX_INTERFACE,
 					    &data);
@@ -83,6 +93,9 @@ static int isst_if_mbox_cmd(struct pci_dev *pdev,
 
 		if (data & BIT_ULL(PUNIT_MAILBOX_BUSY_BIT)) {
 			ret = -EBUSY;
+			tm_delta = ktime_us_delta(ktime_get(), tm);
+			if (tm_delta > OS_MAILBOX_TIMEOUT_AVG_US)
+				cond_resched();
 			continue;
 		}
 
@@ -96,7 +109,7 @@ static int isst_if_mbox_cmd(struct pci_dev *pdev,
 		mbox_cmd->resp_data = data;
 		ret = 0;
 		break;
-	} while (--retries);
+	} while (tm_delta < OS_MAILBOX_TIMEOUT_MAX_US);
 
 	return ret;
 }
-- 
2.30.2



