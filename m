Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799522D5E1
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 09:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgGYHpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 03:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgGYHpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 Jul 2020 03:45:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96722206D8;
        Sat, 25 Jul 2020 07:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595663124;
        bh=7QK0jdv7L/XYabceKYTUpH6jDGEQYNGzS8MYY4oCwoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xDI+ZMzn7zGfQUD9GqdVjanih3/VBI7eV3Xi+yq6ebgI8wZ9sI3mSZXjphrD1PGbh
         DHEedTuiQE0QFSiDAsuJPosTaR60tDGKQNin3fUBreBmAhMCeGSR4JvAdhNeTu0cH5
         zZ0GYi25AvHnNgGxILedsxLRDPt9uekjkmhTJRZ4=
Date:   Sat, 25 Jul 2020 09:45:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH V2] MIPS: CPU#0 is not hotpluggable
Message-ID: <20200725074521.GA347597@kroah.com>
References: <1594896024-16624-1-git-send-email-chenhc@lemote.com>
 <CAAhV-H4QH-cyabcfYyNJv89LpOdpsXN+dpZBYy0gNKmSnsUsKA@mail.gmail.com>
 <20200725064923.GA1059787@kroah.com>
 <CAAhV-H7WgGy=NKZ-YwDTQ1HtNT--qp2J8m25RmxpsdUBbmm8oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H7WgGy=NKZ-YwDTQ1HtNT--qp2J8m25RmxpsdUBbmm8oQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 25, 2020 at 02:57:31PM +0800, Huacai Chen wrote:
> Hi Greg,
> 
> On Sat, Jul 25, 2020 at 2:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Jul 25, 2020 at 02:37:52PM +0800, Huacai Chen wrote:
> > > Hi, Thomas,
> > >
> > > What do you think about this patch? Other archs also do the same thing
> > > except those support hotplug CPU#0.
> > >
> > > grep hotpluggable arch -rwI
> > > arch/riscv/kernel/setup.c:        cpu->hotpluggable = cpu_has_hotplug(i);
> > > arch/powerpc/kernel/sysfs.c:    BUG_ON(!c->hotpluggable);
> > > arch/powerpc/kernel/sysfs.c:            c->hotpluggable = 1;
> > > arch/powerpc/kernel/sysfs.c:        if (cpu_online(cpu) || c->hotpluggable) {
> > > arch/arm/kernel/setup.c:        cpuinfo->cpu.hotpluggable =
> > > platform_can_hotplug_cpu(cpu);
> > > arch/sh/kernel/topology.c:        c->hotpluggable = 1;
> > > arch/ia64/kernel/topology.c:     * CPEI target, then it is hotpluggable
> > > arch/ia64/kernel/topology.c:        sysfs_cpus[num].cpu.hotpluggable = 1;
> > > arch/xtensa/kernel/setup.c:        cpu->hotpluggable = !!i;
> > > arch/s390/kernel/smp.c:    c->hotpluggable = 1;
> > > arch/mips/kernel/topology.c:        c->hotpluggable = 1;
> > > arch/arm64/kernel/cpuinfo.c: * In case the boot CPU is hotpluggable,
> > > we record its initial state and
> > > arch/arm64/kernel/setup.c:        cpu->hotpluggable = cpu_can_disable(i);
> > > arch/x86/kernel/topology.c:        per_cpu(cpu_devices,
> > > num).cpu.hotpluggable = 1;
> > >
> > > On Thu, Jul 16, 2020 at 6:38 PM Huacai Chen <chenhc@lemote.com> wrote:
> > > >
> > > > Now CPU#0 is not hotpluggable on MIPS, so prevent to create /sys/devices
> > > > /system/cpu/cpu0/online which confuses some user-space tools.
> >
> > What userspace tools are confused by this?  They should be able to
> > handle a cpu not being able to be removed, right?
> It causes ltp's "hotplug" test fails, and ltp considers CPUs with a
> "online" node be hotpluggable.

Is that always true?
