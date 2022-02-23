Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDA54C19E1
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiBWRZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbiBWRZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:25:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF39527EA;
        Wed, 23 Feb 2022 09:24:48 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D315E2171F;
        Wed, 23 Feb 2022 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645637086;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nyh+dlLEFtk5a7r5fyJIdubXRNDNCA4Th/hKQraTE04=;
        b=U+PX8irA9nCRkeNyaYP4YauJzL5b+RpoJQz8+zIM5SQjPp6Hcqq0W8dMARHMX9s6ZdWljO
        ++b1pRI2TDFV14Qat3WYBscnrQvVOu7ZseP6mAe/h4jASJvjAong1fc7NCd9+4DuFYX5QU
        K6ilYzU/GSmuvQvs1ezsAH6XsMXGx5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645637086;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nyh+dlLEFtk5a7r5fyJIdubXRNDNCA4Th/hKQraTE04=;
        b=fPZpu2fzLWkeRmqbCa1udMNPegRO86v88zz9pqguCeJ/DrwqKlzvP0qPGvRBHTh9k1GEJ5
        eQzERY5e3TVSGfDw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id A47F0A3B83;
        Wed, 23 Feb 2022 17:24:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4BE16DA7F7; Wed, 23 Feb 2022 18:20:58 +0100 (CET)
Date:   Wed, 23 Feb 2022 18:20:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Su Yue <l@damenly.su>
Cc:     Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 16/27] btrfs: tree-checker: check item_size
 for dev_item
Message-ID: <20220223172058.GR12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yue <l@damenly.su>,
        Greg KH <greg@kroah.com>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>, clm@fb.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org
References: <20220209184103.47635-1-sashal@kernel.org>
 <20220209184103.47635-16-sashal@kernel.org>
 <Yg92voqmS9jz/rI+@kroah.com>
 <1r00qtxj.fsf@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1r00qtxj.fsf@damenly.su>
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

On Fri, Feb 18, 2022 at 07:25:20PM +0800, Su Yue wrote:
> On Fri 18 Feb 2022 at 11:36, Greg KH <greg@kroah.com> wrote:
> > On Wed, Feb 09, 2022 at 01:40:52PM -0500, Sasha Levin wrote:
>  \
>       |                                    ~~~~~~~~~~~~^
> fs/btrfs/ctree.h:1833:1: note: in expansion of macro 
> \342\200\230BTRFS_SETGET_FUNCS\342\200\231
>  1833 | BTRFS_SETGET_FUNCS(item_size, struct btrfs_item, size, 
>  32);
>       | ^~~~~~~~~~~~~~~~~~
> ========================================================================
> 
> The upstream patchset[1] merged in 5.17-rc1, changed second 
> parameter
> of btrfs_item_size() from btrfs_item * to int directly.
> So yes, the backport is wrong.
> 
> I'm not familiar with stable backport progress. Should I file a 
> patch
> using btrfs_item *? Or just drop it?
> 
> The patch is related to  0c982944af27d131d3b74242f3528169f66950ad 
> but
> I wonder why the 0c98294 is not selected automatically.

We don't rely on the automatic selection, I evaluate all patches for
stable inclusion and add the CC: tag, this works well. Not all patches
need to go to stable, but AUTOSEL sometimes picks patches that could be
there and if it's not entirely wrong I don't object.
