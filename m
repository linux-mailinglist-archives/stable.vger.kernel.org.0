Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3172E3CF4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438742AbgL1OJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438680AbgL1OIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21E1E20731;
        Mon, 28 Dec 2020 14:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164484;
        bh=KPuZp325EejXcnsgmbnaIvhJLTLjeV7kJv1O3yeprCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAl8z/4wwz6ysXYJG8M6Oi2ZaYkyeBGlEtAM4z8jbLRaIJLce1ANAN6gQltjayFFP
         AOabVpFnDmpNUk8zfGE47Mej7bEZIzGoQ3ehTlXLgH6is1IatQIGgSL1C8mpj6SQR3
         +u3t1yMbwG4JTP9sMN1sxsmlQVYRK/qy2a3zepLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/717] brcmfmac: fix error return code in brcmf_cfg80211_connect()
Date:   Mon, 28 Dec 2020 13:43:14 +0100
Message-Id: <20201228125030.358475852@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 37ff144d29acd7bca3d465ce2fc4cb5c7072a7e5 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3b1e0a7bdfee ("brcmfmac: add support for SAE authentication offload")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Chi-hsien Lin <chi-hsien.lin@infineon.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1605248896-16812-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a2dbbb977d0cb..0ee421f30aa24 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2137,7 +2137,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 				    BRCMF_WSEC_MAX_PSK_LEN);
 	else if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_SAE) {
 		/* clean up user-space RSNE */
-		if (brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0)) {
+		err = brcmf_fil_iovar_data_set(ifp, "wpaie", NULL, 0);
+		if (err) {
 			bphy_err(drvr, "failed to clean up user-space RSNE\n");
 			goto done;
 		}
-- 
2.27.0



