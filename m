Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89CC6D9B7F
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 17:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbjDFPBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 11:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjDFPB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 11:01:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D495FCE;
        Thu,  6 Apr 2023 08:01:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0FBFC2277B;
        Thu,  6 Apr 2023 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680793285;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GrBSwir/t5aq/ntukGrdDdoFjsalvp8DcR2I2ccKDw0=;
        b=vRDG+ufPe9pkq8l7Ey54rGVuAitnd27gdlOX7o3EwJ3tki9UlG+R1j0xTdXJuY5f14iVwG
        pjZHzG/ceI4C2ALIBGxvBjM9ctRIX5ffyGklr28BoCxRaj5S+130Ig/NPIYq3E8X9NdRz4
        tY680hC91DsiGeDaVe/oJsNhQhmZhhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680793285;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GrBSwir/t5aq/ntukGrdDdoFjsalvp8DcR2I2ccKDw0=;
        b=8iKvyeTTTFjfwRhg344f/JR7LUEjf/ABOkmu979zoUOT+6ytXkrbHiJW1f4O0fds2A7cqw
        aC2lIueMiBj3cgBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E801E133E5;
        Thu,  6 Apr 2023 15:01:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sw/iN8TeLmS8PwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 06 Apr 2023 15:01:24 +0000
Date:   Thu, 6 Apr 2023 17:01:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: reject unsupported scrub flags
Message-ID: <20230406150122.GS19619@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <df2418c0b26dc12913d5f542caf977bc3d1f28b2.1680757087.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df2418c0b26dc12913d5f542caf977bc3d1f28b2.1680757087.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 01:00:34PM +0800, Qu Wenruo wrote:
> Since the introduction of scrub interface, the only flag that we support
> is BTRFS_SCRUB_READONLY.
> 
> Thus there is no sanity checks, if there are some undefined flags passed
> in, we just ignore them.
> 
> This is problematic if we want to introduce new scrub flags, as we have
> no way to determine if such flags are supported.
> 
> Thus this patch would address the problem by introducing a check for the
> flags, and if unsupported flags are set, return -EOPNOTSUPP to inform
> the user space.
> 
> This check should be backported for all supported kernels before any new
> scrub flags are introduced.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
