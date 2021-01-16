Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C6F2F8EC1
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 19:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbhAPSxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 13:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbhAPSxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 13:53:30 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E021C061574;
        Sat, 16 Jan 2021 10:52:50 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id w79so15074823qkb.5;
        Sat, 16 Jan 2021 10:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ua/LuZsrNlCeFTfbXFziWkITBqn89svS3225QAvKj0A=;
        b=n12xMXlTU2DXR1uyiW4fXaINLmYT6of49oHn1WdmZ3Cl8itKncigwstKfybe20it5r
         +XBL9vo0t8S0SgTed0h6f/poowmdAb89scyZ9n/CI4cgJJuu1Qk43cg5mRMkl8S30V0S
         gNip6vOZJ748GPi7RCK8gZgl7jixCIJ9Ej1GzSoDQt9hwanLc4dNegiri7ZFG5hRPURu
         88aseBMY+iepKoZ+4hbaSedCImZU2hroSSH3pzVXBKGMVxzQxuk42C3HFPIfjPfP6Y33
         hSFIKE6pun1l6hiZ7emfdEo01uDho+975t46ArnU2jPyTz5NUl1xSJmp8LktXyWfb6v5
         +/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ua/LuZsrNlCeFTfbXFziWkITBqn89svS3225QAvKj0A=;
        b=Lj0D9gDNqYbXjAR9MWsRQ0VXrnDpx9R3heJ9IOyRKHqfRA3+flMMhGd2hLLaFjjNQi
         +bl6Z+R5BJk0F37MgpzaEvwTFHVK+bjzxm/dERYwdBjnQEwDy2lzAjXVuwDQyIrn03Yg
         p6gra9W/BF10OEij/YwH5SvsW57aQUMsWzzLpHtfbF9QyMIthJMCQrQ84Z+tr7j7nKv+
         vywHWnND/odKLJRY7JDNwBD+1e5QU7FmVBOO48RTEf2ouNU29kQkymOPTmgaBFcl9Y86
         ViF7EAI11ZUXoJlbPf8gyuExZm2hpleXesaCN/ALU4eeTUqMCgvzekLGo5YCpcOHWZuM
         yQ0w==
X-Gm-Message-State: AOAM531X7PvBa/Y8DeLlfys45ImI7WeQ5jwB6gfBJXRxiEETnLRw2fHN
        ZoaJ8LZXrtC+h2dwO2cKDjYsIP8mSlE=
X-Google-Smtp-Source: ABdhPJyWYkwjtMd7leSGPGTxr/2BxKXW6DNoXxh1e/n8q51VXlOSWufCd0l5E3S9cKNsl/xRvnTKDw==
X-Received: by 2002:a05:620a:b0f:: with SMTP id t15mr18389126qkg.485.1610823169107;
        Sat, 16 Jan 2021 10:52:49 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id w42sm4349496qtw.22.2021.01.16.10.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 10:52:48 -0800 (PST)
Date:   Sat, 16 Jan 2021 11:52:47 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc: Handle .text.{hot,unlikely}.* in linker
 script
Message-ID: <20210116185247.GA2491296@ubuntu-m3-large-x86>
References: <20210104204850.990966-1-natechancellor@gmail.com>
 <20210104205952.1399409-1-natechancellor@gmail.com>
 <20210116184438.GE30983@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116184438.GE30983@gate.crashing.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 16, 2021 at 12:44:38PM -0600, Segher Boessenkool wrote:
> Hi!
> 
> Very late of course, and the patch is fine, but:
> 
> On Mon, Jan 04, 2021 at 01:59:53PM -0700, Nathan Chancellor wrote:
> > Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
> > sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
> > change [1].
> > 
> > After another LLVM change [2], these sections are seen in some PowerPC
> > builds, where there is a orphan section warning then build failure:
> > 
> > $ make -skj"$(nproc)" \
> >        ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 O=out \
> >        distclean powernv_defconfig zImage.epapr
> > ld.lld: warning: kernel/built-in.a(panic.o):(.text.unlikely.) is being placed in '.text.unlikely.'
> 
> Is the section really called ".text.unlikely.", i.e. the name ending in
> a dot?  How very unusual, is there some bug elsewhere?

No, this was an intention change done by LLVM:
https://reviews.llvm.org/D79600

Cheers,
Nathan
