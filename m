Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84264FEA88
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 01:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiDLXTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 19:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiDLXTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 19:19:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BCE5A0A7;
        Tue, 12 Apr 2022 16:09:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CD52821123;
        Tue, 12 Apr 2022 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649796309;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uroCVTDUvGxAGQ6+YBaIsNIKOS4tCEuR8Decr5uQVQc=;
        b=3WV0wOcaPDun0Zwtk7QJ793Fitj5zsPOj0Vosa9cLfb7xEuE/QePKehmicMVOcmYzGoXhb
        2Pp8GFOWELdtwKM/ULnZ3UfiXhMs4kEzfRytVLrOCvxEnkCYl/4Z/Um20mFZWNR6Tobx+w
        CsTqZuKzocbKrv91MtyAkhpVJmWU5+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649796309;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uroCVTDUvGxAGQ6+YBaIsNIKOS4tCEuR8Decr5uQVQc=;
        b=ipOtkGCACXjvuhkBcW22ftfnOS06KBnD+eF5YvTZS7+vp5SF8DdY4vJt4ZIW54MWZ6xWhY
        F7OZGEo7zu67OZCQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id C45DEA3B82;
        Tue, 12 Apr 2022 20:45:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87EC9DA7B0; Tue, 12 Apr 2022 22:41:04 +0200 (CEST)
Date:   Tue, 12 Apr 2022 22:41:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: avoid double clean up when
 submit_one_bio() failed
Message-ID: <20220412204104.GA15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649766550.git.wqu@suse.com>
 <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b13dccbc4d6e066530587d6c00c54b10c3d00d7.1649766550.git.wqu@suse.com>
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

On Tue, Apr 12, 2022 at 08:30:13PM +0800, Qu Wenruo wrote:
> [BUG]
> When running generic/475 with 64K page size and 4K sector size, it has a
> very high chance (almost 100%) to hang, with mostly data page locked but
> no one is going to unlock it.
> 
> [CAUSE]
> With commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
> reads"), if we failed to lookup checksum due to metadata IO error, we
> will return error for btrfs_submit_data_bio().
> 
> This will cause the page to be unlocked twice in btrfs_do_readpage():
> 
>  btrfs_do_readpage()
>  |- submit_extent_page()
>  |  |- submit_one_bio()
>  |     |- btrfs_submit_data_bio()
>  |        |- if (ret) {
>  |        |-     bio->bi_status = ret;
>  |        |-     bio_endio(bio); }
>  |               In the endio function, we will call end_page_read()
>  |               and unlock_extent() to cleanup the subpage range.
>  |
>  |- if (ret) {
>  |-        unlock_extent(); end_page_read() }
>            Here we unlock the extent and cleanup the subpage range
>            again.
> 
> For unlock_extent(), it's mostly double unlock safe.
> 
> But for end_page_read(), it's not, especially for subpage case,
> as for subpage case we will call btrfs_subpage_end_reader() to reduce
> the reader number, and use that to number to determine if we need to
> unlock the full page.
> 
> If double accounted, it can underflow the number and leave the page
> locked without anyone to unlock it.
> 
> [FIX]
> The commit 1784b7d502a9 ("btrfs: handle csum lookup errors properly on
> reads") itself is completely fine, it's our existing code not properly
> handling the error from bio submission hook properly.
> 
> This patch will make submit_one_bio() to return void so that the callers
> will never be able to do cleanup when bio submission hook fails.
> 
> CC: stable@vger.kernel.org # 5.18+

BTW stable tags are only for released kernels, if it's still in some rc
then Fixes: is appropriate.
