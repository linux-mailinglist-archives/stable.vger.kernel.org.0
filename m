Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C986024B4
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 08:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJRGpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 02:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJRGpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 02:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB088E9AC;
        Mon, 17 Oct 2022 23:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A69A661384;
        Tue, 18 Oct 2022 06:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B06AC433D6;
        Tue, 18 Oct 2022 06:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666075528;
        bh=8nT890YD6IWXwwfzB3pR5xqwnm2ESd6MMFFhWaC+knQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J529blxgPzKIlSwaH+MhR4nYJox9YfSxmjg88UJtAM4sbPI+FXJmlglEF0s7pfphQ
         r9iFhp9nXn9Bg5F2po/JIlRaTPEUMFGY7aujGCRT+x54K9YtWIlEAKAvZsv5JJD++r
         Ah/xHVIrQEaoIsFP8ot6g4yNwjNuK2rsMeqgmZe0=
Date:   Tue, 18 Oct 2022 08:45:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest
 pahole release
Message-ID: <Y05LhQzMnJSpK0UT@kroah.com>
References: <20220904131901.13025-1-jolsa@kernel.org>
 <YxSxwZWkYMmtcsmA@kroah.com>
 <YxWfaoImsdcvkbce@krava>
 <Yxc3Er1sv17xrei1@kroah.com>
 <YyeYUEHyR/nHM8NT@krava>
 <Y02Yv/ubuCtVhtZk@dev-arch.thelio-3990X>
 <Y03Iq2GiS7XfhOxL@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y03Iq2GiS7XfhOxL@krava>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 11:27:07PM +0200, Jiri Olsa wrote:
> On Mon, Oct 17, 2022 at 11:02:39AM -0700, Nathan Chancellor wrote:
> > On Mon, Sep 19, 2022 at 12:14:40AM +0200, Jiri Olsa wrote:
> > > On Tue, Sep 06, 2022 at 02:03:30PM +0200, Greg KH wrote:
> > > > On Mon, Sep 05, 2022 at 09:04:10AM +0200, Jiri Olsa wrote:
> > > > > On Sun, Sep 04, 2022 at 04:10:09PM +0200, Greg KH wrote:
> > > > > > On Sun, Sep 04, 2022 at 03:18:59PM +0200, Jiri Olsa wrote:
> > > > > > > hi,
> > > > > > > new version of pahole (1.24) is causing compilation fail for 5.15
> > > > > > > stable kernel, discussed in here [1][2]. Sending fix for that plus
> > > > > > > one dependency patch.
> > > > > > > 
> > > > > > > Note for patch 1:
> > > > > > > there was one extra line change in scripts/pahole-flags.sh file in
> > > > > > > its linux tree merge commit:
> > > > > > > 
> > > > > > >   fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > > > > > > 
> > > > > > > not sure how/if to track that, I squashed the change in.
> > > > > > 
> > > > > > Squashing is fine, thanks.
> > > > > > 
> > > > > > And do we also need this for kernels older than 5.15?  Like 5.10 and 5.4?
> > > > > 
> > > > > yes, 5.10 needs similar patchset, but this for 5.15 won't apply there,
> > > > > so I'll send it separately
> > > > > 
> > > > > 5.4 passes compilation, but I don't think it will boot properly, still
> > > > > need to check on that
> > > > > 
> > > > > in any case, more patches are coming ;-)
> > > > 
> > > > Ok, these two are now queued up, feel free to send the rest when you
> > > > have them ready.
> > > 
> > > hi,
> > > as for 5.10 changes, I have them ready, pushed in here:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git pahole_fix_5_10
> > > 
> > > but it looks like CONFIG_DEBUG_INFO_BTF is not being used in 5.10,
> > > because I had to backport other similar option, that would break
> > > the build even earlier (--skip_encoding_btf_vars), or people use
> > > just old pahole ;-)
> > > 
> > > I suggest we wait with this change until somebody actually wants
> > > this fixed, AFAICS there's no report of broken 5.10 build yet
> > 
> > Consider this your first report :)
> 
> va bene ;-)
> 
> > 
> > My build containers include the latest pahole, as I have noticed more
> > issues with older pahole in newer kernels than newer pahole in older
> > kernels, as least until now. I have tripped over this issue on both 5.19
> > and 5.10, as the stable-only commit b775fbf532dc ("kbuild: Add
> > skip_encoding_btf_enum64 option to pahole") was only applied to 5.15,
> > even though it is needed in all kernels prior to 6.0.
> > 
> > Please consider explicitly sending the 5.10 series to stable and
> 
> sure I'll rebase and post it
> 
> > requesting b775fbf532dc to be applied to 5.19.
> 
> hm, it was already posted for 5.19:
> https://lore.kernel.org/bpf/20220916171234.841556-1-yakoyoku@gmail.com/
> 
> Greg,
> is there something missing for it to be taken?

Ick, sorry, this got lost.  Now queued up.

greg k-h
