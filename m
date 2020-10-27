Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B811129C2AC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760271AbgJ0OeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760259AbgJ0OeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:34:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA7D20773;
        Tue, 27 Oct 2020 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809259;
        bh=HX3aU6P1SMK8sP+Jjk+iqfwLcjm4EHSdB8nhGyqW1Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yB7LIqAcAU7wi8E5ZhhV7GuDggekGcMGQLKHe0QdsVp4OHJeHQEmkh+ha56/dPUGn
         BKQ2oLnK0rqKeX37aYSVYkHMFNSfHSfIxtBLXBAZ4VRSwiofvJ8PVVjQGQIg8vr9+Z
         fRq+ny/LQeBYzOoGf3I6YC+AZQvP2avRbRL2brQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/408] mwifiex: Do not use GFP_KERNEL in atomic context
Date:   Tue, 27 Oct 2020 14:50:53 +0100
Message-Id: <20201027135500.438619721@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d2ab7f00f4321370a8ee14e5630d4349fdacc42e ]

A possible call chain is as follow:
  mwifiex_sdio_interrupt                            (sdio.c)
    --> mwifiex_main_process                        (main.c)
      --> mwifiex_process_cmdresp                   (cmdevt.c)
        --> mwifiex_process_sta_cmdresp             (sta_cmdresp.c)
          --> mwifiex_ret_802_11_scan               (scan.c)
            --> mwifiex_parse_single_response_buf   (scan.c)

'mwifiex_sdio_interrupt()' is an interrupt function.

Also note that 'mwifiex_ret_802_11_scan()' already uses GFP_ATOMIC.

So use GFP_ATOMIC instead of GFP_KERNEL when memory is allocated in
'mwifiex_parse_single_response_buf()'.

Fixes: 7c6fa2a843c5 ("mwifiex: use cfg80211 dynamic scan table and cfg80211_get_bss API")
or
Fixes: 601216e12c65e ("mwifiex: process RX packets in SDIO IRQ thread directly")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200809092906.744621-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 59f0651d148bb..629af26675cf1 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1891,7 +1891,7 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 					    chan, CFG80211_BSS_FTYPE_UNKNOWN,
 					    bssid, timestamp,
 					    cap_info_bitmap, beacon_period,
-					    ie_buf, ie_len, rssi, GFP_KERNEL);
+					    ie_buf, ie_len, rssi, GFP_ATOMIC);
 			if (bss) {
 				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
 				bss_priv->band = band;
-- 
2.25.1



