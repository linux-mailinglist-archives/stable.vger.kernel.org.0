Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC333624CA
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhDPP7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 11:59:35 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:39020 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbhDPP7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 11:59:34 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 669D492009C; Fri, 16 Apr 2021 17:59:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 5FA6392009B;
        Fri, 16 Apr 2021 17:59:08 +0200 (CEST)
Date:   Fri, 16 Apr 2021 17:59:08 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Huacai Chen <chenhuacai@kernel.org>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Remove unused and erroneous div64.h
In-Reply-To: <CAAhV-H7fPhA+vKNAYNdVsjZkU75CaVv2btpwRYh9E4XcX9h14A@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2104161722050.44318@angie.orcam.me.uk>
References: <20210412033451.215379-1-chenhuacai@loongson.cn> <alpine.DEB.2.21.2104121604150.65251@angie.orcam.me.uk> <CAAhV-H7fPhA+vKNAYNdVsjZkU75CaVv2btpwRYh9E4XcX9h14A@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Apr 2021, Huacai Chen wrote:

> >  I think this is a weak argument for removal, isn't it?
> Yes ,it is weak, but I'm not able to fix it, could you please help me?

 First of all you need to assign the quotient to `*n' rather than `__n', 
which is a temporary only.  Otherwise it's discarded, so no surprise the 
piece does not work.

 Also this piece assumes the quotient will fit in 32 bits (which should be 
obvious from the name and data type of the relevant temporary if not the 
asm itself), which is what the initial division of the high part was for 
before commit c21004cd5b4c and which the `do_div' wrapper does not arrange 
for.  Said commit is really broken indeed as it mustn't have dropped the 
initial division and instead it should have only amended the asm for the 
removal of the `h' constraint (easy fix).

  Maciej
