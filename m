Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91D3599F4
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhDIJzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhDIJyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A2166120F;
        Fri,  9 Apr 2021 09:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962081;
        bh=D75x1ghqG1HGfffoYSKUhIr5pvSRwt9OJxflPSfcZMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVY9S2CrtaSh2Yg59hPRdjeXonainR9apMbOWSYZ68b0YnL9/9S2weNPq7v4l25oc
         UFolExit/oh1yUwvFwQMYHBFTmc0q6vPaCkzn19LExt2fjjfcAvN9hdHP6eqkIT+f2
         y9BxhthFZEMTp4Mggfjz4Dkxn4kVyya88nTpTgFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 16/20] mtd: rawnand: diskonchip: Fix the probe error path
Date:   Fri,  9 Apr 2021 11:53:22 +0200
Message-Id: <20210409095300.471567141@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
References: <20210409095259.957388690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 upstream

Not sure nand_cleanup() is the right function to call here but in any
case it is not nand_release(). Indeed, even a comment says that
calling nand_release() is a bit of a hack as there is no MTD device to
unregister. So switch to nand_cleanup() for now and drop this
comment.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if it did not intruce
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com
[sudip: manual backport to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/diskonchip.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1608,13 +1608,10 @@ static int __init doc_probe(unsigned lon
 		numchips = doc2001_init(mtd);
 
 	if ((ret = nand_scan(mtd, numchips)) || (ret = doc->late_init(mtd))) {
-		/* DBB note: i believe nand_release is necessary here, as
+		/* DBB note: i believe nand_cleanup is necessary here, as
 		   buffers may have been allocated in nand_base.  Check with
 		   Thomas. FIX ME! */
-		/* nand_release will call mtd_device_unregister, but we
-		   haven't yet added it.  This is handled without incident by
-		   mtd_device_unregister, as far as I can tell. */
-		nand_release(mtd);
+		nand_cleanup(nand);
 		kfree(mtd);
 		goto fail;
 	}


