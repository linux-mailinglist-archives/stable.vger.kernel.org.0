Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E8F3C3030
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhGJCdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232833AbhGJCbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33ECE613F7;
        Sat, 10 Jul 2021 02:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884070;
        bh=5cpcAIYiiUrvrbp6zJ3Lo+6pZN1Wc1h5upkrtGZTPSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI/S4Re9914MwD2N9pH5TlAS4F7nhVS0aLvou4qvAcAJSzP5OoUec8S5kYP2XdXkY
         S9WG+Pl08DGVFEL86wVSw1m4UuTe2NOtX5Wg9lTJRxi8zV0Jh0WZkGF030q2OVMTcA
         vHTNA75YJbOTbVr5pXMQVbw1nm2d3vYvTDVbcL1lGJThz4epqjhZY4b87t1Kwynna6
         f6R7VcrhucZ8kAe+jRjQfE7y+3PbycXp1ZessXhFqHuDwIzDDysdWG9zvdsgvuKQ7G
         6y6p72Vf7VRsLp+VLXrPcCVUDcJHXlQPbj+s4Awuzg0FmixxQAaoacBgGNLGFEyAVY
         EGiOqrcoVpK0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 31/63] s390/sclp_vt220: fix console name to match device
Date:   Fri,  9 Jul 2021 22:26:37 -0400
Message-Id: <20210710022709.3170675-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

[ Upstream commit b7d91d230a119fdcc334d10c9889ce9c5e15118b ]

Console name reported in /proc/consoles:

  ttyS1                -W- (EC p  )    4:65

does not match the char device name:

  crw--w----    1 root     root        4,  65 May 17 12:18 /dev/ttysclp0

so debian-installer inside a QEMU s390x instance gets confused and fails
to start with the following error:

  steal-ctty: No such file or directory

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Link: https://lore.kernel.org/r/20210427194010.9330-1-vvidic@valentin-vidic.from.hr
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c       | 2 +-
 drivers/s390/char/sclp_vt220.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 3588f4c65a4d..f661f176966f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -162,7 +162,7 @@ static void __init set_preferred_console(void)
 	else if (CONSOLE_IS_3270)
 		add_preferred_console("tty3270", 0, NULL);
 	else if (CONSOLE_IS_VT220)
-		add_preferred_console("ttyS", 1, NULL);
+		add_preferred_console("ttysclp", 0, NULL);
 	else if (CONSOLE_IS_HVC)
 		add_preferred_console("hvc", 0, NULL);
 }
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 3f9a6ef650fa..3c2ed6d01387 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -35,8 +35,8 @@
 #define SCLP_VT220_MINOR		65
 #define SCLP_VT220_DRIVER_NAME		"sclp_vt220"
 #define SCLP_VT220_DEVICE_NAME		"ttysclp"
-#define SCLP_VT220_CONSOLE_NAME		"ttyS"
-#define SCLP_VT220_CONSOLE_INDEX	1	/* console=ttyS1 */
+#define SCLP_VT220_CONSOLE_NAME		"ttysclp"
+#define SCLP_VT220_CONSOLE_INDEX	0	/* console=ttysclp0 */
 
 /* Representation of a single write request */
 struct sclp_vt220_request {
-- 
2.30.2

