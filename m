Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6BC3C5591
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhGLILE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353748AbhGLICu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8D6761D07;
        Mon, 12 Jul 2021 07:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076638;
        bh=MzcVnk7j7klw9ysB1/XTXRHnTGtWQ8B46+wPGYtzlUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RALCZa8AclVaFWpDt8Sqi8mwCeUtrdyB4gNq+qswiul6GihHfgMId7IRNTtRCmwwp
         1o0qrsDfFwI5i/dHhBp9NFZsZwox9OpY+zh3mn0YbA8ofHjzt3qgIARGOVM2h4U+gG
         IvVpogcZk+/am4KXvnk/f+JGkmi+ZjWYzf1ZJEOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 729/800] mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in marvell_nfc_resume()
Date:   Mon, 12 Jul 2021 08:12:32 +0200
Message-Id: <20210712061044.351472413@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ae94c49527aa9bd3b563349adc4b5617747ca6bd ]

Add clk_disable_unprepare() on error path in marvell_nfc_resume().

Fixes: bd9c3f9b3c00 ("mtd: rawnand: marvell: add suspend and resume hooks")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210601125814.3260364-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index 79da6b02e209..f83525a1ab0e 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -3030,8 +3030,10 @@ static int __maybe_unused marvell_nfc_resume(struct device *dev)
 		return ret;
 
 	ret = clk_prepare_enable(nfc->reg_clk);
-	if (ret < 0)
+	if (ret < 0) {
+		clk_disable_unprepare(nfc->core_clk);
 		return ret;
+	}
 
 	/*
 	 * Reset nfc->selected_chip so the next command will cause the timing
-- 
2.30.2



