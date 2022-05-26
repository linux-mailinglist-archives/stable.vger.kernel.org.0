Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48300534ED8
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 14:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiEZMJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 08:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344593AbiEZMJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 08:09:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E1CD02BB
        for <stable@vger.kernel.org>; Thu, 26 May 2022 05:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1A0C618F2
        for <stable@vger.kernel.org>; Thu, 26 May 2022 12:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBB6C34113;
        Thu, 26 May 2022 12:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653566961;
        bh=70AGGGB6bIlBtAYDvB5LdMmxheRdOaje9k9O+GaDe2c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xFba3Ke95O33ObpFBCzgNfR79mBoU1SKg2ojLhQAgX9USNYiMakFxNMOWVQ8jJ9Ji
         rneqq5gZgcvv+RaTzNvQZAeWtrGQh9Af0K8kga+4Nj+ussue/8T7v/aeo0pPoS89qI
         +CGYqVSMR4GPZYQksKqQ3+IOaxaG5TbRjFWL1XWE=
Date:   Thu, 26 May 2022 14:09:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Julian Schroeder <jumaco@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] nfsd: destroy percpu stats counters after reply cache
 #5.11.0-rc5
Message-ID: <Yo9t7Whg/XGa/jmb@kroah.com>
References: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220523211152.GB23843@dev-dsk-jumaco-1e-78723413.us-east-1.amazon.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 09:11:52PM +0000, Julian Schroeder wrote:
> From: Julian Schroeder <jumaco@amazon.com>
> Date: Fri, 20 May 2022 18:33:27 +0000
> Subject: [PATCH] nfsd: destroy percpu stats counters after reply cache
>  shutdown
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
> tracked via a percpu counter. In the current code the percpu counter
> is destroyed before. If any pending cache is still present,
> percpu_counter_add is called with a percpu counter==NULL. This causes
> a kernel crash.
> The solution is to destroy the percpu counter after the cache is freed.
> Fixes: e567b98ce9a4b (“nfsd: protect concurrent access to nfsd stats counters”)
> Signed-off-by: Julian Schroeder <jumaco@amazon.com>
> ---
>  fs/nfsd/nfscache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
> index 0b3f12aa37ff..7da88bdc0d6c 100644
> --- a/fs/nfsd/nfscache.c
> +++ b/fs/nfsd/nfscache.c
> @@ -206,7 +206,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
>         struct svc_cacherep     *rp;
>         unsigned int i;
>  
> -       nfsd_reply_cache_stats_destroy(nn);
>         unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
>  
>         for (i = 0; i < nn->drc_hashsize; i++) {
> @@ -217,6 +216,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
>                                                                         rp, nn);
>                 }
>         }
> +       nfsd_reply_cache_stats_destroy(nn);
>  
>         kvfree(nn->drc_hashtbl);
>         nn->drc_hashtbl = NULL;
> -- 
> 2.32.0
> 

What is the git commit id of this in Linus's tree?

And this patch is totally damaged with whitespace and can not be applied
at all :(

Please fix it up and submit it again.

thanks,

greg k-h
