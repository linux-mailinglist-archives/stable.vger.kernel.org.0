Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9582ED261
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbhAGOcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbhAGOcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:32:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77C902311E;
        Thu,  7 Jan 2021 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029940;
        bh=Bud2sO1NsdUfoYt/Q2KW2qBHsRbg6KazHjbTfsQbrzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6WGiYD1yrHI8I7R6IvM8xfhMvVdD/6JMvc5sFh+XivwV6NR7g4qE0Nxe4Lm4HAuj
         7myLRHmBDsYAf2Vs+S8P+q4vF6GWqR+fUNyEegmJqClWCMcMmMTRkS1IvZGzbmp/MP
         hYkgtFuKOQWGnbhkzROG++YYly+UZG3g1PwmYfeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.4 02/13] Revert "mtd: spinand: Fix OOB read"
Date:   Thu,  7 Jan 2021 15:33:21 +0100
Message-Id: <20210107143050.259221202@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

This reverts stable commit baad618d078c857f99cc286ea249e9629159901f.

This commit is adding lines to spinand_write_to_cache_op, wheras the upstream
commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 that this was supposed to
backport was touching spinand_read_from_cache_op.
It causes a crash on writing OOB data by attempting to write to read-only
kernel memory.

Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -317,10 +317,6 @@ static int spinand_write_to_cache_op(str
 		buf += ret;
 	}
 
-	if (req->ooblen)
-		memcpy(req->oobbuf.in, spinand->oobbuf + req->ooboffs,
-		       req->ooblen);
-
 	return 0;
 }
 


