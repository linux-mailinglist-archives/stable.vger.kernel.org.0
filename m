Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A7724754A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392388AbgHQTVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbgHQPgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550FF208E4;
        Mon, 17 Aug 2020 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678562;
        bh=BSj09ABMawelgjrVESxuHKeV87K5pA2oXDswGqGTX8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNkxFBVWdmKdhbTfRQgbFYJpO83CstEBUAXN0yAIEk55oqfAhJz4BrRh+5WtMR3A/
         dbk+2xIUcEyF1hJJDA76toqmmWuWRfg11S6JALdmNQd70cVvKN6tOw8ErbKh45MzhV
         I5ufXu7ILuwMxhR/whL78pQpcZOUbr9nuxcagnWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 377/464] mtd: rawnand: brcmnand: Dont default to edu transfer
Date:   Mon, 17 Aug 2020 17:15:30 +0200
Message-Id: <20200817143851.833346219@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit bee3ab8bdd3b13faf08e5b6e0218f59b0a49fcc3 ]

When flash-dma is absent do not default to using flash-edu.
Make sure flash-edu is enabled before setting EDU transfer
function.

Fixes: a5d53ad26a8b ("mtd: rawnand: brcmnand: Add support for flash-edu for dma transfers")
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200612212902.21347-2-kdasu.kdev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index 44068e9eea035..ac934a715a194 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -3023,8 +3023,9 @@ int brcmnand_probe(struct platform_device *pdev, struct brcmnand_soc *soc)
 		if (ret < 0)
 			goto err;
 
-		/* set edu transfer function to call */
-		ctrl->dma_trans = brcmnand_edu_trans;
+		if (has_edu(ctrl))
+			/* set edu transfer function to call */
+			ctrl->dma_trans = brcmnand_edu_trans;
 	}
 
 	/* Disable automatic device ID config, direct addressing */
-- 
2.25.1



