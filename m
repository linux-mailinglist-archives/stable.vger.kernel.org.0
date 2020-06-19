Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84272010A9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404679AbgFSPc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404675AbgFSPcZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E54220734;
        Fri, 19 Jun 2020 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580744;
        bh=BUl86xW/ewJqWL8X0Gzx62jgAFsGACn6a8dbQ2QMsy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ1TpP1+d0kfnZUQyNxJUVgOjSODaOHrL0wtU1qlHXg+yCH1qHEubUOenus0dxBbz
         JJ+sWXbQb5hdfuJar1WDdsJ7U26uRXGGfF7qYZ2/8snPuG7aTi/TDohyeNK43UVAnm
         G0iBgZQ+pnE4rSPvZHNhAzGAiY8Ml51n1WOi9FBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.7 366/376] mtd: rawnand: tmio: Fix the probe error path
Date:   Fri, 19 Jun 2020 16:34:44 +0200
Message-Id: <20200619141727.639185170@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 75e9a330a9bd48f97a55a08000236084fe3dae56 upstream.

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-57-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/tmio_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/tmio_nand.c
+++ b/drivers/mtd/nand/raw/tmio_nand.c
@@ -448,7 +448,7 @@ static int tmio_probe(struct platform_de
 	if (!retval)
 		return retval;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);


