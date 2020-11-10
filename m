Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BBE2AD2F5
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgKJJ7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:59:48 -0500
Received: from elvis.franken.de ([193.175.24.41]:50392 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgKJJ7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 04:59:48 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kcQRE-0003z6-00; Tue, 10 Nov 2020 10:59:44 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 028BDC4DDC; Tue, 10 Nov 2020 10:55:03 +0100 (CET)
Date:   Tue, 10 Nov 2020 10:55:03 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
Message-ID: <20201110095503.GA10357@alpha.franken.de>
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 11:34:33AM +0100, Alexander Sverdlin wrote:
> Hello Thomas,
> 
> On 07/11/2020 10:40, Thomas Bogendoerfer wrote:
> >> Linux doesn't own the memory immediately after the kernel image. On Octeon
> >> bootloader places a shared structure right close after the kernel _end,
> >> refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.
> >>
> >> If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
> >> inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
> >> memory block overlapping with the above octeon_bootinfo structure, which
> >> is being overwritten afterwards.
> > as this special for Octeon how about added the memblock_reserve
> > in octen specific code ?
> 
> while the shared structure which is being corrupted is indeed Octeon-specific,
> the wrong assumption that the memory right after the kernel can be allocated by memblock
> allocator and re-used somewhere in Linux is in MIPS-generic check_kernel_sections_mem().

ok, I see your point. IMHO this whole check_kernel_sections_mem() should
be removed. IMHO memory adding should only be done my memory detection code.

Could you send a patch, which removes check_kernel_section_mem completly ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
