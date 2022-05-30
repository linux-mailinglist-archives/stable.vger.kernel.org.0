Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F475374FE
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 09:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiE3GSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 02:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiE3GSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 02:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9883DA6A
        for <stable@vger.kernel.org>; Sun, 29 May 2022 23:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A439F6104A
        for <stable@vger.kernel.org>; Mon, 30 May 2022 06:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABECDC385B8;
        Mon, 30 May 2022 06:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653891522;
        bh=C9HmrT56rhp7jLMsKIUQmfxm/hRSRMXCe3BuzphXdNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qkafbk3NPYJGVQfeVxsjUSGrNyVNket3MpywjYKk/s2dgwtU1+jLDNWhorRTQrZxQ
         T8uawt7Jc0HtCbC1aV7fTiiGYBcNWsFylbYxgvo47CPW4v8PRovnuJGyVUfI/e66ZI
         oAKFnN0m/aUVxSAI3DLQJbSsFmk2Fwm5I7TP7lRI=
Date:   Mon, 30 May 2022 08:18:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schroeder, Julian" <jumaco@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache
 #5.11.0-rc5
Message-ID: <YpRhvtyAPfdcOdGB@kroah.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
 <Yo9t7Whg/XGa/jmb@kroah.com>
 <15AC3FF9-F74D-4C08-ADF4-8A1E14BE811F@amazon.com>
 <YpIsHLKZbeSENvaZ@kroah.com>
 <D8BE70AD-BD25-44A9-B1D7-D1CEC20461E9@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D8BE70AD-BD25-44A9-B1D7-D1CEC20461E9@amazon.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 29, 2022 at 12:57:59PM +0000, Schroeder, Julian wrote:
> >> >> From: Julian Schroeder <jumaco@amazon.com>
> >> >> Date: Fri, 20 May 2022 18:33:27 +0000
> >> >> Subject: [PATCH] nfsd: destroy percpu stats counters after reply cache
> >> >>  shutdown
> >> >> MIME-Version: 1.0
> >> >> Content-Type: text/plain; charset=UTF-8
> >> >> Content-Transfer-Encoding: 8bit
> >> >> Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
> >> >> tracked via a percpu counter. In the current code the percpu counter
> >> >> is destroyed before. If any pending cache is still present,
> >> >> percpu_counter_add is called with a percpu counter==NULL. This causes
> >> >> a kernel crash.
> >> >> The solution is to destroy the percpu counter after the cache is freed.
> >> >> Fixes: e567b98ce9a4b (âEURoenfsd: protect concurrent access to nfsd stats countersâEUR)
> >> >> Signed-off-by: Julian Schroeder <jumaco@amazon.com>
> >> >> ---
> >> >>  fs/nfsd/nfscache.c | 2 +-
> >> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >> diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
> >> >> index 0b3f12aa37ff..7da88bdc0d6c 100644
> >> >> --- a/fs/nfsd/nfscache.c
> >> >> +++ b/fs/nfsd/nfscache.c
> >> >> @@ -206,7 +206,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
> >> >>         struct svc_cacherep     *rp;
> >> >>         unsigned int i;
> >> >>
> >> >> -       nfsd_reply_cache_stats_destroy(nn);
> >> >>         unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
> >> >>
> >> >>         for (i = 0; i < nn->drc_hashsize; i++) {
> >> >> @@ -217,6 +216,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
> >> >>                                                                         rp, nn);
> >> >>                 }
> >> >>         }
> >> >> +       nfsd_reply_cache_stats_destroy(nn);
> >> >>
> >> >>         kvfree(nn->drc_hashtbl);
> >> >>         nn->drc_hashtbl = NULL;
> >> >> --
> >> >> 2.32.0
> >> >>
> >>
> >> >What is the git commit id of this in Linus's tree?
> >>
> >> >And this patch is totally damaged with whitespace and can not be applied
> >> >at all :(
> >>
> >> >Please fix it up and submit it again.
> >>
> >> >thanks,
> >>
> >> >greg k-h
> >>
> >> The patch made it into linux next. commit fd5e363eac77e.
> >> I sent the patch to stable again via git send-email (https://www.spinics.net/lists/stable/msg560818.html)
> >
> ><formletter>
> >
> >This is not the correct way to submit patches for inclusion in the
> >stable kernel tree.  Please read:
> >    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> >for how to do this properly.
> >
> ></formletter>
> Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
> tracked via a percpu counter. In the current code the percpu counter
> is destroyed before. If any pending cache is still present,
> percpu_counter_add is called with a percpu counter==NULL. This causes
> a kernel crash.
> The solution is to destroy the percpu counter after the cache is freed.
> 
> Fixes: e567b98ce9a4b (“nfsd: protect concurrent access to nfsd stats counters”)
> Signed-off-by: Julian Schroeder <jumaco@xxxxxxxxxx>

That is a very odd email address :(

Again, as the document says, just wait until a commit is in Linus's tree
and then send us the git commit id.

thanks,

greg k-h
