Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC0A4F7618
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbiDGGfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiDGGf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:35:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558A27C787;
        Wed,  6 Apr 2022 23:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E669E61D61;
        Thu,  7 Apr 2022 06:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47324C385A4;
        Thu,  7 Apr 2022 06:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649313209;
        bh=sDANlglzy7xVa8qGoxcrgCLEkRlQHE1kd8mStA7Kz0c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q0EHT5pnwshFeUDmtz85bKrE/NAtBkY1SyxftEQ+3zRMyhbEqMn331qKHMfCHknO2
         /eKy55yCqS3/cnwKSYncJEYLWeMoXNzHjJieYuNYosu3o/3AE5wwf4/dGIlqvIH92E
         TCQ1lch8dSL5pr3JDvT11dqPE3HME8uWGkNmn678PJNs04mbQLEgmrchE1ldjvAH6b
         LpMiv8l+x+FiIxY/VlyANEPnLmmcXht4AYdrUwVBQTaPcmxphV4y48hJRAgffJeSGH
         CJJGAEHjPDfPvvedIGboghdIltzlyaMVa1k9OPT6wE/CoPvQM2NxK5Dyt3GEUPGww0
         OwHjJtonlDkLA==
Received: by mail-vk1-f173.google.com with SMTP id w67so200196vkw.6;
        Wed, 06 Apr 2022 23:33:29 -0700 (PDT)
X-Gm-Message-State: AOAM532Ct/116C9hukGAyEfGDzBwuNLWc5K66AxzTWdLya9JBiSI8p+3
        qAcOGZPzZ6E/SEL3CIbk19lFT5C7rpq3WeGW5EM=
X-Google-Smtp-Source: ABdhPJzMCqMoT2Gd6QJ5rs+cItH1+UtCvIzkKAHZRFSnh1VzJk3cciLCRxgzeP2vyn9dXGYHTrgGhuFB+wbWj19KRm8=
X-Received: by 2002:a1f:bd96:0:b0:33f:6185:f723 with SMTP id
 n144-20020a1fbd96000000b0033f6185f723mr4303359vkf.28.1649313208175; Wed, 06
 Apr 2022 23:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220406141649.728971-1-guoren@kernel.org> <Yk3YUFfvEszb+cXT@kroah.com>
In-Reply-To: <Yk3YUFfvEszb+cXT@kroah.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Thu, 7 Apr 2022 14:33:17 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQH-cnTx_x3xO=UZRTrhewb0damO_cqtPxhxoZe6bxr8g@mail.gmail.com>
Message-ID: <CAJF2gTQH-cnTx_x3xO=UZRTrhewb0damO_cqtPxhxoZe6bxr8g@mail.gmail.com>
Subject: Re: [PATCH V3] riscv: patch_text: Fixup last cpu should be master
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Palmer Dabbelt <palmer@dabbelt.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 7, 2022 at 2:13 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Apr 06, 2022 at 10:16:49PM +0800, guoren@kernel.org wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > These patch_text implementations are using stop_machine_cpuslocked
> > infrastructure with atomic cpu_count. The original idea: When the
> > master CPU patch_text, the others should wait for it. But current
> > implementation is using the first CPU as master, which couldn't
> > guarantee the remaining CPUs are waiting. This patch changes the
> > last CPU as the master to solve the potential risk.
> >
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Guo Ren <guoren@kernel.org>
> > Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  arch/riscv/kernel/patch.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> What commit id does this change fix?
Thx for pointing this out, I would follow the rule to add Cc:
<stable@vger.kernel.org>.

>


-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
