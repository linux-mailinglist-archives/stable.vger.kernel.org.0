Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3322060F6
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390596AbgFWUsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392953AbgFWUsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:48:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E83BA2098B;
        Tue, 23 Jun 2020 20:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945321;
        bh=cPN+RtTQ5NReqDF7QV1AKtUFaUc7tKMi9tQFZPpd0IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFEi+SSO4Bo0fpFJNIYcu6wXSrUGOdEdAFKQwx8n39POqYbDzG8o4dS53AAj51VKe
         7lXDD/zBwDJV2ew+tmAYFYKt1O41DN+vGiz49tEmJjEABswyGspMKQ9VgzTgMbzzAo
         EqnL+/qpXn4QXw0eYuW/zDKLPnmPrCqVneuFpQzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 125/136] mtd: rawnand: oxnas: Fix the probe error path
Date:   Tue, 23 Jun 2020 21:59:41 +0200
Message-Id: <20200623195310.093687882@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 154298e2a3f6c9ce1d76cdb48d89fd5b107ea1a3 ]

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

While at it, be consistent and move the function call in the error
path thanks to a goto statement.

Fixes: 668592492409 ("mtd: nand: Add OX820 NAND Support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-37-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/oxnas_nand.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/oxnas_nand.c b/drivers/mtd/nand/oxnas_nand.c
index 7f0ba28f8a007..350d4226b436a 100644
--- a/drivers/mtd/nand/oxnas_nand.c
+++ b/drivers/mtd/nand/oxnas_nand.c
@@ -147,10 +147,8 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 			goto err_release_child;
 
 		err = mtd_device_register(mtd, NULL, 0);
-		if (err) {
-			nand_release(chip);
-			goto err_release_child;
-		}
+		if (err)
+			goto err_cleanup_nand;
 
 		oxnas->chips[nchips] = chip;
 		++nchips;
@@ -166,6 +164,8 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_cleanup_nand:
+	nand_cleanup(chip);
 err_release_child:
 	of_node_put(nand_np);
 err_clk_unprepare:
-- 
2.25.1



