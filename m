Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0224A2EE7DD
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 22:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbhAGVtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 16:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbhAGVtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 16:49:18 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FCBC0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 13:48:38 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l23so4881273pjg.1
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 13:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yHhv4+EFycAJKUbgSa0RmVqcL52Ac+/27NW7fknIfX4=;
        b=Y2XXqeUfIvCYmqg67Ss2+YD/MWpHgJN4MY7+G6OuW/4sue+bH4MWRaJ0E36qiS8ijc
         0/apWKEJxEca/cjsZm1eMoICPpvm/Eqc4AXKntBwdI2PSIwybKFH0eVgmo32/uOFBo2X
         HgAskdMD+eDV45lLAa1jifLARZRCxy31lvzsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yHhv4+EFycAJKUbgSa0RmVqcL52Ac+/27NW7fknIfX4=;
        b=HH5j/p7EQzGOetx1IpQbyrrSG9gb1MwvKzQt1sjqcPrXAUuU0hZz3BzcKR0TdPb1Na
         se26LqJjXIrr7VtWmQ3DAp6eTDQM0eZFFuo3ubBar9Ei83O5FCccYO1DGxz+RTboDiQA
         DsOngcAGD+R+Nh6cnf5je6slKOQOFD2ZvnYoHHbcSlpj5hwl01Df4ww3TCdxWAyNXSn5
         UE5dYeeQBDSjzccrbC8IIo5h183jupYq3+3nC0TB1Kfami2CwcOMX9nMpj0WIDYy/gwZ
         YvWdydEv8KWflPgzWzS/JUWhoGBVV3vtPwYDkc5lSGlj4o5cHtm0IPRqcWwEgBuO4IWF
         reZw==
X-Gm-Message-State: AOAM530tg5hAAhN6yt573ElxNmB8Mzwdk1C+npMNggFZkj9FNf0evDBE
        aS7L7ZV662Bd/zY+m939ihu+0A==
X-Google-Smtp-Source: ABdhPJzola3C8GYotrpR1OGMaMxBsLjWee/CuHpJkLo5FojtqN0IU9/zlGL8DjOrxeeu3BzHO28Zpg==
X-Received: by 2002:a17:90b:78d:: with SMTP id l13mr466183pjz.51.1610056118201;
        Thu, 07 Jan 2021 13:48:38 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id gk4sm2974766pjb.57.2021.01.07.13.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:48:37 -0800 (PST)
Date:   Thu, 7 Jan 2021 13:48:36 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH v4 mips-next 3/7] MIPS: properly stop .eh_frame generation
Message-ID: <202101071348.4BA775344@keescook>
References: <20210107123331.354075-1-alobakin@pm.me>
 <20210107123428.354231-1-alobakin@pm.me>
 <20210107123428.354231-3-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107123428.354231-3-alobakin@pm.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 12:35:01PM +0000, Alexander Lobakin wrote:
> Commit 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly") added
> -fno-asynchronous-unwind-tables to KBUILD_CFLAGS to prevent compiler
> from emitting .eh_frame symbols.
> However, as MIPS heavily uses CFI, that's not enough. Use the
> approach taken for x86 (as it also uses CFI) and explicitly put CFI
> symbols into the .debug_frame section (except for VDSO).
> This allows us to drop .eh_frame from DISCARDS as it's no longer
> being generated.
> 
> Fixes: 866b6a89c6d1 ("MIPS: Add DWARF unwinding to assembly")
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
