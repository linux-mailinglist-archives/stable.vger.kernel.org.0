Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195CA4997DC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449787AbiAXVRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377749AbiAXVMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E3CC02B779;
        Mon, 24 Jan 2022 12:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8DDD6131E;
        Mon, 24 Jan 2022 20:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCFFC340E5;
        Mon, 24 Jan 2022 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054972;
        bh=o4vXwjtGO5bckZbOzF25uhyLz3mbp8Clz6bUC0ZiGSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jaBrNmqwKlDDLCXsWwcVJttl2rS05jt9L46XRYOH2oMizawFPXOJ3m0VyKP+uJ5J
         b6bQZf2KtMcnbxJFT8uurx1/fVkYyVgXO96Q8nJyz/FZ097tKLXU/nTTWO33hTZGom
         VW57YzDdoEhEyMKxAUVX8s5yY49RLb6wTOgb7RFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Doyle <pdoyle@irobot.com>,
        Richard Weinberger <richard@nod.at>,
        Yoshio Furuyama <ytc-mb-yfuruyama7@kioxia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 5.10 562/563] mtd: nand: bbt: Fix corner case in bad block table handling
Date:   Mon, 24 Jan 2022 19:45:27 +0100
Message-Id: <20220124184043.886778071@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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


