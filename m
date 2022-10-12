Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4A5FC5CA
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 15:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJLNBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 09:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJLNBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 09:01:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCC42700;
        Wed, 12 Oct 2022 06:01:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 96FD221E5F;
        Wed, 12 Oct 2022 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665579711;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ow3cw4JlyoLITqPKZ7rmGOf5DZypBIDDz4xaPhgVi6M=;
        b=u503n1p2Ark1GuEffAyqjUwCRw4E6OFa+hDwqF1OzqyN551pnEhvt5Z86gnTut02yOq+vK
        8+mXw+IE0uIyFs7Ey6M+vZT9K7fxHSbEQVUMs7DeszOZCpwx729X87EWrfwJFUxUaCcjLT
        c3yGwRsaBzvV73xKIRUyFc1+SpUviOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665579711;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ow3cw4JlyoLITqPKZ7rmGOf5DZypBIDDz4xaPhgVi6M=;
        b=SrYY1712Av/PpT11639oBzmcGrL56eQ3plaqiaeqO6NvF8pR5h6XiAVcoxRNCoaw2zCX9t
        kzyIFG6V8bZotvAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B32313ACD;
        Wed, 12 Oct 2022 13:01:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id okVlEb+6RmMnbQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 12 Oct 2022 13:01:51 +0000
Date:   Wed, 12 Oct 2022 15:01:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 41/46] btrfs: relax block-group-tree feature
 dependency checks
Message-ID: <20221012130145.GY13389@suse.cz>
Reply-To: dsterba@suse.cz
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-41-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011145015.1622882-41-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 10:50:09AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit d7f67ac9a928fa158a95573406eac0a887bbc28c ]
> 
> [BUG]
> When one user did a wrong attempt to clear block group tree, which can
> not be done through mount option, by using "-o clear_cache,space_cache=v2",
> it will cause the following error on a fs with block-group-tree feature:
> 
>   BTRFS info (device dm-1): force clearing of disk cache
>   BTRFS info (device dm-1): using free space tree
>   BTRFS info (device dm-1): clearing free space tree
>   BTRFS info (device dm-1): clearing compat-ro feature flag for FREE_SPACE_TREE (0x1)
>   BTRFS info (device dm-1): clearing compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
>   BTRFS error (device dm-1): block-group-tree feature requires fres-space-tree and no-holes
>   BTRFS error (device dm-1): super block corruption detected before writing it to disk
>   BTRFS: error (device dm-1) in write_all_supers:4318: errno=-117 Filesystem corrupted (unexpected superblock corruption detected)
>   BTRFS warning (device dm-1: state E): Skipping commit of aborted transaction.
> 
> [CAUSE]
> Although the dependency for block-group-tree feature is just an
> artificial one (to reduce test matrix), we put the dependency check into
> btrfs_validate_super().
> 
> This is too strict, and during space cache clearing, we will have a
> window where free space tree is cleared, and we need to commit the super
> block.
> 
> In that window, we had block group tree without v2 cache, and triggered
> the artificial dependency check.
> 
> This is not necessary at all, especially for such a soft dependency.
> 
> [FIX]
> Introduce a new helper, btrfs_check_features(), to do all the runtime
> limitation checks, including:
> 
> - Unsupported incompat flags check
> 
> - Unsupported compat RO flags check
> 
> - Setting missing incompat flags
> 
> - Artificial feature dependency checks
>   Currently only block group tree will rely on this.
> 
> - Subpage runtime check for v1 cache
> 
> With this helper, we can move quite some checks from
> open_ctree()/btrfs_remount() into it, and just call it after
> btrfs_parse_options().
> 
> Now "-o clear_cache,space_cache=v2" will not trigger the above error
> anymore.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> [ edit messages ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this from the stable queue, it's for an unreleased feature
(ETA 6.1).
