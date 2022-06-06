Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A894C53ED5D
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiFFR5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 13:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiFFR5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 13:57:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115CB2F9AFE;
        Mon,  6 Jun 2022 10:57:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 89C5621B9B;
        Mon,  6 Jun 2022 17:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654538221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUB6r6nT4kAlF/JGpn/A9Zjm6xLLgzr4cLzF47XsUqo=;
        b=awusVAjcS5Dp6hyKRo+16lMrgtAILerEhpXzJ72fgec/yd38MwbiZjXsxnNaYi5zlE+zZT
        ifQ8d4t7P3On83LT5tmpqcTDc15wJmVDjrdZwjQ89/XzCdfREoiGC36kvMk7vB+e8uF1/0
        fgQsvhWrQ3m8fgqHrPjnNQQaEuIJ2CE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654538221;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WUB6r6nT4kAlF/JGpn/A9Zjm6xLLgzr4cLzF47XsUqo=;
        b=NQtLkYxU6om2SuS3q0QvJxLN7AeYikggev3/uFwjteIMnqkXN/lspw1WhKKdwtuP95l+87
        fEtgApdX42o2piAw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7726B2C142;
        Mon,  6 Jun 2022 17:57:01 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 2FF4EA063A; Mon,  6 Jun 2022 19:56:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     <linux-block@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Date:   Mon,  6 Jun 2022 19:56:41 +0200
Message-Id: <20220606175655.8993-6-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220606174118.10992-1-jack@suse.cz>
References: <20220606174118.10992-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1860; h=from:subject; bh=irukgdQK/KNSx5BYqIWY1nIBQgWrGIob468B0DBPsT0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBinj/YiIP/ZWe9jnGi4+zXKuPt708SNJFNSqBtJhZX 3TkPc0WJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYp4/2AAKCRCcnaoHP2RA2UTpCA CgJGmHJfmrXpFOY7IZPQYWH03BAUseGH9lXytArAtcAPpHHiHwmJ4ksEJgHPwqhclrS9bnysju6/S7 VA4bU9GUsL2LcQVB/xeBZP1sg/bFA5p5oKUGhMsqk4/76ERz7wunkfO2UcTpjkwU/KbjuSBI9hDIGe IlcC5wqlEQ80iby6gL5wVrNQX6lfie1fMmjoygEsw1aHImYWLYDon4p607uxWJ+TbjZbS6ZPfeEW7S qg/xB6A7Bh6ZnCWgMK15G7zJr4hMKsn1jEY9sAATPvJersvSj4BzI59szqSMuQlg5lCgoB/QR7i2i+ u2wa8VzsmUrvYd9EZ1E6wRcAZ6hySL
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
 block/blk-cgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5b19665bc486..484c6b2dd264 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1892,12 +1892,8 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	if (src->bi_blkg) {
-		if (dst->bi_blkg)
-			blkg_put(dst->bi_blkg);
-		blkg_get(src->bi_blkg);
-		dst->bi_blkg = src->bi_blkg;
-	}
+	if (src->bi_blkg)
+		bio_associate_blkg_from_css(dst, &bio_blkcg(src)->css);
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 
-- 
2.35.3

