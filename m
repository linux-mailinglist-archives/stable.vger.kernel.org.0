Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30A9214BA1
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 11:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgGEJtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 05:49:40 -0400
Received: from elvis.franken.de ([193.175.24.41]:49393 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgGEJtk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Jul 2020 05:49:40 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1js1HF-0002u8-00; Sun, 05 Jul 2020 11:49:37 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 3A04CC0770; Sun,  5 Jul 2020 11:46:12 +0200 (CEST)
Date:   Sun, 5 Jul 2020 11:46:12 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Add missing EHB in mtc0 -> mfc0 sequence for DSPen
Message-ID: <20200705094612.GA4064@alpha.franken.de>
References: <20200702225334.32414-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702225334.32414-1-hauke@hauke-m.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 12:53:34AM +0200, Hauke Mehrtens wrote:
> This resolves the hazard between the mtc0 in the change_c0_status() and
> the mfc0 in configure_exception_vector(). Without resolving this hazard
> configure_exception_vector() could read an old value and would restore
> this old value again. This would revert the changes change_c0_status()
> did. I checked this by printing out the read_c0_status() at the end of
> per_cpu_trap_init() and the ST0_MX is not set without this patch.
> 
> The hazard is documented in the MIPS Architecture Reference Manual Vol.
> III: MIPS32/microMIPS32 Privileged Resource Architecture (MD00088), rev
> 6.03 table 8.1 which includes:
> 
>    Producer | Consumer | Hazard
>   ----------|----------|----------------------------
>    mtc0     | mfc0     | any coprocessor 0 register
> 
> I saw this hazard on an Atheros AR9344 rev 2 SoC with a MIPS 74Kc CPU.
> There the change_c0_status() function would activate the DSPen by
> setting ST0_MX in the c0_status register. This was reverted and then the
> system got a DSP exception when the DSP registers were saved in
> save_dsp() in the first process switch. The crash looks like this:
> 
> [    0.089999] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
> [    0.097796] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
> [    0.107070] Kernel panic - not syncing: Unexpected DSP exception
> [    0.113470] Rebooting in 1 seconds..
> 
> We saw this problem in OpenWrt only on the MIPS 74Kc based Atheros SoCs,
> not on the 24Kc based SoCs. We only saw it with kernel 5.4 not with
> kernel 4.19, in addition we had to use GCC 8.4 or 9.X, with GCC 8.3 it
> did not happen.
> 
> In the kernel I bisected this problem to commit 9012d011660e ("compiler:
> allow all arches to enable CONFIG_OPTIMIZE_INLINING"), but when this was
> reverted it also happened after commit 172dcd935c34b ("MIPS: Always
> allocate exception vector for MIPSr2+").
> 
> Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")
> does similar changes to a different file. I am not sure if there are
> more places affected by this problem.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/mips/kernel/traps.c | 1 +
>  1 file changed, 1 insertion(+)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
