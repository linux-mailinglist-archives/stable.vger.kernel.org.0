Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107A31405ED
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgAQJQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:16:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47382 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgAQJQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fd//sQhURzNiFh+3rBkISyoHiyHAC+Y1nYl72Fl+UGY=; b=w3CYcgiyynYypofPTttFS2ZPq
        eMkbppx5Xg5Afvj5g/fBtKuYp4hmkP3ZJlkx1H6RWPuGwAA4RzuS011mlbPapebhQF8EnfTfgDEBR
        VY6E+ytpC1YHjItk19vwSLVNWQXoLz6qIcBlnIcdilypz1rAeEPLKD6sCD+Q33LXxOADq4BHXzEqv
        sFvw981bXTAvLZbwLsBeo858CWxDwMb+6oclr/SnFfJSG7oMUJuwr5dyUFj5lfepQCzAhT3j83Fs8
        U03JmiUsLLmPBve7dTN08drPY/12pDdHII+hP9rii4OWCDjFcFE8iZ57dJLtapy7C5+ezS92ep5mO
        9I+0H3NHw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isNkC-0004bi-HH; Fri, 17 Jan 2020 09:16:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 24D27304A59;
        Fri, 17 Jan 2020 10:15:06 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4C94E20AFB27D; Fri, 17 Jan 2020 10:16:43 +0100 (CET)
Date:   Fri, 17 Jan 2020 10:16:43 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     kan.liang@linux.intel.com
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        like.xu@linux.intel.com, ak@linux.intel.com, stable@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] perf/x86/intel/uncore: Fix missing marker for
 snr_uncore_imc_freerunning_events
Message-ID: <20200117091643.GY2827@hirez.programming.kicks-ass.net>
References: <20200116200210.18937-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116200210.18937-1-kan.liang@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 12:02:09PM -0800, kan.liang@linux.intel.com wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> An Oops during the boot is found on some SNR machines.
> 
> [   15.795410] BUG: unable to handle page fault for address:
> 00000000000022b0
> [   15.795412] #PF: supervisor read access in kernel mode
> [   15.795413] #PF: error_code(0x0000) - not-present page
> [   15.795414] PGD 0 P4D 0
> [   15.795418] Oops: 0000 [#1] SMP NOPTI
> [   15.795420] CPU: 6 PID: 941 Comm: systemd-udevd Not tainted
> 5.3.0-snr-v5.3 #292
> [   15.795421] Hardware name: Intel Corporation JACOBSVILLE/JACOBSVILLE,
> BIOS JBVLCRB1.86B.0011.D44.1909191126 09/19/2019
> [   15.795428] RIP: 0010:strlen+0x0/0x20
> [   15.795431] Code: 48 89 f9 74 09 48 83 c1 01 80 39 00 75 f7 31 d2 44
> 0f
> b6 04 16 44 88 04 11 48 83 c2 01 45 84 c0 75 ee c3 0f 1f 80 00 00 00 00
> <80> 3f 00 74 10 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 c3 31
> [   15.855395] i801_smbus 0000:00:1f.4: SPD Write Disable is set
> [   15.858351] RSP: 0018:ffffaeb4812039c8 EFLAGS: 00010202
> [   15.858353] RAX: 0000000000000000 RBX: ffff9fec99c71300 RCX:
> 0000000000008000
> [   15.858354] RDX: 00000000000022b0 RSI: 0000000000000cc0 RDI:
> 00000000000022b0
> [   15.858355] RBP: 00000000000022b0 R08: 0000000000000000 R09:
> 0000000000000000
> [   15.858356] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff9fec8583a800
> [   15.858357] R13: 0000000000000cc0 R14: ffff9fec94015648 R15:
> ffff9fec81f291a8
> [   15.858358] FS:  00007f89e7160940(0000) GS:ffff9fec9dc00000(0000)
> knlGS:0000000000000000
> [   15.858361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.864343] i801_smbus 0000:00:1f.4: SMBus using polling
> [   15.869998] CR2: 00000000000022b0 CR3: 0000000842ca2000 CR4:
> 0000000000340ee0
> [   15.870000] Call Trace:
> [   15.870006]  kstrdup+0x1a/0x60
> [   15.870012]  __kernfs_new_node+0x41/0x1f0
> [   15.870018]  ? __mutex_unlock_slowpath+0x4d/0x2a0
> [   15.895135] ioatdma 0000:00:01.3: enabling device (0004 -> 0006)
> [   15.899395]  kernfs_new_node+0x36/0x60
> [   15.899400]  __kernfs_create_file+0x2c/0xf3
> [   15.961374]  sysfs_add_file_mode_ns+0xa4/0x1a0
> [   15.961379]  internal_create_group+0x117/0x370
> [   15.972133]  ? sysfs_add_file_mode_ns+0xa4/0x1a0
> [   15.972138]  internal_create_groups.part.0+0x3d/0xa0
> [   15.982656]  device_add+0x625/0x690
> [   15.982662]  pmu_dev_alloc+0x93/0xf0
> [   15.982664]  perf_pmu_register+0x292/0x3e0
> [   15.982674]  uncore_pmu_register+0x76/0x120 [intel_uncore]
> [   15.982681]  intel_uncore_init+0x1fd/0xe2c [intel_uncore]
> [   15.982688]  ? uncore_types_init+0x1d4/0x1d4 [intel_uncore]
> [   16.013580]  do_one_initcall+0x5d/0x2e4
> [   16.013584]  ? do_init_module+0x23/0x230
> [   16.013586]  ? rcu_read_lock_sched_held+0x6b/0x80
> [   16.013589]  ? kmem_cache_alloc_trace+0x2c4/0x2f0
> [   16.013591]  ? do_init_module+0x23/0x230
> [   16.013594]  do_init_module+0x5c/0x230
> [   16.013597]  load_module+0x2779/0x2a90
> [   16.013605]  ? ima_post_read_file+0xfd/0x110
> [   16.026926] ioatdma 0000:00:01.4: enabling device (0004 -> 0006)
> [   16.028808]  ? __do_sys_finit_module+0xaa/0x110
> [   16.060527]  __do_sys_finit_module+0xaa/0x110
> [   16.060536]  do_syscall_64+0x5c/0xb0
> [   16.060540]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This snr_uncore_imc_freerunning_events array was missing an end-marker.

Surely you can convey the same without the need to include that splat?
That is, what actual useful information is there that you cannot more
easily write?
