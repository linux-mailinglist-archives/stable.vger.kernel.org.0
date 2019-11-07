Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE17F33A7
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 16:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfKGPoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 10:44:03 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42842 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388901AbfKGPoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Nov 2019 10:44:02 -0500
Received: by mail-qk1-f196.google.com with SMTP id m4so2344339qke.9;
        Thu, 07 Nov 2019 07:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ys9AEr1EzcwNs1Yey+cVVTAWzE2JSG8awKOxUo23hbY=;
        b=OBKA6wdE/tTZ/oIoiLX0X3PbGgDgehAtEfxoYmVqACsnHlDMhVTnjWyoObP9zA7BnU
         +loCQUDBGwokaMHGGAGMaQlzlcvrtGCCI2FI4dYXui2DyVw85ZTZEZopMuxPcA27Sp34
         Gl5WUT1n/beeZyGkG4N54+0nn98qPbl/Ir0YBEc6NdVFDL83CiFr6W2ONJyemInQdOmu
         tG8vyOjiOjT/pPc5WcY/qYhFNTU35lN6yHpjjmz3xWq5LLDXWsh316EdeHyMSuGVKHDQ
         ZQtrLv++5WlZD6aVN4PYJfTTiznoR8preczDSzghd8/yALA6B+Kn9J/VctPveLl0jcoy
         I+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ys9AEr1EzcwNs1Yey+cVVTAWzE2JSG8awKOxUo23hbY=;
        b=EFfGytnR43SyyiQYXgdhuAwuF5uOuxXUvXiXl6Ix6D27AXOawmViPLIrCJWPMjhoGR
         dTAnmjvQH0h3u9vYEPwUQgmO6sa7DvWuhdi1ZOZW6sgh04xWq2XUhfajw480aliNbQ2G
         X+KiHXZrHYIEuRqF99VwBY//GL7d0biQBYCAfq+d8NNhEUgKGZEh+s/noz9E2Q6R/W4R
         dvVw7zhF/GGAGP82LxMWPQ8PDMaymw3oGe1zeIqbnysGDLcMYDqHb/ntMA604wV3Uh2U
         SGqWP2eZF3ejq1yzxWJ6iGa8T+3fkh0D1R08R0qIoyvLAyQ3YpygZJ5ECzYMTp0N5d5F
         zn2A==
X-Gm-Message-State: APjAAAUtMwQp8x6/ZHSg/J2b3Fd996wRm+1fhTz7ziXNEaN0heh7y9fR
        34nS52C7A9FQWdD2mxDwl+g=
X-Google-Smtp-Source: APXvYqxuKGWyC1WltFUO1XKmb5S5t3VbSp6aWbVPp/B9yDk5w2wfC/6mCIHhJIS/F43O7FzVOfmVbw==
X-Received: by 2002:a05:620a:999:: with SMTP id x25mr3557854qkx.189.1573141440343;
        Thu, 07 Nov 2019 07:44:00 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:3f13])
        by smtp.gmail.com with ESMTPSA id l14sm1305517qkj.61.2019.11.07.07.43.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 07:43:59 -0800 (PST)
Date:   Thu, 7 Nov 2019 07:43:58 -0800
From:   Tejun Heo <tj@kernel.org>
To:     Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191107154358.GY3622521@devbig004.ftw2.facebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106225131.3543616-1-guro@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 06, 2019 at 02:51:30PM -0800, Roman Gushchin wrote:
> We've encountered a rcu stall in get_mem_cgroup_from_mm():
> 
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu: 33-....: (21000 ticks this GP) idle=6c6/1/0x4000000000000002 softirq=35441/35441 fqs=5017
>  (t=21031 jiffies g=324821 q=95837) NMI backtrace for cpu 33
>  <...>
>  RIP: 0010:get_mem_cgroup_from_mm+0x2f/0x90
>  <...>
>  __memcg_kmem_charge+0x55/0x140
>  __alloc_pages_nodemask+0x267/0x320
>  pipe_write+0x1ad/0x400
>  new_sync_write+0x127/0x1c0
>  __kernel_write+0x4f/0xf0
>  dump_emit+0x91/0xc0
>  writenote+0xa0/0xc0
>  elf_core_dump+0x11af/0x1430
>  do_coredump+0xc65/0xee0
>  ? unix_stream_sendmsg+0x37d/0x3b0
>  get_signal+0x132/0x7c0
>  do_signal+0x36/0x640
>  ? recalc_sigpending+0x17/0x50
>  exit_to_usermode_loop+0x61/0xd0
>  do_syscall_64+0xd4/0x100
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The problem is caused by an exiting task which is associated with
> an offline memcg. We're iterating over and over in the
> do {} while (!css_tryget_online()) loop, but obviously the memcg won't
> become online and the exiting task won't be migrated to a live memcg.
> 
> Let's fix it by switching from css_tryget_online() to css_tryget().
> 
> As css_tryget_online() cannot guarantee that the memcg won't go
> offline, the check is usually useless, except some rare cases
> when for example it determines if something should be presented
> to a user.
> 
> A similar problem is described by commit 18fa84a2db0e ("cgroup: Use
> css_tryget() instead of css_tryget_online() in task_get_css()").
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
