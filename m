Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242D6368827
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 22:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhDVUoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 16:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbhDVUoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 16:44:15 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F2F3C06174A;
        Thu, 22 Apr 2021 13:43:39 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 79CBA92009C; Thu, 22 Apr 2021 22:43:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 73C7C92009B;
        Thu, 22 Apr 2021 22:43:38 +0200 (CEST)
Date:   Thu, 22 Apr 2021 22:43:38 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Guenter Roeck <linux@roeck-us.net>
cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-arch@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] MIPS: Reinstate platform `__div64_32' handler
In-Reply-To: <20210422183634.GA108385@roeck-us.net>
Message-ID: <alpine.DEB.2.21.2104222044560.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104200044060.44318@angie.orcam.me.uk> <alpine.DEB.2.21.2104200212500.44318@angie.orcam.me.uk> <20210422183634.GA108385@roeck-us.net>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 22 Apr 2021, Guenter Roeck wrote:

> This patch results in:
> 
> arch/mips/mti-malta/malta-time.c: In function 'plat_time_init':
> ./arch/mips/include/asm/div64.h:76:3: error: inconsistent operand constraints in an 'asm'
> 
> and similar errors when trying to compile malta_qemu_32r6_defconfig.

 Thanks for the heads-up, however the 0-DAY bot has caught this issue 
already last night and I would have addressed it earlier on if not for a 
failure of my Malta board :( which disrupted my verification.

> I tried with gcc 8.3.0, 8.4.0, 9.3.0, and 10.3.0.
> 
> Does this need some additional new compile flags ?

 MIPSr6 doesn't have the original division instruction along with the MD 
accumulator registers anymore, and consequently GCC cannot fit the 
constraint requested.

 We don't need that asm however.  Maybe we didn't with GCC 2.95 either, 
but I suspect there was something to it.  Anyway I have just posted a fix.

  Maciej
