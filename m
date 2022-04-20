Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47553508F20
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381426AbiDTSOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 14:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381414AbiDTSOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 14:14:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C32046646
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 11:11:28 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s17so2514258plg.9
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 11:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GIRfho/UEmgLKksz3Hef8/60q1Jdf6mHBM1iOrwH5Jc=;
        b=H7/G2cA+tMU6dhaS4+bs+4ByL91KwkZGMQRvZqTZCWUqUKvbULyIT5oOWTFBeD+/qY
         CMOoaahlyITn1LWInAQNMlc0b1Zf1piHoFjlFn+sJHnvK9u0oS6Mq5poA3EkpZpa5pR8
         BJTymtJhTU9IAKHqcSLOujdSNa+6oggXyVj9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GIRfho/UEmgLKksz3Hef8/60q1Jdf6mHBM1iOrwH5Jc=;
        b=gqyVtAwMWsUpKztHit7DYUGa+JPc3JWHeH+6iavc44UxBV//N6CdJoMoFGj2DpeBsh
         kXK0aA/xRLpkM+DNoOHZCgaZiPm0o7tVXE9KTkcTBkeYFeDWJSjtKkjzKpH/lenlTUGA
         /n3//qBx5S6XkHRXciSfGuVz79Mh0/DAUu9SMy2+epS+GuiDYMJEKHNUc17iQgPxjIBM
         l+vDaTXsxj9niR2m9XkVJ8lPhcpDL0YW2jbxbfe3wKO6Eee/GBhOEGsljv2z0P8zBxu9
         JRA6RrUZGH1+DG34qJvXME2yVLfzMKH+xEGdyF+7S9bWXJBxhUV9PQsBH5kWlWbyIXOB
         0j6A==
X-Gm-Message-State: AOAM530J8rp6uP/6b7h0HaAodcj1XTVtSScsXMy2oySGaof80wwpuAYf
        BCpWp8U1j8/eX469Yp5NkLtvGHiJ6A2ong==
X-Google-Smtp-Source: ABdhPJyS9oAfiiFyBzLmBJinG3UpEtOBofItMsGhYt4Mpr6EgSebHQollxjiU6lvByWJAnP80PxSXg==
X-Received: by 2002:a17:903:41c4:b0:158:f3af:f5df with SMTP id u4-20020a17090341c400b00158f3aff5dfmr18794348ple.102.1650478288055;
        Wed, 20 Apr 2022 11:11:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q15-20020a056a00084f00b0050ab60bf37fsm5166814pfk.22.2022.04.20.11.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 11:11:27 -0700 (PDT)
Date:   Wed, 20 Apr 2022 11:11:26 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     Johan Hovold <johan@kernel.org>, kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] USB: serial: Fix heap overflow in WHITEHEAT_GET_DTR_RTS
Message-ID: <202204201056.5A1A6BAE04@keescook>
References: <20220419041742.4117026-1-keescook@chromium.org>
 <Yl+8K++wZUJCthMj@hovoldconsulting.com>
 <CAG48ez2Pikm5g2RfJxae=jz1C7KSCWc99sCa7fXFBKvDOPJubA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2Pikm5g2RfJxae=jz1C7KSCWc99sCa7fXFBKvDOPJubA@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 02:33:06PM +0200, Jann Horn wrote:
> On Wed, Apr 20, 2022 at 10:14 AM Johan Hovold <johan@kernel.org> wrote:
> > On Mon, Apr 18, 2022 at 09:17:42PM -0700, Kees Cook wrote:
> > > This looks like it's harmless, as both the source and the destinations are
> > > currently the same allocation size (4 bytes) and don't use their padding,
> > > but if anything were to ever be added after the "mcr" member in "struct
> > > whiteheat_private", it would be overwritten. The structs both have a
> > > single u8 "mcr" member, but are 4 bytes in padded size. The memcpy()
> > > destination was explicitly targeting the u8 member (size 1) with the
> > > length of the whole structure (size 4), triggering the memcpy buffer
> > > overflow warning:
> >
> > Ehh... No. The size of a structure with a single u8 is 1, not 4. There's
> > nothing wrong with the current code even if the use of memcpy for this
> > is a bit odd.

I thought that was surprising too, and suspected it was something
specific to the build (as Jann also suggested). I tracked it down[1] to
"-mabi=apcs-gnu", which is from CONFIG_AEABI=n.

whiteheat_private {
        __u8                       mcr;                  /*     0     1 */

        /* size: 4, cachelines: 1, members: 1 */
        /* padding: 3 */
        /* last cacheline: 4 bytes */
};


> >
> > > In file included from include/linux/string.h:253,
> > >                  from include/linux/bitmap.h:11,
> > >                  from include/linux/cpumask.h:12,
> > >                  from include/linux/smp.h:13,
> > >                  from include/linux/lockdep.h:14,
> > >                  from include/linux/spinlock.h:62,
> > >                  from include/linux/mmzone.h:8,
> > >                  from include/linux/gfp.h:6,
> > >                  from include/linux/slab.h:15,
> > >                  from drivers/usb/serial/whiteheat.c:17:
> > > In function 'fortify_memcpy_chk',
> > >     inlined from 'firm_send_command' at drivers/usb/serial/whiteheat.c:587:4:
> > > include/linux/fortify-string.h:328:25: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > So something is confused here.
> 
> So something's going wrong in fortify_memcpy_chk()? It looks like it
> is called with constant "size" equal to 1, and the condition

sizeof(info->mcr) is 1.
sizeof(struct whiteheat_dr_info) (with CONFIG_AEABI=n) is 4.

Given nothing actually uses "struct whiteheat_dr_info", except for the
sizing (har har), I suspect the better solution is just to do:

	info->mcr = command_info->result_buffer[0];

-Kees

[1] https://godbolt.org/z/3YvM1MYWW

-- 
Kees Cook
