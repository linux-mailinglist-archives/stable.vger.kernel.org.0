Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115812F5AA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfE3DLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfE3DL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BAA224482;
        Thu, 30 May 2019 03:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185889;
        bh=0EkAdPCGdyqIBSDXQo7mk0iCaNKd2VP0axqRZUpJS/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znIErsJ2QmaU0r/5Tm/jGdylpgkkLNP+syX5p34SyCDaUsdgmgcUhPkQuJjysZ5mj
         Nj6CHK2Kzj0ELwaOf+/C5HpWCSJPOJdsLOq2PRtWHZPMTNehZu0oWizmiGtTy18r3m
         AhryfIHJcCcmi8tO6Df8y9mN6RATwuslcj4LKnF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 249/405] brcmfmac: fix missing checks for kmemdup
Date:   Wed, 29 May 2019 20:04:07 -0700
Message-Id: <20190530030553.592183810@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 46953f97224d56a12ccbe9c6acaa84ca0dab2780 ]

In case kmemdup fails, the fix sets conn_info->req_ie_len and
conn_info->resp_ie_len to zero to avoid buffer overflows.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index e92f6351bd224..8ee8af4e7ec4f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5464,6 +5464,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 		conn_info->req_ie =
 		    kmemdup(cfg->extra_buf, conn_info->req_ie_len,
 			    GFP_KERNEL);
+		if (!conn_info->req_ie)
+			conn_info->req_ie_len = 0;
 	} else {
 		conn_info->req_ie_len = 0;
 		conn_info->req_ie = NULL;
@@ -5480,6 +5482,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 		conn_info->resp_ie =
 		    kmemdup(cfg->extra_buf, conn_info->resp_ie_len,
 			    GFP_KERNEL);
+		if (!conn_info->resp_ie)
+			conn_info->resp_ie_len = 0;
 	} else {
 		conn_info->resp_ie_len = 0;
 		conn_info->resp_ie = NULL;
-- 
2.20.1



