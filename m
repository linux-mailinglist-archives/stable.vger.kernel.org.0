Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEAF5495EB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353862AbiFMLcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354436AbiFML33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62822DEB2;
        Mon, 13 Jun 2022 03:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 166BAB80D3B;
        Mon, 13 Jun 2022 10:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D946C34114;
        Mon, 13 Jun 2022 10:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117077;
        bh=V1GtFLb2EmFO1qdCQwcxQ1MZesxtTbHhI2dcyqeSiJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2lOtXcKWcCgCId6zyra8AhksSLbw0mHG1wfgmu1JHL3rmeWXyh7igFweuV4bmJFy
         OEdVM6kHkyukekqnOvYDYX4HBYJcuiy8P74Wb5c0spRLIGXOwKi/zp0z1KkqOkT43K
         c3Dwsg6kEjW9CJfSLoy8wFJt3w8tYaoJezLzU8aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        Donald Buczek <buczek@molgen.mpg.de>
Subject: [PATCH 5.4 279/411] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Date:   Mon, 13 Jun 2022 12:09:12 +0200
Message-Id: <20220613094937.125477222@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 22b106e5355d6e7a9c3b5cb5ed4ef22ae585ea94 upstream.

Commit d92c370a16cb ("block: really clone the block cgroup in
bio_clone_blkg_association") changed bio_clone_blkg_association() to
just clone bio->bi_blkg reference from source to destination bio. This
is however wrong if the source and destination bios are against
different block devices because struct blkcg_gq is different for each
bdev-blkcg pair. This will result in IOs being accounted (and throttled
as a result) multiple times against the same device (src bdev) while
throttling of the other device (dst bdev) is ignored. In case of BFQ the
inconsistency can even result in crashes in bfq_bic_update_cgroup().
Fix the problem by looking up correct blkcg_gq for the cloned bio.

Reported-by: Logan Gunthorpe <logang@deltatee.com>
Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Fixes: d92c370a16cb ("block: really clone the block cgroup in bio_clone_blkg_association")
CC: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220602081242.7731-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -2179,7 +2179,7 @@ void bio_clone_blkg_association(struct b
 	rcu_read_lock();
 
 	if (src->bi_blkg)
-		__bio_associate_blkg(dst, src->bi_blkg);
+		bio_associate_blkg_from_css(dst, &bio_blkcg(src)->css);
 
 	rcu_read_unlock();
 }


