Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67E9355EB9
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 00:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbhDFWWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 18:22:41 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38434 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbhDFWWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 18:22:38 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 91F1092009C; Wed,  7 Apr 2021 00:22:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 8AC7B92009B;
        Wed,  7 Apr 2021 00:22:28 +0200 (CEST)
Date:   Wed, 7 Apr 2021 00:22:28 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Zhou Yanjie <zhouyu@wanyeetech.com>,
        Huacai Chen <chenhuacai@kernel.org>
cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>, stable@vger.kernel.org,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
In-Reply-To: <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com>
Message-ID: <alpine.DEB.2.21.2104062343250.65251@angie.orcam.me.uk>
References: <20210406112404.2671507-1-chenhuacai@loongson.cn> <0338A250-3BF9-4B96-B9DE-61BE573CBB4C@goldelico.com> <3e27d0e0-4494-7a94-e0d7-046fb8898603@wanyeetech.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Apr 2021, Zhou Yanjie wrote:

> So it seems not a compiler problem.

 This code is rather broken in an obvious way, starting from:

	unsigned long long __n;						\
									\
	__high = *__n >> 32;						\
	__low = __n;							\

where `__n' is used uninitialised.  Since this is my code originally I'll 
look into it; we may want to reinstate `do_div' too, which didn't have to 
be removed in the first place.

 Also commit e8e4eb0fbeda ("asm-generic/div64: Fix documentation of 
do_div() parameter") was an incomplete documentation fix.

 Huacai, thanks for your investigation!  Please be more careful in 
verifying your future submissions however.

  Maciej
