Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693446B5431
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 23:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCJWXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 17:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjCJWXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 17:23:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDDBBBB28;
        Fri, 10 Mar 2023 14:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E118B82422;
        Fri, 10 Mar 2023 22:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C91C433D2;
        Fri, 10 Mar 2023 22:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678487020;
        bh=pLqjpow77D3rK1zfQ77dw8Ngccz3kSkSYPNMZNpMVjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UT0/bMjFlrjlkiV2/744VuhEOv9BfD2M601JNBZQkozKGguqNrsbtA/csCaFuSZbs
         C54u9+I9Dt2V6wi8zambw3KVl4Iwm8QmrNm5IWuwBKtoO0fpopThOt2P3iS7rr+lli
         S1DjzpCJBzMaAeamMkT6oi6+8Esk3tKpazUoQ+c6drSHuOLSRveHYGA7kijAmzJUFR
         Oe4nAgoMMblBLrDq2OyUTgRBNcBLKuJYST/+yC4GB3OTE13Fzc8QPX6d/oducrnTh/
         pWOLNUT3g/WOk34Sm6fLu/RAtGRrPfdzkAtK7XyABUP+pGUxR+WqkP14gkM8yRkXLm
         s6SlehA47exqg==
Date:   Fri, 10 Mar 2023 14:23:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: factor out victim_entry usage from
 general rb_tree use
Message-ID: <ZAut6jcnytFJAen9@sol.localdomain>
References: <20230310210454.2350881-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310210454.2350881-1-jaegeuk@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 10, 2023 at 01:04:52PM -0800, Jaegeuk Kim wrote:
> Let's reduce the complexity of mixed use of rb_tree in victim_entry from
> extent_cache and discard_cmd.
> 
> This should fix arm32 memory alignment issue caused by shared rb_entry.
> 
> [struct victim_entry]              [struct rb_entry]
> [0] struct rb_node rb_node;        [0] struct rb_node rb_node;
>                                        union {
>                                          struct {
>                                            unsigned int ofs;
>                                            unsigned int len;
>                                          };
> [16] unsigned long long mtime;     [12] unsigned long long key;
>                                        } __packed;
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 093749e296e2 ("f2fs: support age threshold based garbage collection")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Thanks for fixing this properly.  It looks much better than the weird type
punning that was being done before...

> +static struct rb_node **f2fs_lookup_rb_tree_ext(struct f2fs_sb_info *sbi,
> +				struct rb_root_cached *root,
> +				struct rb_node **parent,
> +				unsigned long long mtime, bool *leftmost)

Call this f2fs_lookup_victim_entry()?

> +static bool f2fs_check_victim_tree(struct f2fs_sb_info *sbi,
> +				struct rb_root_cached *root)
> +{
> +#ifdef CONFIG_F2FS_CHECK_FS
> +	struct rb_node *cur = rb_first_cached(root), *next;
> +	struct victim_entry *cur_ve, *next_ve;
> +
> +	if (!cur)
> +		return true;
> +
> +	while (cur) {

The !cur check is redundant.

- Eric
