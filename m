Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834C93FBDA1
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 22:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhH3UwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 16:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhH3UwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 16:52:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0E8C061575;
        Mon, 30 Aug 2021 13:51:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mKoFU-0006gk-Ck; Mon, 30 Aug 2021 22:51:20 +0200
Date:   Mon, 30 Aug 2021 22:51:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Yuri Lipnesh <yuri.lipnesh@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: System crash in netfilter  5.10.25
Message-ID: <20210830205120.GC13818@breakpoint.cc>
References: <B37EABB8-355F-4A05-9BF3-1119D1E0470D@gmail.com>
 <20201130195857.GM2730@breakpoint.cc>
 <5BABE543-DFBB-42C0-8CA8-74C80C5F4CC0@gmail.com>
 <E6F18819-9148-4538-B58C-5189F8641E22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E6F18819-9148-4538-B58C-5189F8641E22@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yuri Lipnesh <yuri.lipnesh@gmail.com> wrote:
> Hello Florian,
> 
> I need assistance on this one. Our customer system 5.10.25-flatcar crashed with following trace
> 
> Aug 26 10:26:32.686733 amc-k8sdevsl01-worker-lx13 kernel: ------------[ cut here ]------------
> Aug 26 10:26:32.686855 amc-k8sdevsl01-worker-lx13 kernel: refcount_t: underflow; use-after-free.
> Aug 26 10:26:32.686877 amc-k8sdevsl01-worker-lx13 kernel: WARNING: CPU: 4 PID: 2422635 at lib/refcount.c:28 refcount_warn_saturat>
> Aug 26 10:26:32.686930 amc-k8sdevsl01-worker-lx13 kernel: Modules linked in: binfmt_misc nfnetlink_queue xt_NFQUEUE xt_multiport >
> Aug 26 10:26:32.689906 amc-k8sdevsl01-worker-lx13 kernel:  dm_region_hash dm_log dm_mod
> Aug 26 10:26:32.690398 amc-k8sdevsl01-worker-lx13 kernel: CPU: 4 PID: 2422635 Comm: worker-1 Not tainted 5.10.25-flatcar #1
> Aug 26 10:26:32.690526 amc-k8sdevsl01-worker-lx13 kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Refer>
> Aug 26 10:26:32.691653 amc-k8sdevsl01-worker-lx13 kernel: RIP: 0010:refcount_warn_saturate+0xa6/0xf0
> Aug 26 10:26:32.691720 amc-k8sdevsl01-worker-lx13 kernel: Code: 05 3c 1d 40 01 01 e8 81 46 38 00 0f 0b c3 80 3d 2a 1d 40 01 00 75>
> Aug 26 10:26:32.691747 amc-k8sdevsl01-worker-lx13 kernel: RSP: 0018:ffffa3a0c3627938 EFLAGS: 00010282
> Aug 26 10:26:32.692385 amc-k8sdevsl01-worker-lx13 kernel: RAX: 0000000000000000 RBX: ffff8c011b14fa00 RCX: 0000000000000027
> Aug 26 10:26:32.692422 amc-k8sdevsl01-worker-lx13 kernel: RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff8c045d918b08
> Aug 26 10:26:32.692446 amc-k8sdevsl01-worker-lx13 kernel: RBP: ffff8c011b14fa00 R08: ffff8c045d918b00 R09: ffffa3a0c3627750
> Aug 26 10:26:32.693526 amc-k8sdevsl01-worker-lx13 kernel: R10: 0000000000000001 R11: 0000000000000001 R12: ffff8c011b14fa30
> Aug 26 10:26:32.693584 amc-k8sdevsl01-worker-lx13 kernel: R13: 0000000000000002 R14: ffff8bfda3b43180 R15: ffff8c00cddb3a00
> Aug 26 10:26:32.693615 amc-k8sdevsl01-worker-lx13 kernel: FS:  00007ff7a2331b38(0000) GS:ffff8c045d900000(0000) knlGS:00000000000>
> Aug 26 10:26:32.693649 amc-k8sdevsl01-worker-lx13 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Aug 26 10:26:32.694304 amc-k8sdevsl01-worker-lx13 kernel: CR2: 00007ff79ac17a28 CR3: 00000001ee34e003 CR4: 00000000007706e0
> Aug 26 10:26:32.694334 amc-k8sdevsl01-worker-lx13 kernel: PKRU: 55555554
> Aug 26 10:26:32.694351 amc-k8sdevsl01-worker-lx13 kernel: Call Trace:
> Aug 26 10:26:32.694370 amc-k8sdevsl01-worker-lx13 kernel:  nf_queue_entry_release_refs+0x82/0xa0

Is that sock_put()?

If so, I don't understand this backtrace.  When refcount_t debugging is
on, sock_hold() would also generate a backtrace in case we try to
incrase refcount on a socket that already has a zero refcount.

So, looks like something else decremented sk refcount while packet
was queued.  No idea how that could happen.
