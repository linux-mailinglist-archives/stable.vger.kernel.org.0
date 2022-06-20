Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC8551A91
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244696AbiFTNH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiFTNF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:05:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B800E1A044;
        Mon, 20 Jun 2022 06:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C2A9B811B9;
        Mon, 20 Jun 2022 13:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD1C3411B;
        Mon, 20 Jun 2022 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730021;
        bh=jEjmNSh47oqp7uebHlYwyx7toZeZXvjP9kh3xiYrcNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQR+yTBsFekN7oF6VPVg0bBgArZYU4yGbiyHtb2zxXJf6tyNeI6wlkVjaTPUakrGE
         6aLtKsc3cZJIZRt/2uTdIr4V0vGs/71VmfQdu9E0WB9xhAI3uuYCCHY2syaW2l8qtO
         XGNFsp1PrkCcGOrEnN/VoPz12C8/JXTW8ZenuD5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Subject: [PATCH 5.18 118/141] md/raid5-ppl: Fix argument order in bio_alloc_bioset()
Date:   Mon, 20 Jun 2022 14:50:56 +0200
Message-Id: <20220620124733.039144373@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

commit f34fdcd4a0e7a0b92340ad7e48e7bcff9393fab5 upstream.

bio_alloc_bioset() takes a block device, number of vectors, the
OP flags, the GFP mask and the bio set. However when the prototype
was changed, the callisite in ppl_do_flush() had the OP flags and
the GFP flags reversed. This introduced some sparse error:

  drivers/md/raid5-ppl.c:632:57: warning: incorrect type in argument 3
				    (different base types)
  drivers/md/raid5-ppl.c:632:57:    expected unsigned int opf
  drivers/md/raid5-ppl.c:632:57:    got restricted gfp_t [usertype]
  drivers/md/raid5-ppl.c:633:61: warning: incorrect type in argument 4
  				    (different base types)
  drivers/md/raid5-ppl.c:633:61:    expected restricted gfp_t [usertype]
				    gfp_mask
  drivers/md/raid5-ppl.c:633:61:    got unsigned long long

The sparse error introduction may not have been reported correctly by
0day due to other work that was cleaning up other sparse errors in this
area.

Fixes: 609be1066731 ("block: pass a block_device and opf to bio_alloc_bioset")
Cc: stable@vger.kernel.org # 5.18+
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5-ppl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -629,9 +629,9 @@ static void ppl_do_flush(struct ppl_io_u
 		if (bdev) {
 			struct bio *bio;
 
-			bio = bio_alloc_bioset(bdev, 0, GFP_NOIO,
+			bio = bio_alloc_bioset(bdev, 0,
 					       REQ_OP_WRITE | REQ_PREFLUSH,
-					       &ppl_conf->flush_bs);
+					       GFP_NOIO, &ppl_conf->flush_bs);
 			bio->bi_private = io;
 			bio->bi_end_io = ppl_flush_endio;
 


