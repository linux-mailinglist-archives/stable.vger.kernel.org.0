Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B91D200F55
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404029AbgFSPPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404028AbgFSPPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:15:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF7D206DB;
        Fri, 19 Jun 2020 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579735;
        bh=DGPFRcC9pEulKheRi/94XpWnQZd9dykFl36awH9hWoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6LkxtTPq4yQKO2lPwQR63nmq8uTKzHg+cZQ/IGPHsOa8P55DOBXfQYO1WAeVksfp
         ROUDqtwNP9F1uaNTXGAHcrVPrwp0btzEhcjhgU3/bcb980O/PvxSba8llATrwdWC79
         4/2DGizLW7A5e7yeyxBMkV2pPRNhRwqNwOE5kXgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 246/261] mtd: rawnand: xway: Fix the probe error path
Date:   Fri, 19 Jun 2020 16:34:17 +0200
Message-Id: <20200619141701.672214068@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 34531be5e804a8e1abf314a6c3a19fe342e4a154 upstream.

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-61-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/xway_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/xway_nand.c
+++ b/drivers/mtd/nand/raw/xway_nand.c
@@ -210,7 +210,7 @@ static int xway_nand_probe(struct platfo
 
 	err = mtd_device_register(mtd, NULL, 0);
 	if (err)
-		nand_release(&data->chip);
+		nand_cleanup(&data->chip);
 
 	return err;
 }


