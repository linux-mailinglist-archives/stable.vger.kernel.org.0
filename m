Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CBE540326
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiFGPzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244816AbiFGPzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:55:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D64C6251;
        Tue,  7 Jun 2022 08:55:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2A42E1F989;
        Tue,  7 Jun 2022 15:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654617320;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=No0KZSTAEPBqDau1MkLe8lBUEohLqNAznor269bQn28=;
        b=Ln8K32k4nQe9NsHmcDkRbB7BDS+IKjUYJFvqqltJt30b4Oabx78AMUqV/EmixuSUOrotFq
        ZzMMUSReCX9gsIwZxWPbgJZy+eVJFPpz2jigvqDfjNquw/stDPRXvxIZhZQDDIVWYpmdtE
        YEsMfD0SjA3owCIIUlcIU0qPMgp0vSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654617320;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=No0KZSTAEPBqDau1MkLe8lBUEohLqNAznor269bQn28=;
        b=QSu/khA7YLwzLb72Y15eWkpjzuVkAgW9g7P528BASqjKecA19OmfzgC+46vyo23IkA3nrN
        MnC8BnIMmxyUrkAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0439813638;
        Tue,  7 Jun 2022 15:55:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id clk+AOh0n2IHbQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 07 Jun 2022 15:55:20 +0000
Date:   Tue, 7 Jun 2022 17:50:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: reject log replay if there is unsupported RO
 flag
Message-ID: <20220607155050.GL20633@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <a6612cd9432b8ae6429cceee561c0259232cc554.1654602414.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6612cd9432b8ae6429cceee561c0259232cc554.1654602414.git.wqu@suse.com>
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

On Tue, Jun 07, 2022 at 07:48:24PM +0800, Qu Wenruo wrote:
> [BUG]
> If we have a btrfs image with dirty log, along with an unsupported RO
> compatible flag:
> 
> log_root		30474240
> ...
> compat_flags		0x0
> compat_ro_flags		0x40000003
> 			( FREE_SPACE_TREE |
> 			  FREE_SPACE_TREE_VALID |
> 			  unknown flag: 0x40000000 )
> 
> Then even if we can only mount it RO, we will still cause metadata
> update for log replay:
> 
>  BTRFS info (device dm-1): flagging fs with big metadata feature
>  BTRFS info (device dm-1): using free space tree
>  BTRFS info (device dm-1): has skinny extents
>  BTRFS info (device dm-1): start tree-log replay
> 
> This is definitely against RO compact flag requirement.
> 
> [CAUSE]
> RO compact flag only forces us to do RO mount, but we will still do log
> replay for plain RO mount.
> 
> Thus this will result us to do log replay and update metadata.
> 
> This can be very problematic for new RO compat flag, for example older
> kernel can not understand v2 cache, and if we allow metadata update on
> RO mount and invalidate/corrupt v2 cache.
> 
> [FIX]
> Just reject the mount unless rescue=nologreplay is provided:

I agree that it's better to fail the mount and keep the log. The way out
of that is to use newer kernel that supports it or explicitly clear the
log.

>   BTRFS error (device dm-1): cannot replay dirty log with unsupport optional features (0x40000000), try rescue=nologreplay instead
> 
> We don't want to set rescue=nologreply directly, as this would make the
> end user to read the old data, and cause confusion.
> 
> Since the such case is really rare, we're mostly fine to just reject the
> mount with an error message, which also includes the proper workaround.

I think this is a use case for 'btrfs rescue zero-log' that is not
caused by a bug in the tree log code (ie. the original purpose for the
tool), so this should be also documented.
