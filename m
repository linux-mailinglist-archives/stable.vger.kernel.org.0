Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1076432AFED
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhCCA3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350761AbhCBMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A56164F83;
        Tue,  2 Mar 2021 11:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686276;
        bh=Ts83Ujloeb3ZnB28+UP++qymTrh4Lxh0Fvt6Y1RrFE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDidPZVjsVBwTmKq6lNO/xggxap6WNn/o4NNBsOB9eub1AtpzOhcvQPw7FJfD6u6+
         UHbqzbPX/1rB2TxQAnFmXZnxvtEkSGnvYJl4z7OOobraUtmHJRI2d2AMCX61SQctiJ
         Io0iaxGWV7y+OTDzs4Etp5t9DwUVyETS0DVD87CSFCOTee3xC0+yPPlcbqr77r1P0z
         nH3TB/B0tDqWOlhTNU6sSizE1V0mFqSfue7JWNIS9BjQ00xzYnRUOWGa85juQXsE9B
         TWjPGnNNCl3oPg7TkKptXuUPCQP+GG79Z7z5abvj1yw3S8kL8vWeFt6ulUPoMv5dGg
         BxEBHyt8KMazw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/33] mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'
Date:   Tue,  2 Mar 2021 06:57:20 -0500
Message-Id: <20210302115749.62653-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115749.62653-1-sashal@kernel.org>
References: <20210302115749.62653-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0bb7e560f821c7770973a94e346654c4bdccd42c ]

If 'mmc_of_parse()' fails, we must undo the previous 'dma_request_chan()'
call.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201208203527.49262-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mxs-mmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 4031217d21c3..52054931c350 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -644,7 +644,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 
 	ret = mmc_of_parse(mmc);
 	if (ret)
-		goto out_clk_disable;
+		goto out_free_dma;
 
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
-- 
2.30.1

