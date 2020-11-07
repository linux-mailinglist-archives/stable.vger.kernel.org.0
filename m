Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E158D2AA482
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 12:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgKGLEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 06:04:37 -0500
Received: from elvis.franken.de ([193.175.24.41]:44453 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgKGLEg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 06:04:36 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kbM1K-0001Xd-00; Sat, 07 Nov 2020 12:04:34 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id E2D77C4DDA; Sat,  7 Nov 2020 10:40:28 +0100 (CET)
Date:   Sat, 7 Nov 2020 10:40:28 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org,
        Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
Message-ID: <20201107094028.GA4918@alpha.franken.de>
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 06, 2020 at 03:10:01PM +0100, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Linux doesn't own the memory immediately after the kernel image. On Octeon
> bootloader places a shared structure right close after the kernel _end,
> refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.
> 
> If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
> inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
> memory block overlapping with the above octeon_bootinfo structure, which
> is being overwritten afterwards.

as this special for Octeon how about added the memblock_reserve
in octen specific code ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
