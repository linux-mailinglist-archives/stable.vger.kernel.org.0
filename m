Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768ED50D041
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 09:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiDXHhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 03:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiDXHhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 03:37:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E507175DD7;
        Sun, 24 Apr 2022 00:34:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB12E612A0;
        Sun, 24 Apr 2022 07:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3071C385AB;
        Sun, 24 Apr 2022 07:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650785650;
        bh=xI1NIfvXpmPp9D3ctWwWfmXIYM7XRmpUpv+03lUnZqY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z3YaV9tdWWy2hStE6/D5nBZ8H+tgRYDaZJuLqEMQOpdcaTA5btejAKV5nGs4FVkFw
         lztUtmGnYL7ij4B3m5usmfn0kp6+WDZwm3wV85W3giGmPvsaMI6qcSM6tkSYLBZuGJ
         F4K0ZjWW9IrtktJUZbMtT1AAO+znqc47yH1DejHSU1OHVpLM2Tfm7mP+IdGl9MBbfH
         r3HqJ7fsdf8SHeFANAll2AaNybVbsKpj85C9uZRc9QMSA26xvawE4saVHPevzSROBp
         ik352AGAWQmV7O8Ra4j8tKA8RJ+DAoNedBydzG76onwRCgpKbb1MAbN0Y+lalgPvbZ
         dP46StgCi9pDw==
Received: by mail-ua1-f51.google.com with SMTP id o10so4588332uar.0;
        Sun, 24 Apr 2022 00:34:09 -0700 (PDT)
X-Gm-Message-State: AOAM530iLLyzTv5TdSaT1NPAYRa8npRDvn969HJuI6pO2pijGjisYvMb
        5rJ4YcytSPnp8xlWP0ubWamFuhFFC6Asq3SxQWY=
X-Google-Smtp-Source: ABdhPJwjPIhNxj9bMKUtEcaBvPXsYsrvGPar68HbF3WXf8ryDmI47RVT1niIuAX7Rtzo9xZ57yNdHmTuxo5upiU+VlA=
X-Received: by 2002:ab0:375b:0:b0:355:c2b3:f6c with SMTP id
 i27-20020ab0375b000000b00355c2b30f6cmr3613271uat.84.1650785648925; Sun, 24
 Apr 2022 00:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <mhng-320b7f4f-08bf-4ee8-938e-4bf687760468@palmer-ri-x1c9> <mhng-d2e23c07-fd6f-4ae8-a2c7-fc1825e50503@palmer-ri-x1c9>
In-Reply-To: <mhng-d2e23c07-fd6f-4ae8-a2c7-fc1825e50503@palmer-ri-x1c9>
From:   Guo Ren <guoren@kernel.org>
Date:   Sun, 24 Apr 2022 15:33:57 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSaAmg_-G+z7G=wea=cM_F_c17WvoDtxryxacT9wseMvg@mail.gmail.com>
Message-ID: <CAJF2gTSaAmg_-G+z7G=wea=cM_F_c17WvoDtxryxacT9wseMvg@mail.gmail.com>
Subject: Re: [PATCH V3] riscv: patch_text: Fixup last cpu should be master
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 23, 2022 at 12:02 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Thu, 21 Apr 2022 15:57:32 PDT (-0700), Palmer Dabbelt wrote:
> > On Wed, 06 Apr 2022 07:16:49 PDT (-0700), guoren@kernel.org wrote:
> >> From: Guo Ren <guoren@linux.alibaba.com>
> >>
> >> These patch_text implementations are using stop_machine_cpuslocked
> >> infrastructure with atomic cpu_count. The original idea: When the
> >> master CPU patch_text, the others should wait for it. But current
> >> implementation is using the first CPU as master, which couldn't
> >> guarantee the remaining CPUs are waiting. This patch changes the
> >> last CPU as the master to solve the potential risk.
> >>
> >> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> >> Signed-off-by: Guo Ren <guoren@kernel.org>
> >> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> >> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> >> Cc: <stable@vger.kernel.org>
> >> ---
> >>  arch/riscv/kernel/patch.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
> >> index 0b552873a577..765004b60513 100644
> >> --- a/arch/riscv/kernel/patch.c
> >> +++ b/arch/riscv/kernel/patch.c
> >> @@ -104,7 +104,7 @@ static int patch_text_cb(void *data)
> >>      struct patch_insn *patch = data;
> >>      int ret = 0;
> >>
> >> -    if (atomic_inc_return(&patch->cpu_count) == 1) {
> >> +    if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
> >>              ret =
> >>                  patch_text_nosync(patch->addr, &patch->insn,
> >>                                          GET_INSN_LENGTH(patch->insn));
> >
> > Thanks, this is on fixes.
>
> Sorry, I forgot to add the Fixes and stable tags.  I just fixed that up,
> but I'm going to hold off on this one until next week's PR to make sure
> it has time to go through linux-next.

https://lore.kernel.org/linux-riscv/20220407073323.743224-3-guoren@kernel.org/

-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
