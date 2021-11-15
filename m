Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE23452516
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347734AbhKPBqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238067AbhKOSZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A3F6342E;
        Mon, 15 Nov 2021 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998967;
        bh=b6fcItTklQsN/ZPpPnRAkBWjlRbNKWlzd0HA6lNmv18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnKL2xuWIYWfgfTt5WQDrDctJjiiVFWBeMRXeNdOEQtmyiGRI/ZfKnLJqtfAARPPj
         Qy+uNoFRUZ1dOO8rRs7orfQNBLYC98G+LsaXVTg3Bn3oR8Jln8Qn7OHJS//fMGpM+d
         GILUgGeFWtWH2hPJfg50OH4l5nYzXK9QnOUdd6rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.14 127/849] wcn36xx: Fix (QoS) null data frame bitrate/modulation
Date:   Mon, 15 Nov 2021 17:53:30 +0100
Message-Id: <20211115165424.393823315@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit d3fd2c95c1c13ec217d43ebef3c61cfa00a6cd37 upstream.

We observe unexpected connection drops with some APs due to
non-acked mac80211 generated null data frames (keep-alive).
After debugging and capture, we noticed that null frames are
submitted at standard data bitrate and that the given APs are
in trouble with that.

After setting the null frame bitrate to control bitrate, all
null frames are acked as expected and connection is maintained.

Not sure if it's a requirement of the specification, but it seems
the right thing to do anyway, null frames are mostly used for control
purpose (power-saving, keep-alive...), and submitting them with
a slower/simpler bitrate/modulation is more robust.

Cc: stable@vger.kernel.org
Fixes: 512b191d9652 ("wcn36xx: Fix TX data path")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1634560399-15290-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -429,6 +429,7 @@ static void wcn36xx_set_tx_data(struct w
 	if (ieee80211_is_any_nullfunc(hdr->frame_control)) {
 		/* Don't use a regular queue for null packet (no ampdu) */
 		bd->queue_id = WCN36XX_TX_U_WQ_ID;
+		bd->bd_rate = WCN36XX_BD_RATE_CTRL;
 	}
 
 	if (bcast) {


