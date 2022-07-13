Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFFF573386
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 11:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiGMJxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 05:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbiGMJxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 05:53:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C205F9931;
        Wed, 13 Jul 2022 02:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E199CE1DF0;
        Wed, 13 Jul 2022 09:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF04C3411E;
        Wed, 13 Jul 2022 09:53:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TrEXnIMP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657705985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mArbs2A4NP1+bdAMtcm5yNBmM8qTNvow0Z/wnSY2eK8=;
        b=TrEXnIMPuj3qZf9ytsmBPXDcM7/sB/Q+XWrgYtiluN75/UeLvlpJ3IAVJivTznZ62kMAOb
        EKdRIG2Nq/djpsQYReIJNSyAphUerA6Eowd/+wLyVTEg7dOb4LwDpB68TOiJ0lTt9wZoEi
        WwgvYIT0abesdkOkLDQ4t5PA9dCdmkg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9893954c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 13 Jul 2022 09:53:04 +0000 (UTC)
Date:   Wed, 13 Jul 2022 11:53:03 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] um: seed rng using host OS rng
Message-ID: <Ys6V//WUKvDu3sjs@zx2c4.com>
References: <20220712232738.77737-1-Jason@zx2c4.com>
 <d2c55506bd0a93854320ce352a93303cf8080f48.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d2c55506bd0a93854320ce352a93303cf8080f48.camel@sipsolutions.net>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johannes,

Thanks for the review.

On Wed, Jul 13, 2022 at 09:05:03AM +0200, Johannes Berg wrote:
> On Wed, 2022-07-13 at 01:27 +0200, Jason A. Donenfeld wrote:
> > 
> > +++ b/arch/um/include/shared/os.h
> > @@ -11,6 +11,12 @@
> >  #include <irq_user.h>
> >  #include <longjmp.h>
> >  #include <mm_id.h>
> > +/* This is to get size_t */
> > +#ifndef __UM_HOST__
> > +#include <linux/types.h>
> > +#else
> > +#include <stddef.h>
> > +#endif
> >  
> >  #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
> >  
> > @@ -243,6 +249,7 @@ extern void stack_protections(unsigned long address);
> >  extern int raw(int fd);
> >  extern void setup_machinename(char *machine_out);
> >  extern void setup_hostinfo(char *buf, int len);
> > +extern ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);
> 
> For me, this doesn't compile, and per the man-page on my system, ssize_t
> requires <sys/types.h>, not <stddef.h>?

What you say about types.h strikes me as true from how libc programming
usually works everywhere else. But I actually copy and pasted that
snippet, including the comment, from user.h. So I guess user.h doesn't
break because of something else. Anyway, I'll change it to sys/types.h
and send a v2.

Jason
