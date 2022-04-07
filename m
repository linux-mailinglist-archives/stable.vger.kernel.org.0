Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4951F4F765B
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 08:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbiDGGkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 02:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiDGGkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 02:40:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFA07487F;
        Wed,  6 Apr 2022 23:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D87C8B826C8;
        Thu,  7 Apr 2022 06:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C414C385A4;
        Thu,  7 Apr 2022 06:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649313488;
        bh=Gux6lWZnh1FCuzmez/42YXdKcrwefRFpEz+LdkFz5x4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aiyIuSfpcG1qz6EGNC86MrI3RdvIauFp9sq1Oqv7W+J6KKvsLjM6HG/PRX/xGG01g
         7g7fm0z6o/qfCGrKUeRbTZn6zoeK7yZdqSSus0pMCD+e3l/uT+JXhBVhAkfro/AAmO
         YPtdbfnazds93BKkX57L7BCql1I4ds/n231CFFjKXNLpNr9iG4npZaQSrpTgQawtM/
         yC3U+px6Ua/tNEuGE/3z1x4b+tMEp7RIzGJjsU/PRmVQBtROFinwCNYYCDzkWhGoSK
         LVet4cYqS5CEtpVnvmCfA5/3AoFImoPOHeoi/GowBuWWRK3hBFad7qgjVwPT1XDDCw
         qRWovNhiPVi/Q==
Received: by mail-vs1-f54.google.com with SMTP id i186so2711793vsc.9;
        Wed, 06 Apr 2022 23:38:08 -0700 (PDT)
X-Gm-Message-State: AOAM531W20gciLl3dFssKC9peA0ruBujGNzJd4Q1zd+15cjieZZOLv+b
        89b6kQ8zWl8FN3URu5vFI2oJPX+IUbIbPVCa0a0=
X-Google-Smtp-Source: ABdhPJylGTAuJqUgFINt36UMdY4cxe8//+64nyYwPKu/po3UjzHUT7TwO3ZZR2flKLlmn1dbTBE+65LpjyZAsdhtZdU=
X-Received: by 2002:a05:6102:dd1:b0:325:80a9:b5d7 with SMTP id
 e17-20020a0561020dd100b0032580a9b5d7mr3705620vst.51.1649313487469; Wed, 06
 Apr 2022 23:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220406142819.730238-1-guoren@kernel.org> <CAMo8BfK6uo5fPCbo8Wp3oRYOUXoz0jv_zJMHuVHhFgh3DSSqNQ@mail.gmail.com>
In-Reply-To: <CAMo8BfK6uo5fPCbo8Wp3oRYOUXoz0jv_zJMHuVHhFgh3DSSqNQ@mail.gmail.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Thu, 7 Apr 2022 14:37:56 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQ5zPrEtaxowmQOj5gBMtinB1NbuVUG9qvuDfB9vNvG5A@mail.gmail.com>
Message-ID: <CAJF2gTQ5zPrEtaxowmQOj5gBMtinB1NbuVUG9qvuDfB9vNvG5A@mail.gmail.com>
Subject: Re: [PATCH V3] xtensa: patch_text: Fixup last cpu should be master
To:     Max Filippov <jcmvbkbc@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Chris Zankel <chris@zankel.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>,
        Guo Ren <guoren@linux.alibaba.com>,
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

On Thu, Apr 7, 2022 at 11:35 AM Max Filippov <jcmvbkbc@gmail.com> wrote:
>
> On Wed, Apr 6, 2022 at 7:28 AM <guoren@kernel.org> wrote:
> >
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
> > Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
> > Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  arch/xtensa/kernel/jump_label.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Thanks. Applied to my xtensa tree.
I've missed the "Fixes:" for stable@vger.kernel.org, so I would update
v3 to fix it.

>
> -- Max



-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
