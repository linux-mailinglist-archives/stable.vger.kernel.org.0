Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6489D201706
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389293AbgFSOuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389287AbgFSOuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:50:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8ACD20DD4;
        Fri, 19 Jun 2020 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578212;
        bh=SqMZ8KY+FjtbFnYZ4eKhIAmYzpPAlUIp/YzvchYKZzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtldHJQMnKeReieOkbRxwu0k9h2kCCHgnAvneJ++HqLMQCRc4qtknVjUyJbFv8OV6
         uYitnYnRPp1872aMzDO0O8TsBA3B/J8F003x30YkVTp5nu2HEVCdwyNqT5YRSGKPsN
         X/SztOXTQ3VSYfva9m+w+gl/QFcLib+ee7PL9lyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/190] brcmfmac: fix wrong location to get firmware feature
Date:   Fri, 19 Jun 2020 16:32:21 +0200
Message-Id: <20200619141638.395766583@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
index 53ae30259989..473b2b3cb6f5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -192,13 +192,14 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
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
 
 	/* set chip related quirks */
 	switch (drvr->bus_if->chip) {
-- 
2.25.1



