Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEEE1515591
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 22:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380676AbiD2Ub5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 16:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiD2Ub4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 16:31:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE13D5EA5;
        Fri, 29 Apr 2022 13:28:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2A2821F894;
        Fri, 29 Apr 2022 20:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651264116;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hc9AaVP53iHZIiBs2rA9+w/nGzXOcurXV1kB68peBLg=;
        b=v8IRUwo90EMDMmw4mKD/0Qric38qC+/BbIyY097qvhboxiiZO8QY0W+xtezkyCDXxcdA3P
        AkXdgLjvPxqJwXxKcd0xbO44nrVgnlv1GuUiUb0mPcCRLfwxwnIaYXgz54sqNT5DD9mQNA
        BoYhwW6L3/0iuQ7nv7k3ba32bMHwTWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651264116;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hc9AaVP53iHZIiBs2rA9+w/nGzXOcurXV1kB68peBLg=;
        b=uVScP6cP4wwieDg5J1mW3VneGdtOKt9kMETG5GociDauqToO6MLdF1gd1A0qdJnmcbPlPS
        PUl6NOHDVdXgXxCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB1DB13446;
        Fri, 29 Apr 2022 20:28:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sXV8OHNKbGIhFAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Fri, 29 Apr 2022 20:28:35 +0000
Date:   Fri, 29 Apr 2022 22:24:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: force v2 space cache usage for subpage mount
Message-ID: <20220429202427.GJ18596@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Matt Corallo <blnxfsl@bluematt.me>,
        stable@vger.kernel.org
References: <1f622305ee7ecb3b6ec09f878c26ad0446e18311.1648798164.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f622305ee7ecb3b6ec09f878c26ad0446e18311.1648798164.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 01, 2022 at 03:29:37PM +0800, Qu Wenruo wrote:
> [BUG]
> For a 4K sector sized btrfs with v1 cache enabled and only mounted on
> systems with 4K page size, if it's mounted on subpage (64K page size)
> systems, it can cause the following warning on v1 space cache:
> 
>  BTRFS error (device dm-1): csum mismatch on free space cache
>  BTRFS warning (device dm-1): failed to load free space cache for block group 84082688, rebuilding it now
> 
> Although not a big deal, as kernel can rebuild it without problem, such
> warning will bother end users, especially if they want to switch the
> same btrfs seamlessly between different page sized systems.
> 
> [CAUSE]
> V1 free space cache is still using fixed PAGE_SIZE for various bitmap,
> like BITS_PER_BITMAP.
> 
> Such hard-coded PAGE_SIZE usage will cause various mismatch, from v1
> cache size to checksum.
> 
> Thus kernel will always reject v1 cache with a different PAGE_SIZE with
> csum mismatch.
> 
> [FIX]
> Although we should fix v1 cache, it's already going to be marked
> deprecated soon.
> 
> And we have v2 cache based on metadata (which is already fully subpage
> compatible), and it has almost everything superior than v1 cache.
> 
> So just force subpage mount to use v2 cache on mount.
> 
> Reported-by: Matt Corallo <blnxfsl@bluematt.me>
> CC: stable@vger.kernel.org # 5.15+
> Link: https://lore.kernel.org/linux-btrfs/61aa27d1-30fc-c1a9-f0f4-9df544395ec3@bluematt.me/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
