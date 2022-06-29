Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB0560594
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 18:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiF2QQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 12:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiF2QQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 12:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855E72C669;
        Wed, 29 Jun 2022 09:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C77261C12;
        Wed, 29 Jun 2022 16:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CADC341C8;
        Wed, 29 Jun 2022 16:16:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nDQ1kPwY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656519363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iGHEmjv5uJ0GyyFRESqOv14+I1wu3jYka/TaB1Kvo5A=;
        b=nDQ1kPwYHZX7hI65a8mAlJQauIbOsZn+yUUzdsI5dz0XGBODlgyZ5yuWKPXh0v57a38htM
        1rR0EAAjblPkg4vNJCPdu0juz3Do0QeZM1Mn4qoH69GIi7b7Hi7QcWs4Kfn5VGlBA34iY+
        0qQgy0zjrIfzL3bx5bKLklz0rFLGfpo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1084991d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 16:16:03 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id s17so16488224iob.7;
        Wed, 29 Jun 2022 09:16:03 -0700 (PDT)
X-Gm-Message-State: AJIora8pT0xrgl6ixwEbH8l5eCimAp0puWD48+fYnRji0mlghNENhPOx
        RdSZwpyfHJvwLYCX32w6lDaQMF09IUcJxk/EqtI=
X-Google-Smtp-Source: AGRyM1toD5V4era0y9VWcKXtnMeOQYb4pjFq8UXHGodxgISYDtAGmqm1EerqGlbIOmPriiwa9mQL1XQtgUB/gWZofho=
X-Received: by 2002:a05:6602:2d90:b0:63d:b41e:e4e4 with SMTP id
 k16-20020a0566022d9000b0063db41ee4e4mr2133489iow.172.1656519361064; Wed, 29
 Jun 2022 09:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <Yrw5f8GN2fh2orid@zx2c4.com> <20220629114240.946411-1-Jason@zx2c4.com>
 <Yrxvo4omb2qKNOVJ@kroah.com>
In-Reply-To: <Yrxvo4omb2qKNOVJ@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 29 Jun 2022 18:15:49 +0200
X-Gmail-Original-Message-ID: <CAHmME9pzOK8tnRUP=4m6=beEA-80Cibcd7Gg0Rpe=xx_HYv77g@mail.gmail.com>
Message-ID: <CAHmME9pzOK8tnRUP=4m6=beEA-80Cibcd7Gg0Rpe=xx_HYv77g@mail.gmail.com>
Subject: Re: [PATCH v8] ath9k: let sleep be interrupted when unregistering hwrng
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 5:28 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 29, 2022 at 01:42:40PM +0200, Jason A. Donenfeld wrote:
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4284,6 +4284,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
> >  {
> >       return try_to_wake_up(p, state, 0);
> >  }
> > +EXPORT_SYMBOL(wake_up_state);
>
> Should be EXPORT_SYMBOL_GPL(), right?

The highly similar wake_up_process() above it, which has the exact
same body, except the `state` argument is fixed as TASK_NORMAL, is an
EXPORT_SYMBOL(). So I figured this one should follow form. Let me know
if that's silly, and I'll send a v+1 changing it to _GPL though.

Jason
