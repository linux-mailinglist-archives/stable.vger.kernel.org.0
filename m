Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15455AD59E
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbiIEO6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiIEO6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 10:58:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A0356BA7;
        Mon,  5 Sep 2022 07:58:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C2A1F33D1E;
        Mon,  5 Sep 2022 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662389923;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lXa5B/MX7RbuqEmFhKlkiEnsTPdqdOfSXSSjFyzABAc=;
        b=NpF8ZLkBU/edkaVGgws2DP3/imwoE0JuVPYo7V90WDm3Q7cj6wSFHerW9Ga+R1lBy1CV8C
        Bxru7M4PNNA6p4WwIA1QtTRxTxy4us/l8YA5yDPA5AGmURFQNmnl4MfyYC4qTLNGlDAHVL
        TmRPFR3aSxNGvQlMbJARCIntQaOYbXY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662389923;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lXa5B/MX7RbuqEmFhKlkiEnsTPdqdOfSXSSjFyzABAc=;
        b=9Px5P8qv6Rzjh+KZSqPTTW4j+biNH1LymCQD0TNUbMcJtDoUjiLXCv/ZRsWzGbznFI8/ae
        4tFsvB6QHuS/2vCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A447513A66;
        Mon,  5 Sep 2022 14:58:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zi40J6MOFmOaSwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Mon, 05 Sep 2022 14:58:43 +0000
Date:   Mon, 5 Sep 2022 16:53:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] btrfs: enhance unsupported compat RO flags
 handling
Message-ID: <20220905145321.GF13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1660021230.git.wqu@suse.com>
 <1b3011f4b1bf4e60479568fcd3e090ea8b68d253.1660021230.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b3011f4b1bf4e60479568fcd3e090ea8b68d253.1660021230.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 01:02:16PM +0800, Qu Wenruo wrote:
> Currently there are two corner cases not handling compat RO flags
> correctly:
> 
> - Remount
>   We can still mount the fs RO with compat RO flags, then remount it RW.
>   We should not allow any write into a fs with unsupported RO flags.
> 
> - Still try to search block group items
>   In fact, behavior/on-disk format change to extent tree should not
>   need a full incompat flag.
> 
>   And since we can ensure fs with unsupported RO flags never got any
>   writes (with above case fixed), then we can even skip block group
>   items search at mount time.
> 
> This patch will enhance the unsupported RO compat flags by:
> 
> - Reject RW remount if there is unsupported RO compat flags
> 
> - Go dummy block group items directly for unsupported RO compat flags
>   In fact, only changes to chunk/subvolume/root/csum trees should go
>   incompat flags.
> 
> The latter part should allow future change to extent tree to be compat
> RO flags.
> 
> Thus this patch also needs to be backported to all stable trees.
> 
> Cc: stable@vger.kernel.org

This applies cleanly only to 5.19, anything else would need a separate
backport. I'm planning to send this patch among 6.0 fixes so this
should give us time to get it to older stable kernels before the block
group tree is released.
