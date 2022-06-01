Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1D53AC1F
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 19:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354124AbiFARmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 13:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352351AbiFARmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 13:42:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F6E562F5;
        Wed,  1 Jun 2022 10:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BgNUX8C4C5dSbDctWdWKZdF5CNkQMgBr9Y2XYkkie84=; b=C4bp+UOhckd9fn8goR7eqbq4ma
        eZTZAKGwURzY4p6S0wLybt2XX3sTKJ23GAccY8ngfFGDgDwwSa/GFYoIQ7/r6crjEGyC4GlKukWEc
        9SghjMt1xmYgz5il4tyT35l0bct01WnjpugTUcN7gz8yegk9CgOUe2Lu4w4srt0UAkaV3/UeO0HxT
        P+qCrfmn63IogS+3Tq9Il/+AbAXwT0fM5UPpgGBDhLAYdJAfbNSCNl7INttayrYHu5CkeK7Ivkwqv
        CtLsN1w/LrfJ/bxwUozXQHsO0N5DqticYyOLhh8Yki7xGQN7Uly+4Y5Djf5C9FcJUgZ4JClFUnoms
        Pgor1k2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwSMa-00HL12-C6; Wed, 01 Jun 2022 17:42:32 +0000
Date:   Wed, 1 Jun 2022 10:42:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Donald Buczek <buczek@molgen.mpg.de>, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix bio_clone_blkg_association() to associate
 with proper blkcg_gq
Message-ID: <YpelCJ66S9KaYg+0@infradead.org>
References: <20220601163405.29478-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601163405.29478-1-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 01, 2022 at 06:34:05PM +0200, Jan Kara wrote:
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1975,10 +1975,9 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
>  void bio_clone_blkg_association(struct bio *dst, struct bio *src)
>  {
>  	if (src->bi_blkg) {
> +		rcu_read_lock();
> +		bio_associate_blkg_from_css(dst, bio_blkcg_css(src));
> +		rcu_read_unlock();

What do we even need the rcu critical section here?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
