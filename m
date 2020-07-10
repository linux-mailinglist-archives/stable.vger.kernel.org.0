Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8D321BA13
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 17:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGJP5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 11:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJP5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 11:57:34 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F76C08C5CE
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 08:57:34 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u5so2715483pfn.7
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 08:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tv9ph4ZQRvgVkU76z3ZJJI3Yg5Qv8TBfW1t8EmYer7E=;
        b=XpqOn1uA1k15FaoLlIHw841TnET+bDEqSesAd+mpsLNTDUps2w/oxZtL/BzlAkBbru
         LX1SEaqXoLRsGraKm1Mhg3JJ90kbTGl4P/LPqBqRO/cce/y7vIuD7dDsBIzMf+x7Ne9P
         05jHDMRnCifqpoucT75DO1bwlgF8jBPm+c0d4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tv9ph4ZQRvgVkU76z3ZJJI3Yg5Qv8TBfW1t8EmYer7E=;
        b=PX6mrDZoqL58pec5HU2b6QLypCfijCHHRwxkuRckh8z45mgCmmAEZgHoEC4R7oIX3J
         VqFyTMVUTA41OIzp7ocOdfs5FmgT1arVOXLMXlBBhaJ4O+LVvz4wohTKZrDRk54E9e1A
         TlgaSyCRGRIXhzAU8IdFLqcgo4epyj7anbf5oN4HkweYWvWnQqBnvhZJwgiaWse3lqhz
         hnUqLpPqA5l/W7EWfZZy3KpOElaA7gHFVL9xrIoxa32CKOO4sSELvdPmsB1zi/NhLmLv
         3IfSKLUEY3kI1UyBb5Z1iacI/a0dcyPrxZiUuzxGBnNvbmCTOPfrhihY+FmtoXIAGRtA
         Ra9g==
X-Gm-Message-State: AOAM5331UJ94Swl164V3aqiVnyYYUjMjNovXYx1iVF3PUrZm0Q+g1B3e
        5NycRmC7jjpLNS4HajIDS+E33Q==
X-Google-Smtp-Source: ABdhPJxsTz0C6vRVovLt3uCVacw9B2IM77gZHtQM6O7lhZhJBBPmCoGeIJjst0VyMjrC0HbYX+Gcsw==
X-Received: by 2002:a62:7653:: with SMTP id r80mr41220090pfc.236.1594396654180;
        Fri, 10 Jul 2020 08:57:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 199sm6122461pgc.79.2020.07.10.08.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 08:57:33 -0700 (PDT)
Date:   Fri, 10 Jul 2020 08:57:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] kallsyms: Refactor kallsyms_show_value() to take cred
Message-ID: <202007100857.EEB63BE@keescook>
References: <20200702232638.2946421-2-keescook@chromium.org>
 <20200710140307.911FB2082E@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710140307.911FB2082E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 02:03:06PM +0000, Sasha Levin wrote:
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

Was this test for only 1/5, or the whole series?

Thanks!

-Kees

> 
> v5.7.7: Build OK!
> v5.4.50: Build OK!
> v4.19.131: Build OK!
> v4.14.187: Failed to apply! Possible dependencies:
>     22c8852624fc9 ("bpf: improve selftests and add tests for meta pointer")
>     2b7c6ba945fd3 ("bpf/verifier: improve disassembly of BPF_END instructions")
>     390ee7e29fc8e ("bpf: enforce return code for cgroup-bpf programs")
>     61bd5218eef34 ("bpf: move global verifier log into verifier environment")
>     7105e828c087d ("bpf: allow for correlation of maps and helpers in dump")
>     73c864b38383f ("bpf/verifier: improve disassembly of BPF_NEG instructions")
>     cc8b0b92a1699 ("bpf: introduce function calls (function boundaries)")
>     de8f3a83b0a0f ("bpf: add meta pointer for direct access")
>     e7bf8249e8f1b ("bpf: encapsulate verifier log state into a structure")
>     f4ac7e0b5cc8d ("bpf: move instruction printing into a separate file")
> 
> v4.9.229: Failed to apply! Possible dependencies:
>     0e33661de493d ("bpf: add new prog type for cgroup socket filtering")
>     29ba732acbeec ("bpf: Add BPF_MAP_TYPE_LRU_HASH")
>     2d0bde57f3527 ("include/linux/filter.h: use set_memory.h header")
>     3007098494bec ("cgroup: add support for eBPF programs")
>     3a08c2fd76345 ("bpf: LRU List")
>     3a0af8fd61f90 ("bpf: BPF for lightweight tunnel infrastructure")
>     40077e0cf6220 ("bpf: remove struct bpf_map_type_list")
>     546ac1ffb70d2 ("bpf: add devmap, a map for storing net device references")
>     56f668dfe00dc ("bpf: Add array of maps support")
>     6102365876003 ("bpf: Add new cgroup attach type to enable sock modifications")
>     7105e828c087d ("bpf: allow for correlation of maps and helpers in dump")
>     7bd509e311f40 ("bpf: add prog_digest and expose it via fdinfo/netlink")
>     820a0b24b261c ("include/linux/filter.h: use linux/set_memory.h")
>     8f8449384ec36 ("bpf: Add BPF_MAP_TYPE_LRU_PERCPU_HASH")
>     b2cd12574aa3e ("bpf: Refactor cgroups code in prep for new type")
>     b95a5c4db09bc ("bpf: add a longest prefix match trie map implementation")
>     be9370a7d8614 ("bpf: remove struct bpf_prog_type_list")
>     c78f8bdfa11fc ("bpf: mark all registered map/prog types as __ro_after_init")
>     f4324551489e8 ("bpf: add BPF_PROG_ATTACH and BPF_PROG_DETACH commands")
>     f4ac7e0b5cc8d ("bpf: move instruction printing into a separate file")
> 
> v4.4.229: Failed to apply! Possible dependencies:
>     0d01d45f1b251 ("net: cls_bpf: limit hardware offload by software-only flag")
>     16e5cc647173a ("net: rework setup_tc ndo op to consume general tc operand")
>     332ae8e2f6ecd ("net: cls_bpf: add hardware offload")
>     4f3446bb809f2 ("bpf: add generic constant blinding for use in jits")
>     5b33f48842fa1 ("net/flower: Introduce hardware offload support")
>     6843e7a2abe7c ("net: sched: consolidate offload decision in cls_u32")
>     7105e828c087d ("bpf: allow for correlation of maps and helpers in dump")
>     7bd509e311f40 ("bpf: add prog_digest and expose it via fdinfo/netlink")
>     820a0b24b261c ("include/linux/filter.h: use linux/set_memory.h")
>     9fd82b610ba33 ("bpf: register BPF_PROG_TYPE_TRACEPOINT program type")
>     a1b7c5fd7fe98 ("net: sched: add cls_u32 offload hooks for netdevs")
>     b87f7936a9324 ("net/sched: Add match-all classifier hw offloading.")
>     bd570ff970a54 ("bpf: add event output helper for notifications/sampling/logging")
>     c94987e40ebba ("bpf: move bpf_jit_enable declaration")
>     e4c6734eaab90 ("net: rework ndo tc op to consume additional qdisc handle parameter")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks
> Sasha

-- 
Kees Cook
