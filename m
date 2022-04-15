Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5322550201C
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348414AbiDOB2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348404AbiDOB2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:28:42 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5615E6D979
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:26:13 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id b189so5772348qkf.11
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 18:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Sm+gny5XTTpy+ELPSV+rPSft8W2i3xec/MLcuEY0I/Y=;
        b=dLn7lrKL8/l7RC0S6YMvBo5CS3kBVa2lk3icsydvZ+kJysipb9rdkORVWJPLC1aY7G
         /NT6aH7hXVIdGfSfk70stO6ReDmaR5qGuiaiUDVHVAfXUDp2IN8E506Nwtkzxe65rg/1
         j0Tm5GVTSN5WiMsbqaGsXHDgM32yD1DKUYdQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Sm+gny5XTTpy+ELPSV+rPSft8W2i3xec/MLcuEY0I/Y=;
        b=Px5mTYvwoy8Lcu1UWmjZ+1RjSMp0oldLosFBiJbJXhGJd1gAp8fsa3HYiHFUgWyE45
         5tIPzXpiocSU2Qlvvsx2X3/VM+N6S7thys+UQlzhUDyZLdq4Rqr8nds6U2Lzqnk8KNUm
         kLXJ3AS0sUykyhjabfxpm7eFjWxEgmU0V6+St5exb8hZKcraFuqXSAwiWlXCOpv90s9o
         WEZfPABSMHQq15wETKcLH5ulQcFukxSgJYXuoffKzVpK/tj3Fvn3RM/TleFxB9QZH4PY
         MTM11yWy5CxsxQmFT1pBGuwh3y8BouN8tOsdswlznbAy3he9IVz8BGOqMeEe5SBkOiMB
         tqXg==
X-Gm-Message-State: AOAM532fPusHxFxfkVZRmn++vLVwzofyyVtAO/Fn4QQFFzrCFHxRN7hs
        ItPX3U+BJlLRdhn+RRWSZIEpaw282LuXiQ==
X-Google-Smtp-Source: ABdhPJzCY5w8ByFXA4+AhOmT5fd2zsrh/f3FCBgbtzYes037mIpSHpI2oeA68UX2ihwu/ODEPSuHIQ==
X-Received: by 2002:a37:2e42:0:b0:67e:6d80:2707 with SMTP id u63-20020a372e42000000b0067e6d802707mr4008990qkh.365.1649985972470;
        Thu, 14 Apr 2022 18:26:12 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-127.dsl.bell.ca. [216.209.220.127])
        by smtp.gmail.com with ESMTPSA id n186-20020a37bdc3000000b0069c218173e8sm1801615qkf.112.2022.04.14.18.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 18:26:12 -0700 (PDT)
Date:   Thu, 14 Apr 2022 21:26:10 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
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
Message-ID: <20220415012610.f2uph3vpwehyc27u@meerkat.local>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <202204141624.6689D6B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202204141624.6689D6B@keescook>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 04:27:38PM -0700, Kees Cook wrote:
> On Thu, Apr 14, 2022 at 11:10:18AM +0200, Niklas Cassel wrote:
> > bFLT binaries are usually created using elf2flt.
> > [...]
> 
> Hm, something in the chain broke DKIM, but I can't see what:
> 
>   ✗ [PATCH v2] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
>     ✗ BADSIG: DKIM/wdc.com
> 
> Konstantin, do you have a process for debugging these? I don't see the
> "normal" stuff that breaks DKIM (i.e. a trailing mailing list footer, etc)

It's our usual friend "c=simple/simple" -- vger just doesn't work with that.
See here for reasons:

https://lore.kernel.org/lkml/20211214150032.nioelgvmase7yyus@meerkat.local/

You should try to convince wdc.com mail admins to set it to c=relaxed/simple,
or you can cc all your patches to patches@lists.linux.dev (which does work
with c=simple/simple), and then b4 will give those priority treatment.

-K
