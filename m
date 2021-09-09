Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B6405114
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbhIIMdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353735AbhIIM3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:29:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86BF061357;
        Thu,  9 Sep 2021 11:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188351;
        bh=bkivChkdpLFO1TZYQV/g8jfevgN1DLu5GcAyvQybj68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxh47qqYG0FmUb39zlSXrA08Sa/4KbLm4eQPg05V49sLlip57r3uT3pdKqsrlZmzg
         fn69PKEppE3Op5HHAzahQwnbabr5aSxqKy9a3tvjms+CT5WBB6MK6n1mx97RqXRYWY
         +tr3oWK38XXUlb/tr6eOS8b6wnp3qkiBD+zOlrORNM+lOoH1vKvT36yjkhwmnlOkL7
         W2alab2p9yXhgtftjIwgmSFzVNP2nXW8P2zYXjSNF6WCetLK1LaWMvhmXf6Gk5x1w0
         C8dIeZVDwkxTcJAnL6YREdIvBwYK8K6RQnip6toqEwuHFVBq67Yic8vqJTCowOfPAM
         laYbUecFIb0Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 057/176] staging: ks7010: Fix the initialization of the 'sleep_status' structure
Date:   Thu,  9 Sep 2021 07:49:19 -0400
Message-Id: <20210909115118.146181-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 56315e55119c0ea57e142b6efb7c31208628ad86 ]

'sleep_status' has 3 atomic_t members. Initialize the 3 of them instead of
initializing only 2 of them and setting 0 twice to the same variable.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d2e52a33a9beab41879551d0ae2fdfc99970adab.1626856991.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/ks7010_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 78dc8beeae98..8c740c771f50 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -939,9 +939,9 @@ static void ks7010_private_init(struct ks_wlan_private *priv,
 	memset(&priv->wstats, 0, sizeof(priv->wstats));
 
 	/* sleep mode */
+	atomic_set(&priv->sleepstatus.status, 0);
 	atomic_set(&priv->sleepstatus.doze_request, 0);
 	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
 
 	trx_device_init(priv);
 	hostif_init(priv);
-- 
2.30.2

