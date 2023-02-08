Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69268FBC4
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 00:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjBHX7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 18:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBHX7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 18:59:07 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20DA14E8C;
        Wed,  8 Feb 2023 15:59:06 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n2so511217pgb.2;
        Wed, 08 Feb 2023 15:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zOaD6/QasLalJlAxk3UhHGE71ipDW/Gd+AEfgT9qP3w=;
        b=d2zSxyhc2mGLYfWsomKg99R8tb+7ADXPcZbvXDQvh+JYk2qF8tZB9GEaKglVNX2/6A
         KNoKaVZYjuy3WtJMHWOG/HEClI8NeVHNmWUjnSu1kRXfQ8o6hmjda4PhXkIzBGIcI/uW
         BjS4FwI0M5XnBGXBccshj/yfoF7YGfVT+1uNDGHdPgQEsfTC0U7CiWyzixaaPbiKcAeZ
         5dsvUh1C5pyBXyFlELoNXa/uG8ASdkHcJtzL0cRbllbf/bB+I1dl7z9flbguVkBRhbGd
         Hb7X9gi0H+dJBVw0reqgJPhtH41amssOgadycBSuuZgXsCfKlYux/L9a9NEmMXtkAjEK
         UPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOaD6/QasLalJlAxk3UhHGE71ipDW/Gd+AEfgT9qP3w=;
        b=DhBeePGZUN7rAzriW5OzPfBkeRACR6VZZlPU4MicLh1nY8MjLfRVGDejeL/kFev4MA
         aF13c9FqQ+/DoyKRcD3tQFEhs/XBtYTQFAG5N5iCT6ofM3jDx4V4l+WBV2BrhTpevkWu
         YKPUE0jBFQ/GH1/7YzgQB9RSK7pbRDRo1TcM/rBzz9c1aVigAglxoq3hrRWc9Yw8POWK
         IyWX2nT9XBnERvl4dD6kHDIQ4xfIpwWHcMaFXFSoNMtPwY8qG6sds+bbuP7BgPQzVqLo
         1ViQOrY4k3KJ8WhtblWS6Vl2ksbw+GiZzANf042/7vZdl0+CZEPdtkSNvTCRjWkpdu+8
         D9bw==
X-Gm-Message-State: AO0yUKWf6pRaT4FciznoIjFdaDRzwN5v0FeQH7p30TTasGC/neRa6Qt4
        XISzFxhciZeww2Rnak1cUYI=
X-Google-Smtp-Source: AK7set8NvT04IiBj+w/L08d91b+sJqc3Tz8O9aGwoqNLkV7mLgm2wZH7T9TVtunYDHwue58Kmy8FBQ==
X-Received: by 2002:aa7:991a:0:b0:5a8:4de2:e95e with SMTP id z26-20020aa7991a000000b005a84de2e95emr1519591pff.18.1675900745991;
        Wed, 08 Feb 2023 15:59:05 -0800 (PST)
Received: from localhost ([2400:8902::f03c:93ff:fe27:642a])
        by smtp.gmail.com with ESMTPSA id d8-20020aa78148000000b00593906a8843sm12151064pfn.176.2023.02.08.15.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 15:59:05 -0800 (PST)
Date:   Wed, 8 Feb 2023 23:58:54 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Stephen Boyd <swboyd@chromium.org>, concord@gentoo.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] Revert "slub: force on no_hash_pointers when slub_debug
 is enabled"
Message-ID: <Y+Q2xVKiN9UdZGwA@localhost>
References: <20230208194712.never.999-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208194712.never.999-kees@kernel.org>
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 08, 2023 at 11:47:17AM -0800, Kees Cook wrote:
> This reverts commit 792702911f581f7793962fbeb99d5c3a1b28f4c3.
> 
> Linking no_hash_pointers() to slub_debug has had a chilling effect
> on using slub_debug features for security hardening, since system
> builders are forced to choose between redzoning and heap address location
> exposures. Instead, just require that the "no_hash_pointers" boot param
> needs to be used to expose pointers during slub_debug reports.
> 
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: concord@gentoo.org
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/lkml/202109200726.2EFEDC5@keescook/
> Signed-off-by: Kees Cook <keescook@chromium.org>

in the commit message:

> Obscuring the pointers that slub shows when debugging makes for some
> confusing slub debug messages:
>
> Padding overwritten. 0x0000000079f0674a-0x000000000d4dce17
>
> Those addresses are hashed for kernel security reasons. If we're trying
> to be secure with slub_debug on the commandline we have some big
> problems given that we dump whole chunks of kernel memory to the kernel
> logs.

it dumps parts of kernel memory anyway and I'm not sure if slub_debug is
supposed to be used for security hardening.

what about introducing new boot parameter like, slub_hardening,
which does not print anything?
