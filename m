Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635A17F482
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389180AbfHBJaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389203AbfHBJaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:30:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FE43217D6;
        Fri,  2 Aug 2019 09:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738211;
        bh=qTu89DnlrDEO40GD2d4Ph723/8OQeOlqvDbQmfCAhaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qcD9cy5VGqhyvb2HUFKmDTO2th1HrcojL0QyoQ6s4c+27A3bHv8DX66dVjCy8Rwaz
         md480L6eSHc66ImVqI+YVZCIzGlI/BKK4eZr0pZiKRZwIw+DCDaV6IiNq6Qv4wPKQ+
         Yrvja62/3lRSGQdj+Io89L5IG9YwP6smZ1V5p4KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 006/158] ath6kl: add some bounds checking
Date:   Fri,  2 Aug 2019 11:27:07 +0200
Message-Id: <20190802092204.832300749@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5d6751eaff672ea77642e74e92e6c0ac7f9709ab ]

The "ev->traffic_class" and "reply->ac" variables come from the network
and they're used as an offset into the wmi->stream_exist_for_ac[] array.
Those variables are u8 so they can be 0-255 but the stream_exist_for_ac[]
array only has WMM_NUM_AC (4) elements.  We need to add a couple bounds
checks to prevent array overflows.

I also modified one existing check from "if (traffic_class > 3) {" to
"if (traffic_class >= WMM_NUM_AC) {" just to make them all consistent.

Fixes: bdcd81707973 (" Add ath6kl cleaned up driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a5e1de75a4a3..b2ec254f154e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1178,6 +1178,10 @@ static int ath6kl_wmi_pstream_timeout_event_rx(struct wmi *wmi, u8 *datap,
 		return -EINVAL;
 
 	ev = (struct wmi_pstream_timeout_event *) datap;
+	if (ev->traffic_class >= WMM_NUM_AC) {
+		ath6kl_err("invalid traffic class: %d\n", ev->traffic_class);
+		return -EINVAL;
+	}
 
 	/*
 	 * When the pstream (fat pipe == AC) timesout, it means there were
@@ -1519,6 +1523,10 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 		return -EINVAL;
 
 	reply = (struct wmi_cac_event *) datap;
+	if (reply->ac >= WMM_NUM_AC) {
+		ath6kl_err("invalid AC: %d\n", reply->ac);
+		return -EINVAL;
+	}
 
 	if ((reply->cac_indication == CAC_INDICATION_ADMISSION_RESP) &&
 	    (reply->status_code != IEEE80211_TSPEC_STATUS_ADMISS_ACCEPTED)) {
@@ -2631,7 +2639,7 @@ int ath6kl_wmi_delete_pstream_cmd(struct wmi *wmi, u8 if_idx, u8 traffic_class,
 	u16 active_tsids = 0;
 	int ret;
 
-	if (traffic_class > 3) {
+	if (traffic_class >= WMM_NUM_AC) {
 		ath6kl_err("invalid traffic class: %d\n", traffic_class);
 		return -EINVAL;
 	}
-- 
2.20.1



