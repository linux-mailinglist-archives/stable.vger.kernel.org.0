Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EC120109A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393839AbgFSPbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391379AbgFSPby (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62BDA20757;
        Fri, 19 Jun 2020 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580713;
        bh=5iZkv0fqTgd+XreIbBWlXku76xfHX8tsVakDmB4R/f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMFgbdCf/E182L9gdIXA24YCCgmXWjUUwehZDeZwmzDiZnZTYpFDAtDzMe5bo7pah
         2TXLsyqeZtjIjLmJpZCUaVo+J1OSch7L/+TQhcsyXmlwmDkmjbehWlYOAKxbfWBQCc
         o7VMf+ley7B2cNNk9VL6bV1hDVwGEJHCzsjfpau0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.7 355/376] mtd: rawnand: diskonchip: Fix the probe error path
Date:   Fri, 19 Jun 2020 16:34:33 +0200
Message-Id: <20200619141727.124347974@linuxfoundation.org>
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

commit c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/diskonchip.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1609,13 +1609,10 @@ static int __init doc_probe(unsigned lon
 		numchips = doc2001_init(mtd);
 
 	if ((ret = nand_scan(nand, numchips)) || (ret = doc->late_init(mtd))) {
-		/* DBB note: i believe nand_release is necessary here, as
+		/* DBB note: i believe nand_cleanup is necessary here, as
 		   buffers may have been allocated in nand_base.  Check with
 		   Thomas. FIX ME! */
-		/* nand_release will call mtd_device_unregister, but we
-		   haven't yet added it.  This is handled without incident by
-		   mtd_device_unregister, as far as I can tell. */
-		nand_release(nand);
+		nand_cleanup(nand);
 		goto fail;
 	}
 


