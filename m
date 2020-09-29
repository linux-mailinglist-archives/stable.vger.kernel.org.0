Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08F127DB26
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 23:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgI2VyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 17:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgI2VyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 17:54:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422AFC0613D0
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:54:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so7083394wrm.9
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 14:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2jBOwo5sEDhXI6sp9RzWxuwmvMHiP6RaX4eX1gc5ek=;
        b=E7hfDS+sXf0kdHhKgC5UazbtiRypEKIfbxuk4uAJRGUY4Lb1SNerVz6Cr/62JW/JVV
         +3VKzcUZV/WP70E0ZpOD67V3WItA05mKKwDTr0iuIgqQoPRRShaPr0nq8pOzbt5kVw8M
         irMZi5zjHKotA+EbHKFqaqFOx8tLkd4auMvSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2jBOwo5sEDhXI6sp9RzWxuwmvMHiP6RaX4eX1gc5ek=;
        b=IoJZZYokcnbQjEbNuEXAz2ArfLGLo17HH7gbTu60bk8GR1Q/N45p6rc0A1/pl/wEaG
         H94Q+mbX1rtqMN1Rjj6WLuZ6y074Lj4RX24AROp3ofBPKkW9LNAkUM1ln0zBZTmvu7nX
         NNqSv7Aj/3jsra42BGMFPwlZDZZJaevYIae9gfFfCqmQd9b7CGk0XE1dqwtw025K8mYj
         eL1Oc+DD6GENbU8zd3hddTsvXWfTYlG5yRf3GRbujPdlQLvQXBjfegiXeTGEcEoEYy/7
         /hdtRgqsoCIjjDu7LMzmCbMnRynJfGG2wG+ZIYuVdd3szTnxuA+09jmA0Fk/gmUA63Sk
         8HBA==
X-Gm-Message-State: AOAM532q6BKloMCtSNWBtlZ7bsySkHFydz5mEEyCiIwtBmG62ZvZoimF
        SoIH1IGsViRDOJIoa481+24pM1iW5vHLHjOXQ78MoQ==
X-Google-Smtp-Source: ABdhPJznRd6WTGs71o/df2mvqSfUkKUNnhMQvsS+vuMvXGqCVRqBaUUSVoWSnfDqE0sfC1MfaJl2N1S/UK1Fjj/lvR8=
X-Received: by 2002:adf:93e5:: with SMTP id 92mr6354832wrp.31.1601416460800;
 Tue, 29 Sep 2020 14:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200929105929.719230296@linuxfoundation.org> <20200929105931.461063397@linuxfoundation.org>
In-Reply-To: <20200929105931.461063397@linuxfoundation.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 29 Sep 2020 16:54:10 -0500
Message-ID: <CAFxkdAoyenpdGV9XoFqtjEW02UVfa_i56NMKdmDFW89GSrZ5cg@mail.gmail.com>
Subject: Re: [PATCH 5.8 35/99] tools/libbpf: Avoid counting local symbols in
 ABI check
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 6:53 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Tony Ambardar <tony.ambardar@gmail.com>
>
> [ Upstream commit 746f534a4809e07f427f7d13d10f3a6a9641e5c3 ]
>
> Encountered the following failure building libbpf from kernel 5.8.5 sources
> with GCC 8.4.0 and binutils 2.34: (long paths shortened)
>
>   Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
>   match with num of versioned symbols in libbpf.so (236). Please make sure
>   all LIBBPF_API symbols are versioned in libbpf.map.
> #  --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
> #  +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
>   @@ -1,3 +1,5 @@
>   +_fini
>   +_init
>    bpf_btf_get_fd_by_id
>    bpf_btf_get_next_id
>    bpf_create_map
>   make[4]: *** [Makefile:210: check_abi] Error 1
>
> Investigation shows _fini and _init are actually local symbols counted
> amongst global ones:
>
>   $ readelf --dyn-syms --wide libbpf.so|head -10
>
>   Symbol table '.dynsym' contains 343 entries:
>      Num:    Value  Size Type    Bind   Vis      Ndx Name
>        0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
>        1: 00004098     0 SECTION LOCAL  DEFAULT   11
>        2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
>        3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
>        4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
>        5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
>        6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1
>
> A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
> same with the libbpf.so DSO for consistent comparison.
>
> Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Link: https://lore.kernel.org/bpf/20200905214831.1565465-1-Tony.Ambardar@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This seems to work everywhere else, but breaks PPC64LE.

Justin

> ---
>  tools/lib/bpf/Makefile |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --
>                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                            sort -u | wc -l)
>  VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
> +                             awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
>
>  CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
> @@ -219,6 +220,7 @@ check_abi: $(OUTPUT)libbpf.so
>                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
>                 readelf --dyn-syms --wide $(OUTPUT)libbpf.so |           \
> +                   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
>                     sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
>                 diff -u $(OUTPUT)libbpf_global_syms.tmp                  \
>
>
