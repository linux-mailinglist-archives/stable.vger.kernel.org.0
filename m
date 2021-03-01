Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95287328A0C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbhCASKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:10:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238993AbhCASEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9342652AF;
        Mon,  1 Mar 2021 17:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620082;
        bh=mTdq87/QC45TOubdZwuvEScvIL7xloOb9n+de1S67K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQRwF8+/eYAjjxQIaE/HJp7BMpNVsA/0vnOEB8Aa9N1VS1rdZG5ZYJ1cdPamdkgK1
         cCcFlcAe7XR+BFk1LkScD3RGHhfsfhpo4hr80goJ7HUfoJagj+aDMsYr4zgvX3XCs6
         R0MnGhifXiENfApwDbRTjhHaZShFEMQRejMw/qMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 023/775] ath10k: Fix error handling in case of CE pipe init failure
Date:   Mon,  1 Mar 2021 17:03:11 +0100
Message-Id: <20210301161202.857635718@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 31561e8557cd1eeba5806ac9ce820f8323b2201b ]

Currently if the copy engine pipe init fails for snoc based
chipsets, the rri is not freed.

Fix this error handling for copy engine pipe init
failure.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Fixes: 4945af5b264f ("ath10k: enable SRRI/DRRI support on ddr for WCN3990")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1607713210-18320-1-git-send-email-pillair@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index bf9a8cb713dc0..1c3307e3b1085 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1045,12 +1045,13 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar,
 	ret = ath10k_snoc_init_pipes(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to initialize CE: %d\n", ret);
-		goto err_wlan_enable;
+		goto err_free_rri;
 	}
 
 	return 0;
 
-err_wlan_enable:
+err_free_rri:
+	ath10k_ce_free_rri(ar);
 	ath10k_snoc_wlan_disable(ar);
 
 	return ret;
-- 
2.27.0



