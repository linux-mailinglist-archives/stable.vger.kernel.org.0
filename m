Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A651519161
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 00:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiECW2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 18:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiECW2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 18:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF57424AF;
        Tue,  3 May 2022 15:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C221261743;
        Tue,  3 May 2022 22:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED467C385A9;
        Tue,  3 May 2022 22:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651616702;
        bh=Gq/fueWpXLku85WUlyGq7Fe4Dx3APSdMq6q4gayT7PM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xxr/MaWDJqiadPMG7VGDJpekoL14jhrzBzbHxiLQ0q8CJwi41o1G230jImRmQRWdx
         Q4of6lxctHxejbnevqTjyFSWGWlqx7WF26O4p2/ardn6n47tByAcpnrSwT/xAhUF8C
         kXsxoBdtCnANrlpHbzxETth9Jymp/8ZEsHhRYCcb3NS6uA+qW96HXjlSMLpiP8IIv8
         yEoSuzPl4+HDUkZJzvalQpQj5lkvIaL7RjIWYEG4M/4khabFgFU2Tu+7U38VdPEXz/
         HkaU/+5LSTiwE0VVWJcqXyYQb/k3F91/VIgTC/Lug2NH89VIeK7ad87/JhHlmIUeCu
         zoJjGr5G5ybGQ==
Date:   Tue, 3 May 2022 15:25:00 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ming Yan <yanming@tju.edu.cn>, Chao Yu <chao.yu@oppo.com>
Subject: Re: [PATCH] f2fs: fix deadloop in foreground GC
Message-ID: <YnGrvEjxgaXDnxxi@google.com>
References: <20220429204631.7241-1-chao@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429204631.7241-1-chao@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/30, Chao Yu wrote:
> As Yanming reported in bugzilla:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=215914
> 
> The root cause is: in a very small sized image, it's very easy to
> exceed threshold of foreground GC, if we calculate free space and
> dirty data based on section granularity, in corner case,
> has_not_enough_free_secs() will always return true, result in
> deadloop in f2fs_gc().

Performance regression was reported. Can we check this for very small sized
image only?

> 
> So this patch refactors has_not_enough_free_secs() as below to fix
> this issue:
> 1. calculate needed space based on block granularity, and separate
> all blocks to two parts, section part, and block part, comparing
> section part to free section, and comparing block part to free space
> in openned log.
> 2. account F2FS_DIRTY_NODES, F2FS_DIRTY_IMETA and F2FS_DIRTY_DENTS
> as node block consumer;
> 3. account F2FS_DIRTY_DENTS as data block consumer;
> 
> Cc: stable@vger.kernel.org
> Reported-by: Ming Yan <yanming@tju.edu.cn>
> Signed-off-by: Chao Yu <chao.yu@oppo.com>
> ---
>  fs/f2fs/segment.h | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 8a591455d796..28f7aa9b40bf 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -575,11 +575,10 @@ static inline int reserved_sections(struct f2fs_sb_info *sbi)
>  	return GET_SEC_FROM_SEG(sbi, reserved_segments(sbi));
>  }
>  
> -static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi)
> +static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi,
> +			unsigned int node_blocks, unsigned int dent_blocks)
>  {
> -	unsigned int node_blocks = get_pages(sbi, F2FS_DIRTY_NODES) +
> -					get_pages(sbi, F2FS_DIRTY_DENTS);
> -	unsigned int dent_blocks = get_pages(sbi, F2FS_DIRTY_DENTS);
> +
>  	unsigned int segno, left_blocks;
>  	int i;
>  
> @@ -605,19 +604,24 @@ static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi)
>  static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi,
>  					int freed, int needed)
>  {
> -	int node_secs = get_blocktype_secs(sbi, F2FS_DIRTY_NODES);
> -	int dent_secs = get_blocktype_secs(sbi, F2FS_DIRTY_DENTS);
> -	int imeta_secs = get_blocktype_secs(sbi, F2FS_DIRTY_IMETA);
> +	unsigned int total_node_blocks = get_pages(sbi, F2FS_DIRTY_NODES) +
> +					get_pages(sbi, F2FS_DIRTY_DENTS) +
> +					get_pages(sbi, F2FS_DIRTY_IMETA);
> +	unsigned int total_dent_blocks = get_pages(sbi, F2FS_DIRTY_DENTS);
> +	unsigned int node_secs = total_node_blocks / BLKS_PER_SEC(sbi);
> +	unsigned int dent_secs = total_dent_blocks / BLKS_PER_SEC(sbi);
> +	unsigned int node_blocks = total_node_blocks % BLKS_PER_SEC(sbi);
> +	unsigned int dent_blocks = total_dent_blocks % BLKS_PER_SEC(sbi);
>  
>  	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
>  		return false;
>  
> -	if (free_sections(sbi) + freed == reserved_sections(sbi) + needed &&
> -			has_curseg_enough_space(sbi))
> -		return false;
> -	return (free_sections(sbi) + freed) <=
> -		(node_secs + 2 * dent_secs + imeta_secs +
> -		reserved_sections(sbi) + needed);
> +	if (free_sections(sbi) + freed <=
> +			node_secs + dent_secs + reserved_sections(sbi) + needed)
> +		return true;
> +	if (!has_curseg_enough_space(sbi, node_blocks, dent_blocks))
> +		return true;
> +	return false;
>  }
>  
>  static inline bool f2fs_is_checkpoint_ready(struct f2fs_sb_info *sbi)
> -- 
> 2.32.0
