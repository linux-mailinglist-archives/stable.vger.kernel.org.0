Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9383E6B653B
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 12:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCLLKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 07:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCLLKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 07:10:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BEE5070B;
        Sun, 12 Mar 2023 04:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35A16B80B8A;
        Sun, 12 Mar 2023 11:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BF3C433D2;
        Sun, 12 Mar 2023 11:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678619441;
        bh=taUXFp8kL6ktHNtSBeh4ZjQygRdXFiExttVdf1EL9WM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bcebVzU2yWibvgkLCn3oigLPiisHP/qFgPFjMRlAsX7oQDCs1HPwjpf7UYpvI0fCy
         aBiyVMcZZB8CAq+cviud6lwhxx4VvGJU+HgMXcMu+jGO2lHBOXwv7uZjuvm+bE2yK1
         cTQnGhfBvHTTnRUxJQCIeGVHMhrwiL0y7ovZJ+54=
Date:   Sun, 12 Mar 2023 12:10:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Demote BUG_ON() in crypto_unregister_alg() to a
 WARN_ON()
Message-ID: <ZA2zLtqrI4aeLSTj@kroah.com>
References: <20230311162513.6746-1-toke@redhat.com>
 <ZA1+zr0NapJlsKk9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZA1+zr0NapJlsKk9@gondor.apana.org.au>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 03:27:10PM +0800, Herbert Xu wrote:
> On Sat, Mar 11, 2023 at 05:25:12PM +0100, Toke Høiland-Jørgensen wrote:
> >
> > diff --git a/crypto/algapi.c b/crypto/algapi.c
> > index d08f864f08be..e9954fcb61be 100644
> > --- a/crypto/algapi.c
> > +++ b/crypto/algapi.c
> > @@ -493,7 +493,7 @@ void crypto_unregister_alg(struct crypto_alg *alg)
> >  	if (WARN(ret, "Algorithm %s is not registered", alg->cra_driver_name))
> >  		return;
> >  
> > -	BUG_ON(refcount_read(&alg->cra_refcnt) != 1);
> > +	WARN_ON(refcount_read(&alg->cra_refcnt) != 1);
> 
> I think we should return here instead of continuing to destroy
> the algorithm since we know that it's still in use.

Also, this still panics a box with panic-on-warn enabled, so if this can
be handled, returning an error is good.

thanks,

greg k-h
