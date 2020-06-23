Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BFD20623B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393092AbgFWU5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391120AbgFWUml (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D74721835;
        Tue, 23 Jun 2020 20:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944962;
        bh=AduIGrp0lPRae7vMVG/+0hrQFMTs776EiPd6aj/7zo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMUIIT5Svrs11aeO5CUSTeP66DKZN5HLYW9ugdUUh4DB5E0/8njdjzz0f12tlZuNY
         nuoiCARyFhFNjE/iY6gb5T9/63N2O/BFEiIEt5qynXC0rnmYrTLdMMbgm/+V4RIezy
         QH7sNf+sxzZV5pGD6xMt3VUVlV/7TMtU1yt/J3uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 191/206] mtd: rawnand: socrates: Fix the probe error path
Date:   Tue, 23 Jun 2020 21:58:39 +0200
Message-Id: <20200623195326.421510558@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 9c6c2e5cc77119ce0dacb4f9feedb73ce0354421 ]

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
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-51-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/socrates_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/socrates_nand.c b/drivers/mtd/nand/raw/socrates_nand.c
index 74fdb8402dbde..274b3521a1dc6 100644
--- a/drivers/mtd/nand/raw/socrates_nand.c
+++ b/drivers/mtd/nand/raw/socrates_nand.c
@@ -193,7 +193,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	if (!res)
 		return res;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 out:
 	iounmap(host->io_base);
-- 
2.25.1



