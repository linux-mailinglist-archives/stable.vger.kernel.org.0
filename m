Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D9F536D3E
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 16:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiE1OF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 10:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiE1OF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 10:05:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D58E2B0
        for <stable@vger.kernel.org>; Sat, 28 May 2022 07:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6EC81CE0A36
        for <stable@vger.kernel.org>; Sat, 28 May 2022 14:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B96EC34100;
        Sat, 28 May 2022 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653746719;
        bh=grLlpxF1ggVDJd7KwlwC0UQKliaEP3mwhaWE6d3MK6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDZjjwf71AhzmjJ0euB2liEEAwEBRFF2bRmXpdGDGlC/hAi9pgluj568OhtTywOd/
         uCS8O+PXKhjWf33mkbVb97YbE27ZB7KaTlxDKkJW8Z9T6md20xPQP3Y9tvoG1B8cIm
         BWkTe5/jR6h+U76/uu6TzGRDOK+ozvs+APw6wdEg=
Date:   Sat, 28 May 2022 16:05:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schroeder, Julian" <jumaco@amazon.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache
 #5.11.0-rc5
Message-ID: <YpIsHLKZbeSENvaZ@kroah.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
 <Yo9t7Whg/XGa/jmb@kroah.com>
 <15AC3FF9-F74D-4C08-ADF4-8A1E14BE811F@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15AC3FF9-F74D-4C08-ADF4-8A1E14BE811F@amazon.com>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 01:41:51PM +0000, Schroeder, Julian wrote:
> >> From: Julian Schroeder <jumaco@amazon.com>
> >> Date: Fri, 20 May 2022 18:33:27 +0000
> >> Subject: [PATCH] nfsd: destroy percpu stats counters after reply cache
> >>  shutdown
> >> MIME-Version: 1.0
> >> Content-Type: text/plain; charset=UTF-8
> >> Content-Transfer-Encoding: 8bit
> >> Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
> >> tracked via a percpu counter. In the current code the percpu counter
> >> is destroyed before. If any pending cache is still present,
> >> percpu_counter_add is called with a percpu counter==NULL. This causes
> >> a kernel crash.
> >> The solution is to destroy the percpu counter after the cache is freed.
> >> Fixes: e567b98ce9a4b (âEURoenfsd: protect concurrent access to nfsd stats countersâEUR)
> >> Signed-off-by: Julian Schroeder <jumaco@amazon.com>
> >> ---
> >>  fs/nfsd/nfscache.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
> >> index 0b3f12aa37ff..7da88bdc0d6c 100644
> >> --- a/fs/nfsd/nfscache.c
> >> +++ b/fs/nfsd/nfscache.c
> >> @@ -206,7 +206,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
> >>         struct svc_cacherep     *rp;
> >>         unsigned int i;
> >>
> >> -       nfsd_reply_cache_stats_destroy(nn);
> >>         unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
> >>
> >>         for (i = 0; i < nn->drc_hashsize; i++) {
> >> @@ -217,6 +216,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
> >>                                                                         rp, nn);
> >>                 }
> >>         }
> >> +       nfsd_reply_cache_stats_destroy(nn);
> >>
> >>         kvfree(nn->drc_hashtbl);
> >>         nn->drc_hashtbl = NULL;
> >> --
> >> 2.32.0
> >>
> 
> >What is the git commit id of this in Linus's tree?
> 
> >And this patch is totally damaged with whitespace and can not be applied
> >at all :(
> 
> >Please fix it up and submit it again.
> 
> >thanks,
> 
> >greg k-h
> 
> The patch made it into linux next. commit fd5e363eac77e.
> I sent the patch to stable again via git send-email (https://www.spinics.net/lists/stable/msg560818.html)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
