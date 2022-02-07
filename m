Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03FD4ABB43
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384303AbiBGL1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380436AbiBGLSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856D1C03FEC0;
        Mon,  7 Feb 2022 03:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C26561451;
        Mon,  7 Feb 2022 11:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F12C004E1;
        Mon,  7 Feb 2022 11:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232682;
        bh=iXGDTNBF+FlYxOjJCdOesONE//qh5SKJfvahh3dVTsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmXAUgmfHA31t6ZUeip/MPnhABg8pUveOVLHvy8wqGOUYNAt4pyP34m8xLwu9Rs+k
         QrIwNEvvgYxyiab5QK5Um68w2W/3V8j1OZ54O0CfVgVtIz4Tyjjx9YxVkk16+8pMp2
         ij4nCYegvd7B2feDS0T9HfUvnhcMdyMzaee+GkXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>,
        Dmitry Ivanov <dmitry.ivanov2@hpe.com>,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 62/86] block: bio-integrity: Advance seed correctly for larger interval sizes
Date:   Mon,  7 Feb 2022 12:06:25 +0100
Message-Id: <20220207103759.599619195@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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
@@ -399,7 +399,7 @@ void bio_integrity_advance(struct bio *b
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	bip->bip_iter.bi_sector += bytes_done >> 9;
+	bip->bip_iter.bi_sector += bio_integrity_intervals(bi, bytes_done >> 9);
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 EXPORT_SYMBOL(bio_integrity_advance);


