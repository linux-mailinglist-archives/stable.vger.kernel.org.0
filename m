Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6874ABCA5
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386993AbiBGLi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385678AbiBGLcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B23C0401CF;
        Mon,  7 Feb 2022 03:31:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32B73B8111C;
        Mon,  7 Feb 2022 11:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67714C004E1;
        Mon,  7 Feb 2022 11:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233502;
        bh=BLyOJI36eHMt72Wa5DjaMq8TiYzOPzbxdmmTZTFuakE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5lj6MudxBokfGNhilrYbXrsejSDtaBleDEr32pa4DV/YzWy1m7xjmJi/DUnTGgCd
         neHhHhPI1O0aiCtBJ/I2xbwPey7P751tgjw9PM0+w3UnDJwrRaQhqrai+z+QCW0378
         eQ2Wcy0+BYPB9P4oJgZgTnMuCKVnkEwMVMXS3zXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Dmitry Ivanov <dmitry.ivanov2@hpe.com>,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 033/126] block: bio-integrity: Advance seed correctly for larger interval sizes
Date:   Mon,  7 Feb 2022 12:06:04 +0100
Message-Id: <20220207103805.284934022@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

commit b13e0c71856817fca67159b11abac350e41289f5 upstream.

Commit 309a62fa3a9e ("bio-integrity: bio_integrity_advance must update
integrity seed") added code to update the integrity seed value when
advancing a bio. However, it failed to take into account that the
integrity interval might be larger than the 512-byte block layer
sector size. This broke bio splitting on PI devices with 4KB logical
blocks.

The seed value should be advanced by bio_integrity_intervals() and not
the number of sectors.

Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: stable@vger.kernel.org
Fixes: 309a62fa3a9e ("bio-integrity: bio_integrity_advance must update integrity seed")
Tested-by: Dmitry Ivanov <dmitry.ivanov2@hpe.com>
Reported-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20220204034209.4193-1-martin.petersen@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -373,7 +373,7 @@ void bio_integrity_advance(struct bio *b
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	bip->bip_iter.bi_sector += bytes_done >> 9;
+	bip->bip_iter.bi_sector += bio_integrity_intervals(bi, bytes_done >> 9);
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 


