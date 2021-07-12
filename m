Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBABA3C470C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhGLGbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236113AbhGLG3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 637FF610CD;
        Mon, 12 Jul 2021 06:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071216;
        bh=7ufC0DzbZXj2uprl9ku1qjrtptQtprF4K/JnIggnXlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCFrfiY+EitRyUdOSGvFmoP0QVKg3MXtiVELcYKQdfJitJkN4xAJ4j3FgOjL+Sr1A
         ArtGLp+x1fhETl5yH2idQvepTdZXIgJqoqR6gBzqyiqyHjZtufmbviK87h51zwpZRT
         LZo057mmg2SZc8TB2v5ePr0m5TT56p4ACny7yKW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/348] mtd: rawnand: marvell: add missing clk_disable_unprepare() on error in marvell_nfc_resume()
Date:   Mon, 12 Jul 2021 08:11:48 +0200
Message-Id: <20210712060747.069142097@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index ee4afa17d8a3..ef163ff1edf7 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2980,8 +2980,10 @@ static int __maybe_unused marvell_nfc_resume(struct device *dev)
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



