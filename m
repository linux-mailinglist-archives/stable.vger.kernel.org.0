Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13356C238B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 22:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCTVXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 17:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCTVXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 17:23:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF730B2C;
        Mon, 20 Mar 2023 14:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C77061812;
        Mon, 20 Mar 2023 21:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545A8C433EF;
        Mon, 20 Mar 2023 21:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679347383;
        bh=9HAxXDGx5xBbcjfjBF5G7zxK7OY/2qAbH411wxppUac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PUWAnrpI5ixthFY+eeRpKc8T09pJbyTVqFg9Uz2DOw2wSmOc0GjneDDSHQbw8sxJR
         k1L+3C+UdS2G2J28GQzq+bIUfgc/ayNsWjuPZ115fUFOgjKdwUF71ckbzTizE+In+j
         4XcjeBX250PyVs9lNsd1R/DRvbqb4pH3VJiKpmIDTVwZ2ot3Qfn9XS93j9uAbIWBQk
         MCmYhlh1c8fzy4bt8Wjh7NzoSrHv9wftvRsfGBhtRTbXpXTw8/aGJwfDEqW15JG3n3
         LizFnW1m0VTiXteYyitkkS4sRjiOqoNi6WBlS1Lv0z/s36ytn2CZ5t6iZH6NjcAd9D
         oI19YBH1tFFYw==
Date:   Mon, 20 Mar 2023 14:23:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Yeongjin Gil <youngjin.gil@samsung.com>
Cc:     agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sungjong Seo <sj1557.seo@samsung.com>
Subject: Re: [PATCH v2] dm verity: fix error handling for check_at_most_once
 on FEC
Message-ID: <20230320212301.GD1434@sol.localdomain>
References: <CGME20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132@epcas1p1.samsung.com>
 <20230320065932.28116-1-youngjin.gil@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320065932.28116-1-youngjin.gil@samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 03:59:32PM +0900, Yeongjin Gil wrote:
> In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
> directly. But if FEC configured, it is desired to correct the data page
> through verity_verify_io. And the return value will be converted to
> blk_status and passed to verity_finish_io().
> 
> BTW, when a bit is set in v->validated_blocks, verity_verify_io() skips
> verification regardless of I/O error for the corresponding bio. In this
> case, the I/O error could not be returned properly, and as a result,
> there is a problem that abnormal data could be read for the
> corresponding block.
> 
> To fix this problem, when an I/O error occurs, do not skip verification
> even if the bit related is set in v->validated_blocks.
> 
> Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
> ---
> v2:
> -change commit message and tag
> ---
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index ade83ef3b439..9316399b920e 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -523,7 +523,7 @@ static int verity_verify_io(struct dm_verity_io *io)
>  		sector_t cur_block = io->block + b;
>  		struct ahash_request *req = verity_io_hash_req(v, io);
>  
> -		if (v->validated_blocks &&
> +		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
>  		    likely(test_bit(cur_block, v->validated_blocks))) {
>  			verity_bv_skip_block(v, io, iter);
>  			continue;
> -- 

Looks good now, thanks!

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
