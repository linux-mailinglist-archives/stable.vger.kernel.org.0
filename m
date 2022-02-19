Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4114BCB33
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 00:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiBSX7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Feb 2022 18:59:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236843AbiBSX7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Feb 2022 18:59:13 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C98BCA7
        for <stable@vger.kernel.org>; Sat, 19 Feb 2022 15:58:54 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id d17so5484487pfl.0
        for <stable@vger.kernel.org>; Sat, 19 Feb 2022 15:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pyKnh0rifNC4U8/SpWhjiS3uUcC5kmVNLLaPc0IhXvY=;
        b=eFv9LIHn5T7yu7SXdfr1xRt6PH8DYtfvvMqPlhlsZ6bZC6Gwo4CnvRkxkLGP4v1/za
         xH7WDZlsGzhKXMPVZxNtJvfV97TeYC/+z2zTWMOzSyPurTe9RIkmSZRk2tNYowdcG0FS
         fqY5kUxdDE9sZFT3ljh+x03Lnvopm2Tk7vorM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pyKnh0rifNC4U8/SpWhjiS3uUcC5kmVNLLaPc0IhXvY=;
        b=Ij5CoA2Wzway2srgmAcBuiG/2pXWEaqQjZeCX4vnCpW39GZlvLQXk7nGd4rxvjaGka
         SDgtHQJd0bJPGDODWizgdvgqjLsUBv0L5kZLIyrXBAAdxm1O5OcnwZLBRTD9rz+mURtS
         I3bSG+uTgIIWpVHYpEoMhHcBDw+oc+qdaD+zuY0qOf5WlCwGqWv1WQxu2duAM/hUckf3
         e3Kovf/WnJsyIqCdsx1fw/WruWS1ZdkdU6fpFdVV1TQ3VOeoiUyx7LKikVcMMr2R0iEN
         My9BkXWlZh2HS4iKCuUyHgl+yd+16n0T+hIudXzl1M6R/EpjTnsUlWejtKPJ7TX31Bfw
         rl8A==
X-Gm-Message-State: AOAM531LeHqVVOnL+LzXDPRPgVbImXae6keT2QSwnwbQalluVMEH2YLI
        TbCn0yyo+u3LS7rk2UpfvgrCEQ==
X-Google-Smtp-Source: ABdhPJz2B7x/obkYAxIzuuWmK0eIrem1Iyubh1rAOvTpZqyu2/XzDhnjlP1qJpC13eAFz3bW7Wje1A==
X-Received: by 2002:a05:6a00:cd3:b0:4df:7b9e:2557 with SMTP id b19-20020a056a000cd300b004df7b9e2557mr14045768pfv.25.1645315133327;
        Sat, 19 Feb 2022 15:58:53 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u11sm7756421pfi.71.2022.02.19.15.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 15:58:52 -0800 (PST)
Date:   Sat, 19 Feb 2022 15:58:51 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>, linux-mm@kvack.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] slab: remove __alloc_size attribute from
 __kmalloc_track_caller
Message-ID: <202202191558.11C173F04@keescook>
References: <20220218131358.3032912-1-gregkh@linuxfoundation.org>
 <CAKwvOd=4uwMVBwYU8XPP+cHkw5V1S_t7i8psMTRySsKEcDVZ_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=4uwMVBwYU8XPP+cHkw5V1S_t7i8psMTRySsKEcDVZ_A@mail.gmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 09:19:51AM -0800, Nick Desaulniers wrote:
> On Fri, Feb 18, 2022 at 5:14 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Commit c37495d6254c ("slab: add __alloc_size attributes for better
> > bounds checking") added __alloc_size attributes to a bunch of kmalloc
> > function prototypes.  Unfortunately the change to __kmalloc_track_caller
> > seems to cause clang to generate broken code and the first time this is
> > called when booting, the box will crash.
> >
> > While the compiler problems are being reworked and attempted to be
> > solved, let's just drop the attribute to solve the issue now.  Once it
> > is resolved it can be added back.
> 
> Sorry about the mess; we'll get it cleaned up!
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1599

Thanks for the issue link!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
