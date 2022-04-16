Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F93050338D
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 07:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiDPARD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 20:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiDPAQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 20:16:46 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A0F6541D
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:14:06 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so9445786pjb.1
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YDAMdut8vUmhZEo+u+sVvhEH17aBkfLLoPALv7vOiPs=;
        b=BgeBgGT1ait8U0/BHza0JXV85o7bBnhJL0TpF5JPsWvJIk05pGpM+tuDB4PT5hDL6U
         gGCnn6n4F/KUAc06HGiLMZIyQZoAHOduREeyYRRUbhH7l39CDRwwwfNU7wjaCXS7p8j4
         z/n4rBrtg3sNGZ2pSZkfIaSCmg7HpVr/GXgiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YDAMdut8vUmhZEo+u+sVvhEH17aBkfLLoPALv7vOiPs=;
        b=VTgvZF6W28EIRRukziDx7eYGvH0RDODCLakz71G9XWMvWnpLbby2Bqb7ut9Ncjm9ci
         ThePtXuSbMU7XHBHgTzwX0YFRBizk4pxAJiXockH35uQ3+cVIsf3movPSeaAfrt6T5V3
         Mee2ZeAxFfDUfDJwSI5p/wv/TDOQh6A2DnSe5V2XHP1P6bp7OoaQrmwca86lRloqEtaC
         jsmQpQw4uqUOox7J2xJA+f3FalIXRMFayAdT/S7iCOWijMCV5TeEW7GXgTjfiQRXusom
         mlOA5LD42iq0TVY5w3kRuD3OEF40oJxDCT5b9mTjUoOrDrdLxtdTv8JQQUKElOVZIFRZ
         WkQQ==
X-Gm-Message-State: AOAM531f7JgQmBHO7eVU1pPT+CrCp2KLU0K7I6qWQ//El/GohhT+0SMG
        JDSMj+UeDYsNbcetCP1N12OJLQ==
X-Google-Smtp-Source: ABdhPJz7gG8OaArrj60bX3xNsZIOTnb5QGee+Uj57upaqwTu6tD+kh6NB8aVzTsd5Pn3smREnpnwHw==
X-Received: by 2002:a17:902:6acb:b0:158:8923:86df with SMTP id i11-20020a1709026acb00b00158892386dfmr1444104plt.144.1650068045861;
        Fri, 15 Apr 2022 17:14:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t38-20020a634626000000b0039cc30b7c93sm5242501pga.82.2022.04.15.17.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:14:05 -0700 (PDT)
Date:   Fri, 15 Apr 2022 17:14:04 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Message-ID: <202204151713.4EB07DECC@keescook>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <202204141624.6689D6B@keescook>
 <20220415012610.f2uph3vpwehyc27u@meerkat.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415012610.f2uph3vpwehyc27u@meerkat.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 09:26:10PM -0400, Konstantin Ryabitsev wrote:
> On Thu, Apr 14, 2022 at 04:27:38PM -0700, Kees Cook wrote:
> > On Thu, Apr 14, 2022 at 11:10:18AM +0200, Niklas Cassel wrote:
> > > bFLT binaries are usually created using elf2flt.
> > > [...]
> > 
> > Hm, something in the chain broke DKIM, but I can't see what:
> > 
> >   ✗ [PATCH v2] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
> >     ✗ BADSIG: DKIM/wdc.com
> > 
> > Konstantin, do you have a process for debugging these? I don't see the
> > "normal" stuff that breaks DKIM (i.e. a trailing mailing list footer, etc)
> 
> It's our usual friend "c=simple/simple" -- vger just doesn't work with that.
> See here for reasons:
> 
> https://lore.kernel.org/lkml/20211214150032.nioelgvmase7yyus@meerkat.local/
> 
> You should try to convince wdc.com mail admins to set it to c=relaxed/simple,
> or you can cc all your patches to patches@lists.linux.dev (which does work
> with c=simple/simple), and then b4 will give those priority treatment.

Ah-ha! Thank you! :)

-- 
Kees Cook
