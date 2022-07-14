Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186C9574568
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 09:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiGNG7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 02:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiGNG7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 02:59:50 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AB831358;
        Wed, 13 Jul 2022 23:59:49 -0700 (PDT)
Received: from mail-yw1-f179.google.com ([209.85.128.179]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N1gWU-1nRZcp1vKq-0121bf; Thu, 14 Jul 2022 08:59:47 +0200
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-3137316bb69so7773597b3.10;
        Wed, 13 Jul 2022 23:59:46 -0700 (PDT)
X-Gm-Message-State: AJIora9GH7WajOmMba1dYRPU+hdA234H9buJh6Ky2tf8vSs4aT4bl4na
        BGtE5eGvzJR9z4uFeVZ4KnqGveEcFmGdhIPgw/c=
X-Google-Smtp-Source: AGRyM1tgxYSVD/gYAxs1WCM6JhzELwA8WwTUgiYEaMRwN6Q6Zg/uUd6yRx65tlEIUnIRkovs/IpphI7wi/ZKPISkkKw=
X-Received: by 2002:a81:f8f:0:b0:31c:bd9f:31ce with SMTP id
 137-20020a810f8f000000b0031cbd9f31cemr8121384ywp.347.1657781985894; Wed, 13
 Jul 2022 23:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-3-chenhuacai@loongson.cn> <CAMuHMdUazqHLbc80vpZ+Msg9A3j5aPJ3fx+CdCG3kuWDSf8WSw@mail.gmail.com>
 <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com>
 <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
 <CAAhV-H78Fi0aE-h5MOgRa5L+Jt7D0wG0nLcYzx45jVney8T1BQ@mail.gmail.com>
 <CAMuHMdVXFmKR4LuXHYRrSk3Q0VRqATGbsM512DxayWCPCE-wvg@mail.gmail.com>
 <c8c959fa-f17d-f0dd-6a8d-e0b0ce622f3a@xen0n.name> <CAAhV-H6g5nLGJMz0ZsZqC5-73VSGffVdc6r0=3HHBo3Z8PQOBg@mail.gmail.com>
In-Reply-To: <CAAhV-H6g5nLGJMz0ZsZqC5-73VSGffVdc6r0=3HHBo3Z8PQOBg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 14 Jul 2022 08:59:28 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0GUPSYBai3Z9vzw0wrXGLFiik6hdY3zc6nQ6mQs7yHvQ@mail.gmail.com>
Message-ID: <CAK8P3a0GUPSYBai3Z9vzw0wrXGLFiik6hdY3zc6nQ6mQs7yHvQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] M68K: cpuinfo: Fix a warning for CONFIG_CPUMASK_OFFSTACK
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     WANG Xuerui <kernel@xen0n.name>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Simek <monstr@monstr.eu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        loongarch@lists.linux.dev, Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:S+dPkrdCzelsMkcwO0BrfMc/NpzZrrixUyf7kOvJSMedG2kadje
 9CLju2PAGNjHMpIu7w6bLZ7Lgdlc/mH9RmE4ioSBlCVmVSuKm3xaJK9FGj1w1vHmo7qPy8D
 XkJk0hQRPq7YUnlXAEVdobnLJGu8dB9RIkWydZGZr6CsoNdbS9b4sHhfjirDdDHZneN+7wu
 SWPt6Sbx7168UDuceg8nw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:j1f5yUH9gOg=:D0C9pIIxbHRz8DL8BN9Eho
 Wl2eHXYYGr+4tCVeCxkvN1i5c+HXdSXsDKh7l6gnyx8RbsDgjgnYxZBYIQo0CgRotdtzV/AA9
 dCOw0znX1Fx90hK8PVCSVIFwBbySXFGrkVT3BFnXFOgpvmDpakkZK2uJc2FCm9dn2qiER/8UH
 NOAs1qa1uDTPJuLMVIHbiG9pkhVPhgMiII0v+NyOuDa8d/l8GE9DahcEflOrKJA/LwExsLYT0
 zuKYZq8LiLpmq2AqpQFC4xVEFBf5dFJ/0Qfyq/Zw1CXnR5YcW7mJk2L3Or3sN7DhqvUrrvv51
 D9QhMJrWOUxH8628xoTjsQlkFqHTWEBPQ5exFO6RXFuJ01k0WqF4C5J26u9CieWish+AnWnxu
 uMUrDeoXYeQih/zIRYGL2qBX+zdNNTIimHAkGJNwN0efT9N7o0sPVt/GBMO+WhpeXBO0OOhCE
 FFLzQvys24vsGzKgoLgJtLzwEcZHbq4xx+hYmiNdZVsDqlQOlj/mIw2/TTlfCXn2utZPbiixS
 +q2mAU+PxK9ldbEin2VD9DPIUdM8QZd7g3lp1mrcGM1nJO8tu3jgJCYMSYZPA3bgsIkHF6i46
 5/Fv/ceTX8O6T/ynvDF8QD0JVO8VbJPWXDdNxdnt0fMTVXS7IefR5y9zm3qjLFVdcG7xh3GsG
 d23Cwg9bjlFqdpBfpq8/Sqst0Zczz5xuNVXuTWYRmoBa2lxrVGKbBJ0lF1XEKvfOZOj83Kr7C
 W+vbCp+p78WJrgnGIDFEij9c8LrhhObmmmAxpg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 4:07 AM Huacai Chen <chenhuacai@gmail.com> wrote:
> On Tue, Jul 12, 2022 at 6:15 PM WANG Xuerui <kernel@xen0n.name> wrote:
> > On 2022/7/12 17:13, Geert Uytterhoeven wrote:
> >
> > But judging from the intent of this patch series (fixing WARNs on
> > certain configs), and that the triggering condition is currently
> > impossible on m68k (and other non-SMP) platforms, I think cleanups for
> > such arches could come as a separate patch series later. I think the
> > m68k refactoring is reasonable after all, due to my observation above,
> > but for the other non-SMP arches we may want to wait for the respective
> > maintainers' opinions.
>
> It seems that the best solution is only fix architectures with SMP
> support and leave others (m68k, microblaze, um) as is. :)

I think it probably makes sense to do this as a combined cleanup patch,
which I can merge through the asm-generic tree, for all architectures
whose maintainer does not pick it up directly. For SMP architectures,
it's a bugfix that we probably want backported into stable kernels, while
for non-SMP targets it is just a minor cleanup for consistency.

        Arnd
