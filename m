Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE4D2010A2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393877AbgFSPcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393873AbgFSPcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27D8520734;
        Fri, 19 Jun 2020 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580726;
        bh=YtVlJQS36T/FGl827kIC89tbz5tIe3JW861Tai/VvyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiAi/ojAWD6/u8zzzTNQvgIl3auEUIIKgBxugqIRNZsJv5H6svDo0mi8MBGG4NgPf
         6RtM1LnOayluZ0RS4I65pqEemkzOOxZ6QdCjHv5Gs5UaatFInkLbwbG6cW5+lmRhzD
         Wun0ih8tmmH+qFs9ov2LXy/YuFLVKB0klg+9pcRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.7 360/376] mtd: rawnand: socrates: Fix the probe error path
Date:   Fri, 19 Jun 2020 16:34:38 +0200
Message-Id: <20200619141727.356736861@linuxfoundation.org>
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

commit 9c6c2e5cc77119ce0dacb4f9feedb73ce0354421 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/socrates_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/socrates_nand.c
+++ b/drivers/mtd/nand/raw/socrates_nand.c
@@ -169,7 +169,7 @@ static int socrates_nand_probe(struct pl
 	if (!res)
 		return res;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 out:
 	iounmap(host->io_base);


