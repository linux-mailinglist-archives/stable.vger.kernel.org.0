Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2280B498EE3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356559AbiAXTtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37778 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355335AbiAXTkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A14F6135E;
        Mon, 24 Jan 2022 19:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C863C340E5;
        Mon, 24 Jan 2022 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053230;
        bh=o4vXwjtGO5bckZbOzF25uhyLz3mbp8Clz6bUC0ZiGSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUpzveh7nC8uOE/NkthwF7fMpdZJWvJ6fslIRb5vFAZ6ho408ZQgGpsfn+nroDBL1
         y5Cm8pneoEDB3GR1KD4YHNegtwTQ9z5BPLCq/SO/J7NEAQ+NW14VsAG6HNLgERRbay
         zPtrCIm/PK5cSI7362awXwwrbzNM43QchJ6//Gq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Doyle <pdoyle@irobot.com>,
        Richard Weinberger <richard@nod.at>,
        Yoshio Furuyama <ytc-mb-yfuruyama7@kioxia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 5.4 319/320] mtd: nand: bbt: Fix corner case in bad block table handling
Date:   Mon, 24 Jan 2022 19:45:03 +0100
Message-Id: <20220124184004.787407516@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doyle, Patrick <pdoyle@irobot.com>

commit fd0d8d85f7230052e638a56d1bfea170c488e6bc upstream.

In the unlikely event that both blocks 10 and 11 are marked as bad (on a
32 bit machine), then the process of marking block 10 as bad stomps on
cached entry for block 11.  There are (of course) other examples.

Signed-off-by: Patrick Doyle <pdoyle@irobot.com>
Reviewed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Yoshio Furuyama <ytc-mb-yfuruyama7@kioxia.com>
[<miquel.raynal@bootlin.com>: Fixed the title]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/linux-mtd/774a92693f311e7de01e5935e720a179fb1b2468.1616635406.git.ytc-mb-yfuruyama7@kioxia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/bbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/bbt.c
+++ b/drivers/mtd/nand/bbt.c
@@ -123,7 +123,7 @@ int nanddev_bbt_set_block_status(struct
 		unsigned int rbits = bits_per_block + offs - BITS_PER_LONG;
 
 		pos[1] &= ~GENMASK(rbits - 1, 0);
-		pos[1] |= val >> rbits;
+		pos[1] |= val >> (bits_per_block - rbits);
 	}
 
 	return 0;


