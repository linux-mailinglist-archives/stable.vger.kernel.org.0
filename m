Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5C86AA0A7
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 21:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjCCUgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 15:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjCCUgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 15:36:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36C62D85
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 12:36:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l1so3810986pjt.2
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 12:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1677875771;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=geAmPjDQxdljXtlXmphTlxxF1JLXM9iUHwEO1xPqi18=;
        b=U41Mag/c9CHHfte/BaVhSK7Yl0vhq3mrqmh3RRfl6XuCTyx3VeZgJdw8M44ftCDf+I
         lkLMuIIbBkM4j69mSN7DPIYqqUMH8j1knPYp11zDWxDVL7aX1P5anqGeh/wA1HxD1YAb
         +YtZ/ArzfKpN7b35FHO5Ds0H/vpc3ZSb4kOFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677875771;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=geAmPjDQxdljXtlXmphTlxxF1JLXM9iUHwEO1xPqi18=;
        b=5gwVf0ZHpLUGA83iBDXKBKZKJvXKtFp1Ec+tpVBfv394Uxsk6/itAFPUOaifrGsSR1
         KR4G35feOvZQXdPOsdFq0mZf0jXhJN0Q3CXTptQI7NDGTf7JI5HZUCSD1omjawaPZpk4
         kmPDbgIu5aiEZO//aka8+sk/tDFG2ekG6Sc/ILR3knjfb+yMwzMBzPjvGgyQPNnGoVg2
         2v2o/8zjn8N2WWm1F6xbj2FT0mTjDH2HCaJiaISMPFFXM5l9k6vsaY8c0hn0HU77z8iY
         Kl/ds6BWfEmiapfniH0AmP5zN5ymW4mFFZgTDEqAdM5wz5HyAUskHZ7JQV3GqOxXxDjW
         pEHw==
X-Gm-Message-State: AO0yUKUgiKQuxQzmGpY84wwCR3mNs3XaY+bn+xsC2SQi9OKQvUSxWr8y
        9q0iYUz1tD75cExkw11SK2Av3A==
X-Google-Smtp-Source: AK7set9ywfSft3cMRiD0v6Edcwehkcu8/K7S+id3Tl9yCFXURbPhno3Wwnvqlg/u7NhF2oxqRYuxxA==
X-Received: by 2002:a17:902:ed11:b0:19d:af21:dc2f with SMTP id b17-20020a170902ed1100b0019daf21dc2fmr2568711pld.33.1677875770781;
        Fri, 03 Mar 2023 12:36:10 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b0019e81c8fd01sm1896816plg.249.2023.03.03.12.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 12:36:10 -0800 (PST)
Message-ID: <64025a3a.170a0220.dba96.3fcf@mx.google.com>
X-Google-Original-Message-ID: <202303031231.@keescook>
Date:   Fri, 3 Mar 2023 12:36:09 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] kheaders: Use array declaration instead of char
References: <20230302224946.never.243-kees@kernel.org>
 <89e3ecb6-0e1a-3d86-cb05-cbb034c68dc4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89e3ecb6-0e1a-3d86-cb05-cbb034c68dc4@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 04:19:51PM +0100, Alexander Lobakin wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Thu,  2 Mar 2023 14:49:50 -0800
> 
> > Under CONFIG_FORTIFY_SOURCE, memcpy() will check the size of destination
> > and source buffers. Defining kernel_headers_data as "char" would trip
> > this check. Since these addresses are treated as byte arrays, define
> > them as arrays (as done everywhere else).
> 
> Yet another array-as-one-char, I wonder how many are still here...

Yeah, good point. They do tend to stand out; we could find them:

$ git grep 'extern char [^\*\[\( ]*;'
arch/alpha/boot/bootp.c:extern char _end;
arch/alpha/boot/bootpz.c:extern char _end;
arch/alpha/boot/main.c: extern char _end;
arch/arm/mach-rockchip/core.h:extern char rockchip_secondary_trampoline;
arch/arm/mach-rockchip/core.h:extern char rockchip_secondary_trampoline_end;
arch/arm/mach-zynq/common.h:extern char zynq_secondary_trampoline;
arch/arm/mach-zynq/common.h:extern char zynq_secondary_trampoline_jump;
arch/arm/mach-zynq/common.h:extern char zynq_secondary_trampoline_end;
arch/hexagon/include/uapi/asm/setup.h:extern char external_cmdline_buffer;
arch/ia64/include/asm/smp.h:extern char no_int_routing;
arch/ia64/kernel/process.c:     extern char ia64_ret_from_clone;
arch/mips/dec/prom/memory.c:    extern char genexcept_early;
arch/mips/kernel/traps.c:       extern char except_vec3_generic;
arch/mips/kernel/traps.c:       extern char except_vec4;
arch/mips/kernel/traps.c:       extern char except_vec3_r4000;
arch/mips/mm/c-octeon.c:        extern char except_vec2_octeon;
arch/parisc/boot/compressed/misc.c:extern char output_len;
arch/parisc/boot/compressed/misc.c:extern char _startcode_end;
arch/powerpc/include/asm/smp.h:extern char __secondary_hold;
arch/s390/include/asm/kvm_host.h:extern char sie_exit;
arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_enter_start;
arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_enter_end;
arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_leave_start;
arch/sh/boards/mach-ap325rxa/setup.c:extern char ap325rxa_sdram_leave_end;
arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_enter_start;
arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_enter_end;
arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_leave_start;
arch/sh/boards/mach-ecovec24/setup.c:extern char ecovec24_sdram_leave_end;
arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_enter_start;
arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_enter_end;
arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_leave_start;
arch/sh/boards/mach-kfr2r09/setup.c:extern char kfr2r09_sdram_leave_end;
arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_enter_start;
arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_enter_end;
arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_leave_start;
arch/sh/boards/mach-migor/setup.c:extern char migor_sdram_leave_end;
arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_enter_start;
arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_enter_end;
arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_leave_start;
arch/sh/boards/mach-se/7724/setup.c:extern char ms7724se_sdram_leave_end;
arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_enter_start;
arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_enter_end;
arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_resume_start;
arch/sh/kernel/cpu/shmobile/pm.c:extern char sh_mobile_sleep_resume_end;
arch/x86/entry/vsyscall/vsyscall_64.c:  extern char __vsyscall_page;
arch/x86/include/asm/vvar.h:extern char __vvar_page;
kernel/configs.c:extern char kernel_config_data;
kernel/configs.c:extern char kernel_config_data_end;
net/bpfilter/bpfilter_kern.c:extern char bpfilter_umh_start;
net/bpfilter/bpfilter_kern.c:extern char bpfilter_umh_end;
samples/bpf/task_fd_query_user.c:       extern char __executable_start;
tools/testing/selftests/kvm/lib/aarch64/processor.c:    extern char vectors;
tools/testing/selftests/x86/test_syscall_vdso.c:extern char int80;

Of those, it looks like only a handful might trip FORTIFY:

$ for i in $(git grep 'extern char [^\*\[\( ]*;' | grep -v boot/ | awk -F' ' '{print $NF}' | cut -d';' -f1); do git grep -E '(strcpy|memcpy|memset).*'"$i",; done
arch/arm/mach-rockchip/platsmp.c:       memcpy_toio(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
arch/arm/mach-zynq/platsmp.c:                   memcpy_toio(zero, &zynq_secondary_trampoline,
arch/mips/dec/prom/memory.c:    memcpy((void *)(CKSEG0 + 0x80), &genexcept_early, 0x80);
arch/sh/kernel/cpu/shmobile/pm.c:       memcpy(vp, &sh_mobile_sleep_enter_start, n);
arch/sh/kernel/cpu/shmobile/pm.c:       memcpy(vp, &sh_mobile_sleep_resume_start, n);
arch/arm64/mm/trans_pgd.c:      memcpy(hyp_stub, &trans_pgd_stub_vectors, ARM64_VECTOR_TABLE_LEN);


-- 
Kees Cook
