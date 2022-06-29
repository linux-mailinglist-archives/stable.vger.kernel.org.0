Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C305F5606AD
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 18:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiF2QuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 12:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiF2Qt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 12:49:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D2819B;
        Wed, 29 Jun 2022 09:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F71F61D69;
        Wed, 29 Jun 2022 16:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0D2C34114;
        Wed, 29 Jun 2022 16:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656521397;
        bh=vCB/w5Leyy+k2QVY651Bo02Dw7tEAmiNBIxFE6QkOJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lX8FUqI6z1ZWknPp/dG7XUkUpBgEzjahm/JdC4pp4ANnlPXj/3HwpNlTglikOVHKS
         Cv3cLRFXxxKEpXbbkfez8QnSguevQezWIM/D2lqsL0u594ZjiGWx1/FjOwZVh1olfz
         PQF4d/gFONb7fq5tynHq59n/LA7v4XyF/BJxqSAk=
Date:   Wed, 29 Jun 2022 18:49:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v8] ath9k: let sleep be interrupted when unregistering
 hwrng
Message-ID: <YryCsq1YLbL4sy7C@kroah.com>
References: <Yrw5f8GN2fh2orid@zx2c4.com>
 <20220629114240.946411-1-Jason@zx2c4.com>
 <Yrxvo4omb2qKNOVJ@kroah.com>
 <CAHmME9pzOK8tnRUP=4m6=beEA-80Cibcd7Gg0Rpe=xx_HYv77g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pzOK8tnRUP=4m6=beEA-80Cibcd7Gg0Rpe=xx_HYv77g@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 06:15:49PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 29, 2022 at 5:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Jun 29, 2022 at 01:42:40PM +0200, Jason A. Donenfeld wrote:
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -4284,6 +4284,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
> > >  {
> > >       return try_to_wake_up(p, state, 0);
> > >  }
> > > +EXPORT_SYMBOL(wake_up_state);
> >
> > Should be EXPORT_SYMBOL_GPL(), right?
> 
> The highly similar wake_up_process() above it, which has the exact
> same body, except the `state` argument is fixed as TASK_NORMAL, is an
> EXPORT_SYMBOL(). So I figured this one should follow form. Let me know
> if that's silly, and I'll send a v+1 changing it to _GPL though.

I'll let the maintainers of this code decide that, I wasn't aware of the
other symbol above this.  It's their call, as it's their code.

thanks,

greg k-h
