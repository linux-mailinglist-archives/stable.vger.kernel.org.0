Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF17A450CEA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbhKORq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238472AbhKORou (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:44:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E5963303;
        Mon, 15 Nov 2021 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997324;
        bh=b6fcItTklQsN/ZPpPnRAkBWjlRbNKWlzd0HA6lNmv18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Fp/f+pKknsSRPVqyfscBcqr7n95hgQBngmsXmzgmsJDOBkoNUY6gPeDwTc/RSWkG
         I3P4zCpjj65RLmACkfTNV/3yu711ZQ3U9dMU+HRKdJzZ67i76jHzXPotQLfwhaZfPb
         CLrMXs9h3ikIuwSgshFIqCs7d44MsLj8lu8KaCeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 105/575] wcn36xx: Fix (QoS) null data frame bitrate/modulation
Date:   Mon, 15 Nov 2021 17:57:10 +0100
Message-Id: <20211115165347.289710170@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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


