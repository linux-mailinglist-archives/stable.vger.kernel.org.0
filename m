Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DC4200E87
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391764AbgFSPIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391738AbgFSPIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:08:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C25E721852;
        Fri, 19 Jun 2020 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579320;
        bh=Tzw3Gzlm+3BA/nlhX9g2BWNAa7mep+kD4+xGWxixxX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo+UPMt3saxLmx94h+O1C6IC2zHcWUQ4AwPzvA+Q8GYeNKHASPEIzZmonAeH7gAIv
         BbHjImV2Fe81ZP5xnmwLlKt7jmW369T52eO3ks0hST4Wgkkp/OKAFI6Lsow0gEKXTl
         49ACEI33k8eW+evfwZUKMzKb1k2g3PZPq7M6wGhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/261] brcmfmac: fix wrong location to get firmware feature
Date:   Fri, 19 Jun 2020 16:31:12 +0200
Message-Id: <20200619141652.842535783@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaehoon Chung <jh80.chung@samsung.com>

[ Upstream commit c57673852062428cdeabdd6501ac8b8e4c302067 ]

sup_wpa feature is getting after setting feature_disable flag.
If firmware is supported sup_wpa feature,  it's always enabled
regardless of feature_disable flag.

Fixes: b8a64f0e96c2 ("brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK")
Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200330052528.10503-1-jh80.chung@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 2c3526aeca6f..545015610cf8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -283,13 +283,14 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	if (!err)
 		ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_SCAN_RANDOM_MAC);
 
+	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
+
 	if (drvr->settings->feature_disable) {
 		brcmf_dbg(INFO, "Features: 0x%02x, disable: 0x%02x\n",
 			  ifp->drvr->feat_flags,
 			  drvr->settings->feature_disable);
 		ifp->drvr->feat_flags &= ~drvr->settings->feature_disable;
 	}
-	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_FWSUP, "sup_wpa");
 
 	brcmf_feat_firmware_overrides(drvr);
 
-- 
2.25.1



