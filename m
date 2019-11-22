Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B35106D0E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfKVK5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbfKVK5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD8420718;
        Fri, 22 Nov 2019 10:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420234;
        bh=dVkKHy3LVAeyGbXX2QiqmkHDLTuPBVn5XN5Znud65Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBgNVbUw8OBm5uN3cYG8ki+Mk7IiRT1YwDYUs4Nr5hrqjkVBp37pf3aDN8LHCtOZN
         4oWZEzEwH+iLksLTJC/3MiKYYXnmOv2m7MOJrF+9ND4fW+CR/V9l6AFtUC4bLnDZqC
         Z7uuExg/5jS/cHqA8EiBRQbwTanYIIWYDTiPMfF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/220] ath10k: fix vdev-start timeout on error
Date:   Fri, 22 Nov 2019 11:26:43 +0100
Message-Id: <20191122100915.061528128@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 833fd34d743c728afe6d127ef7bee67e7d9199a8 ]

The vdev-start-response message should cause the
completion to fire, even in the error case.  Otherwise,
the user still gets no useful information and everything
is blocked until the timeout period.

Add some warning text to print out the invalid status
code to aid debugging, and propagate failure code.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 19 ++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi.h  |  8 +++++++-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9feea02e7d373..5c9fc4070fd24 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1003,6 +1003,7 @@ struct ath10k {
 
 	struct completion install_key_done;
 
+	int last_wmi_vdev_start_status;
 	struct completion vdev_setup_done;
 
 	struct workqueue_struct *workqueue;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9d033da46ec2e..d3d33cc2adfde 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -968,7 +968,7 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 	if (time_left == 0)
 		return -ETIMEDOUT;
 
-	return 0;
+	return ar->last_wmi_vdev_start_status;
 }
 
 static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 40b36e73bb48c..aefc92d2c09b9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3248,18 +3248,31 @@ void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_vdev_start_ev_arg arg = {};
 	int ret;
+	u32 status;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_VDEV_START_RESP_EVENTID\n");
 
+	ar->last_wmi_vdev_start_status = 0;
+
 	ret = ath10k_wmi_pull_vdev_start(ar, skb, &arg);
 	if (ret) {
 		ath10k_warn(ar, "failed to parse vdev start event: %d\n", ret);
-		return;
+		ar->last_wmi_vdev_start_status = ret;
+		goto out;
 	}
 
-	if (WARN_ON(__le32_to_cpu(arg.status)))
-		return;
+	status = __le32_to_cpu(arg.status);
+	if (WARN_ON_ONCE(status)) {
+		ath10k_warn(ar, "vdev-start-response reports status error: %d (%s)\n",
+			    status, (status == WMI_VDEV_START_CHAN_INVALID) ?
+			    "chan-invalid" : "unknown");
+		/* Setup is done one way or another though, so we should still
+		 * do the completion, so don't return here.
+		 */
+		ar->last_wmi_vdev_start_status = -EINVAL;
+	}
 
+out:
 	complete(&ar->vdev_setup_done);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 36220258e3c7e..e341cfb3fcc26 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6642,11 +6642,17 @@ struct wmi_ch_info_ev_arg {
 	__le32 rx_frame_count;
 };
 
+/* From 10.4 firmware, not sure all have the same values. */
+enum wmi_vdev_start_status {
+	WMI_VDEV_START_OK = 0,
+	WMI_VDEV_START_CHAN_INVALID,
+};
+
 struct wmi_vdev_start_ev_arg {
 	__le32 vdev_id;
 	__le32 req_id;
 	__le32 resp_type; /* %WMI_VDEV_RESP_ */
-	__le32 status;
+	__le32 status; /* See wmi_vdev_start_status enum above */
 };
 
 struct wmi_peer_kick_ev_arg {
-- 
2.20.1



