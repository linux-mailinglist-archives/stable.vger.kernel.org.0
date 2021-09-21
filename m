Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78ADF41320B
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 12:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhIULB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 07:01:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39370 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbhIULB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 07:01:26 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DB4472210B;
        Tue, 21 Sep 2021 10:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632221996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Dgb4dMSO/ZPMje1n5AU7MFOcooNI9E1W94iQ8KrDZ0=;
        b=ravFfU/S/tBIzibtKj4QZ4F7gmd7EznlZLFhUdqTeyP5BuwZPBG73WpZmjbG2jVd8Z2XA1
        FJd/w5kD9h+FKqVpAU/dSXvLcHzhIIHw8sV51LgG5ei5nZI3PHrYS4+8aoEvUDW04VZ2h1
        Kao/pJOVDlDA40DvW+pBZcJL+OgfAVs=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A998DA3B9A;
        Tue, 21 Sep 2021 10:59:56 +0000 (UTC)
Date:   Tue, 21 Sep 2021 12:59:56 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: fix for core dumping of a process getting oom-killed
Message-ID: <YUm7LLqwrXygzKll@dhcp22.suse.cz>
References: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 20-09-21 23:38:40, Vishnu Rangayyan wrote:
> 
> Processes inside a memcg that get core dumped when there is less memory
> available in the memcg can have the core dumping interrupted by the
> oom-killer.
> We saw this with qemu processes inside a memcg, as in this trace below.
> The memcg was not out of memory when the core dump was triggered.

Why is it important to mention that the the memcg was not oom when the
dump was triggered?

> [201169.028782] qemu-kata-syste invoked oom-killer: gfp_mask=0x101c4a(GFP_NOFS|__GFP_HIGHMEM|__GFP_HARDWALL|__GFP_MOVABLE|__GFP_WRITE),
> order=0, oom_score_adj=-100
[...]
> [201169.028863] memory: usage 12218368kB, limit 12218368kB, failcnt 1728013

it obviously is for the particular allocation from the core dumping
code.

> [201169.028864] memory+swap: usage 12218368kB, limit 9007199254740988kB, failcnt 0
> [201169.028864] kmem: usage 154424kB, limit 9007199254740988kB, failcnt 0
> [201169.028880] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=podacfa3d53-2068-4b61-a754-fa21968b4201,mems_allowed=0-1,oom_memcg=/kubepods/burstable/podacfa3d53-2068-4b61-a754-fa21968b4201,task_memcg=/kubepods/burstable/podacfa3d53-2068-4b61-a754-fa21968b4201,task=qemu-kata-syste,pid=1887079,uid=0
> [201169.028888] Memory cgroup out of memory: Killed process 1887079
> (qemu-kata-syste) total-vm:13598556kB, anon-rss:39836kB, file-rss:8712kB, shmem-rss:12017992kB, UID:0 pgtables:24204kB oom_score_adj:-100
> [201169.045201] oom_reaper: reaped process 1887079 (qemu-kata-syste), now anon-rss:0kB, file-rss:28kB, shmem-rss:12018016kB
> 
> This change adds an fsync only for regular file core dumps based on a
> configurable limit core_sync_bytes placed alongside other core dump params
> and defaults the limit to (an arbitrary value) of 128KB.
> Setting core_sync_bytes to zero disables the sync.

This doesn't really explain neither the problem nor the solution. Why
is fsync helping at all? Why do we need a new sysctl to address the
problem and how does it help to prevent the memcg OOM. Also why is this
a problem in the first place.

Have a look at the oom report. It says that only 8MB of the 11GB limit
is consumed by the file backed memory. The absolute majority (98%) is
sitting in the shmem and fsync will not help a wee bit there.
-- 
Michal Hocko
SUSE Labs
