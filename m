Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE82C6E645C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjDRMs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjDRMsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879D83C24
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67F506326B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D7FC433D2;
        Tue, 18 Apr 2023 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822095;
        bh=4e8JJtLHcDekISQnK6SwhspKcONFIcst1loA1gR9nec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12Y7PxZQtLm7tSPhd/LU3hRSPO/9v3JKX30VI+cN7GbZDCMUlEydPVXkuzX1C58FS
         xXinITzvQPvgACUUuX/hdRzn/jlzDsUkr2T318YxC08sxmhd1lVsW3NCEIt5WwMdaY
         WbRd9JHqJZGkUEVk98R5oVdEXQn9u6hlSKpV9D/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bang Li <libang.linuxer@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.2 021/139] mtdblock: tolerate corrected bit-flips
Date:   Tue, 18 Apr 2023 14:21:26 +0200
Message-Id: <20230418120314.444607265@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bang Li <libang.linuxer@gmail.com>

commit 0c3089601f064d80b3838eceb711fcac04bceaad upstream.

mtd_read() may return -EUCLEAN in case of corrected bit-flips.This
particular condition should not be treated like an error.

Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Fixes: e47f68587b82 ("mtd: check for max_bitflips in mtd_read_oob()")
Cc: <stable@vger.kernel.org> # v3.7
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230328163012.4264-1-libang.linuxer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdblock.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -153,7 +153,7 @@ static int do_cached_write (struct mtdbl
 				mtdblk->cache_state = STATE_EMPTY;
 				ret = mtd_read(mtd, sect_start, sect_size,
 					       &retlen, mtdblk->cache_data);
-				if (ret)
+				if (ret && !mtd_is_bitflip(ret))
 					return ret;
 				if (retlen != sect_size)
 					return -EIO;
@@ -188,8 +188,12 @@ static int do_cached_read (struct mtdblk
 	pr_debug("mtdblock: read on \"%s\" at 0x%lx, size 0x%x\n",
 			mtd->name, pos, len);
 
-	if (!sect_size)
-		return mtd_read(mtd, pos, len, &retlen, buf);
+	if (!sect_size) {
+		ret = mtd_read(mtd, pos, len, &retlen, buf);
+		if (ret && !mtd_is_bitflip(ret))
+			return ret;
+		return 0;
+	}
 
 	while (len > 0) {
 		unsigned long sect_start = (pos/sect_size)*sect_size;
@@ -209,7 +213,7 @@ static int do_cached_read (struct mtdblk
 			memcpy (buf, mtdblk->cache_data + offset, size);
 		} else {
 			ret = mtd_read(mtd, pos, size, &retlen, buf);
-			if (ret)
+			if (ret && !mtd_is_bitflip(ret))
 				return ret;
 			if (retlen != size)
 				return -EIO;


