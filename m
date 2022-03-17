Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CB94DCEAC
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 20:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbiCQTUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 15:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiCQTUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 15:20:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AE11A7770;
        Thu, 17 Mar 2022 12:19:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BB69E210EB;
        Thu, 17 Mar 2022 19:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647544759;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GA/iXeu+kqE0tAWTLqgPwmosvMWmgP5VfMy6nqbLXFA=;
        b=OcgigAWwmsSSRH889WMS2m9k0eDXDmJPEvLr5uvho9mSU7T6FeUhixpiOep4Jynr2s6bO2
        VEzAkjKX6/T30FwVg58UECaWIplZgByh6sTI8HLvtTwiX0vm9OBCfKt2zqRQ/aEOlbhPE3
        RD+Ks4dYqB1lTwzcoYEoOYNxhMYyaco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647544759;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GA/iXeu+kqE0tAWTLqgPwmosvMWmgP5VfMy6nqbLXFA=;
        b=nP/N3UVKQnFKAlBb+YIzOTVlTMY5MnS1jMwfHaYxjrBVhm7rnp1w0yjOsXRFEBr7zTFW8b
        wYFPp4KcZgVuPDBQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id B216DA3B81;
        Thu, 17 Mar 2022 19:19:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D5F9DDA7E1; Thu, 17 Mar 2022 20:15:19 +0100 (CET)
Date:   Thu, 17 Mar 2022 20:15:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: avoid defragging extents whose next extents
 are not targets
Message-ID: <20220317191519.GD12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <ea541c3e37b6531e709eefe81541f8c20b4cfc82.1647343600.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea541c3e37b6531e709eefe81541f8c20b4cfc82.1647343600.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 15, 2022 at 07:28:05PM +0800, Qu Wenruo wrote:
> [BUG]
> There is a report that autodefrag is defragging single sector, which
> is completely waste of IO, and no help for defragging:
> 
>    btrfs-cleaner-808 defrag_one_locked_range: root=256 ino=651122 start=0 len=4096
> 
> [CAUSE]
> In defrag_collect_targets(), we check if the current range (A) can be merged
> with next one (B).
> 
> If mergeable, we will add range A into target for defrag.
> 
> However there is a catch for autodefrag, when checking mergebility against
> range B, we intentionally pass 0 as @newer_than, hoping to get a
> higher chance to merge with the next extent.
> 
> But in next iteartion, range B will looked up by defrag_lookup_extent(),
> with non-zero @newer_than.
> 
> And if range B is not really newer, it will rejected directly, causing
> only range A being defragged, while we expect to defrag both range A and
> B.
> 
> [FIX]
> Since the root cause is the difference in check condition of
> defrag_check_next_extent() and defrag_collect_targets(), we fix it by:
> 
> 1. Pass @newer_than to defrag_check_next_extent()
> 2. Pass @extent_thresh to defrag_check_next_extent()
> 
> This makes the check between defrag_collect_targets() and
> defrag_check_next_extent() more consistent.
> 
> While there is still some minor difference, the remaining checks are
> focus on runtime flags like writeback/delalloc, which are mostly
> transient and safe to be checked only in defrag_collect_targets().
> 
> Link: https://github.com/btrfs/linux/issues/423#issuecomment-1066981856
> Cc: stable@vger.kernel.org # 5.16+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Add proper CC to stable
> - Use Link: tag to replace Issue: tag
>   As every developer/maintainer has their own btrfs tree, Issue: tag is
>   really confusing

Added to misc-next, thanks.
