Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD0D328C89
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhCASxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240258AbhCASrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:47:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F02AA6513F;
        Mon,  1 Mar 2021 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618257;
        bh=2eFGLnHjWaCD9HNqLukQ3bj/ux8I1hw8XjrFkQsmy4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjXQcOmLayw07V9njSxL6sYRmVST78BREGjZiVOe9XnilRb/sak9MJlpiZARm92Gs
         WIaT0a8SrgVL+O1N7UboaZgzdpbCdzlSaP7g/PMb4U0TIMCAhY9tAi60n8wMZXSqWu
         gch1to3w+l7FB79diWUNMAktpSVAdweucAyeJV2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Pillai <pillair@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/663] ath10k: Fix error handling in case of CE pipe init failure
Date:   Mon,  1 Mar 2021 17:04:29 +0100
Message-Id: <20210301161142.838948567@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index fd41f25456dc4..daae470ecf5aa 100644
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



