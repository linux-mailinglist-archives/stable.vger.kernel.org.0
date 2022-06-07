Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CF153F941
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 11:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239099AbiFGJPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 05:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239074AbiFGJPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 05:15:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EF0AFAE1;
        Tue,  7 Jun 2022 02:15:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9F4F421B78;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654593329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ii05atEF00YMJ+cIpsYGnGaF+aCI0IEq4yGVXlod3w=;
        b=lliEZP8Gakqdo6WzXRYwtnen3Lg7+WpiDnGMkmRkqdNkClTTozk2I024k+HWKjxUdV2bxC
        GvWxgKgq06KBY5zyXisevfP5vGSI2WH3g1uXMa54lXUTsdZDNmy5iJWg7IhVcjVB+KgPL4
        Ve/Vn0GnRscW+wtpz5nj7kVE4qq5qTQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654593329;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ii05atEF00YMJ+cIpsYGnGaF+aCI0IEq4yGVXlod3w=;
        b=FxeGHSX8vUGwvc3QQloqKhaFZeIkJPaU2s8+NRLKw3/uPxbnSAHG0fQSoiPNDLw6tg21C6
        t61Y9wc1uPrvTIDQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 601742C142;
        Tue,  7 Jun 2022 09:15:29 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 9FC44A063A; Tue,  7 Jun 2022 11:15:28 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        <linux-block@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Date:   Tue,  7 Jun 2022 11:15:14 +0200
Message-Id: <20220607091528.11906-6-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220607091209.24033-1-jack@suse.cz>
References: <20220607091209.24033-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1666; h=from:subject; bh=ie/QQClk1abjXbvdvx/E2/2QpV2ElofdhAw8aV40hDc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinxch7/QAIxj2oZkQt+uJQJOAu7XVxAVDy/HI6BxQ iFF/uuSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp8XIQAKCRCcnaoHP2RA2co5B/ wLCxI4IAm+CLh73XB9CvQ0urk7b0l5MUaRKAqx+npYIkJ+KelwAUXiF0aXNA+OS64oJHDoy+p61JIL 1n+hONX/yGRT65+F55q44X0olU2suk9dRyeLnZc3gzJJWQZDR2KwMlKn/xwB8Kf12+/vtRbpecrSeW cQFabILBGZRkgW3xOaFbqEMgPC0ich8nZFl/wc+ehnTxfmTQg9tZq8BqfG4lbRvhpGs4s8rkf01eru RRvPrZZNOKCD9ChYd+eXMbP02mfuTyGmn9JiCdUBDd3nYSp5dtUmux7K00q+PXI6xVkuWDvObKbIAW /QM2fGIce5tK9Eqi0ik8D+TWPsjSHK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 40004a3631a8..08dbdc32ceaa 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2179,7 +2179,7 @@ void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 	rcu_read_lock();
 
 	if (src->bi_blkg)
-		__bio_associate_blkg(dst, src->bi_blkg);
+		bio_associate_blkg_from_css(dst, &bio_blkcg(src)->css);
 
 	rcu_read_unlock();
 }
-- 
2.35.3

