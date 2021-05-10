Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BC13787C3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhEJLSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236600AbhEJLIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FC3619B0;
        Mon, 10 May 2021 11:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644551;
        bh=bzmywSXBtAQ24HIfGcPa50uOhmS2qGNXR7ppo+09U9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHkIC0lwDonLTeDQurE4jGcyMF3EQEJXMg7fh/cFNAOBg214T2NFGCHhEU8Xasx2p
         dmqsex0hP2ogf/OnD2Dv9AAcT1cgGna0+6wQENF9s5f/nbz3punzVDxt0eRG/YVJcx
         Fy0yniQpBQnlvqJMyTDU+ukdX21hNOzCR/DyPNDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 129/384] crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c
Date:   Mon, 10 May 2021 12:18:38 +0200
Message-Id: <20210510102019.155066598@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shixin Liu <liushixin2@huawei.com>

[ Upstream commit 747bf30fd944f02f341b5f3bc7d97a13f2ae2fbe ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Signed-off-by: Shixin Liu <liushixin2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 2a4793176c71..7389a0536ff0 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -542,7 +542,7 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
 	int ret;
 	u32 cfg, hw_mode;
 
-	pm_runtime_get_sync(cryp->dev);
+	pm_runtime_resume_and_get(cryp->dev);
 
 	/* Disable interrupt */
 	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
@@ -2043,7 +2043,7 @@ static int stm32_cryp_remove(struct platform_device *pdev)
 	if (!cryp)
 		return -ENODEV;
 
-	ret = pm_runtime_get_sync(cryp->dev);
+	ret = pm_runtime_resume_and_get(cryp->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.30.2



