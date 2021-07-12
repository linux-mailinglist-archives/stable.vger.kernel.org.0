Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD833C6204
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 19:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhGLRhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhGLRhJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 13:37:09 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74124C0613DD;
        Mon, 12 Jul 2021 10:34:20 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d12so17098350pfj.2;
        Mon, 12 Jul 2021 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dq1jvDdXTK3hPVpaflQY/7pmeNVzVpqqMkyrGDnxofw=;
        b=Xutdy37M5pl0qFk6+hXl+vOgxLdLFCTRAj4GAgtIQr9f/JGHN1SUCqafTq7GC3fJJZ
         jNofrMKljnNlSUTeihaCuJOyvZadgSHtTjrQlPpQj28Ng/YPym5cAin3UkVdsXOPZ0m6
         /9Cf5i/HQ8ODSJBuF1Ka+o+HPyHbzyWqdCjoqAk1jRm/aI0RxO9Ea6maU4L/3GNi69R+
         6c5KyhsMJmudDz+IMyngx2FlVmPHXdE0pEZS0XWe+Wv7FmSAylo+HjUihYJKdttMwid9
         +g8AobcYGNmnq+2LgfD0oTUJo9sAjV2zBGcCXQvo6XDNkjFT+Qa5ZPIRyr2wfyp9/rh+
         9uyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=dq1jvDdXTK3hPVpaflQY/7pmeNVzVpqqMkyrGDnxofw=;
        b=b7dz4+hmediBNPOd1OllbWOvWTYj3CsBSXN2iYGMQOYSye+QqlwKw6N3HieWcSonRG
         KxaQ15nQGYa1qo2VGHAUXtogidp9Rqmyz6v2t8fM8uHL8Z7P2K34sg9jmnLVLYYSgg82
         ZN5YaxYUxSgK67SmaOX8bUyyFKQJIe6b5irtHor5BIoC8Ombw/BWR5QWw/yyFTUmPrBb
         P/3+VRLPxlV4HAsfQQN0fZMdaCbXuquBgl4//2rbIhrczn5E4lOP9nUjvwbaxtkEQ7RR
         CClXmBnFHEYhfGxuCSh6M7DTN8pOPYPriUvVld63F5FnhjOl2swPqG1Qj4lVjOwlzfNa
         phIw==
X-Gm-Message-State: AOAM530JdUfhRSDmbIwjjKOLLEXSNL8u1s7JIWfAXR30Fpiojo8Tj2gO
        dedaTAMHhnB6FSJ2JqAw9eA=
X-Google-Smtp-Source: ABdhPJwGuhmZbl66NISYxIJVtk4a88Di26Sndf15pXESQwz+E7Vj2LYtt4yqabiGahmyMWv5adrZeQ==
X-Received: by 2002:a62:e80f:0:b029:320:ae39:24fc with SMTP id c15-20020a62e80f0000b0290320ae3924fcmr187965pfi.18.1626111259841;
        Mon, 12 Jul 2021 10:34:19 -0700 (PDT)
Received: from localhost (udp264798uds.hawaiiantel.net. [72.253.242.87])
        by smtp.gmail.com with ESMTPSA id 5sm18866487pgv.25.2021.07.12.10.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:34:19 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 12 Jul 2021 07:34:18 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Message-ID: <YOx9GkxAGwAb3Yyr@slm.duckdns.org>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210616125157.438837-1-paul.gortmaker@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 08:51:57AM -0400, Paul Gortmaker wrote:
> Richard reported sporadic (roughly one in 10 or so) null dereferences and
> other strange behaviour for a set of automated LTP tests.  Things like:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000008
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP PTI
>    CPU: 0 PID: 1516 Comm: umount Not tainted 5.10.0-yocto-standard #1
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
>    RIP: 0010:kernfs_sop_show_path+0x1b/0x60
> 
> ...or these others:
> 
>    RIP: 0010:do_mkdirat+0x6a/0xf0
>    RIP: 0010:d_alloc_parallel+0x98/0x510
>    RIP: 0010:do_readlinkat+0x86/0x120
> 
> There were other less common instances of some kind of a general scribble
> but the common theme was mount and cgroup and a dubious dentry triggering
> the NULL dereference.  I was only able to reproduce it under qemu by
> replicating Richard's setup as closely as possible - I never did get it
> to happen on bare metal, even while keeping everything else the same.
> 
> In commit 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
> we see this as a part of the overall change:
> 
>    --------------
>            struct cgroup_subsys *ss;
>    -       struct dentry *dentry;
> 
>    [...]
> 
>    -       dentry = cgroup_do_mount(&cgroup_fs_type, fc->sb_flags, root,
>    -                                CGROUP_SUPER_MAGIC, ns);
> 
>    [...]
> 
>    -       if (percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>    -               struct super_block *sb = dentry->d_sb;
>    -               dput(dentry);
>    +       ret = cgroup_do_mount(fc, CGROUP_SUPER_MAGIC, ns);
>    +       if (!ret && percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>    +               struct super_block *sb = fc->root->d_sb;
>    +               dput(fc->root);
>                    deactivate_locked_super(sb);
>                    msleep(10);
>                    return restart_syscall();
>            }
>    --------------
> 
> In changing from the local "*dentry" variable to using fc->root, we now
> export/leave that dentry pointer in the file context after doing the dput()
> in the unlikely "is_dying" case.   With LTP doing a crazy amount of back to
> back mount/unmount [testcases/bin/cgroup_regression_5_1.sh] the unlikely
> becomes slightly likely and then bad things happen.
> 
> A fix would be to not leave the stale reference in fc->root as follows:
> 
>    --------------
>                   dput(fc->root);
>   +               fc->root = NULL;
>                   deactivate_locked_super(sb);
>    --------------
> 
> ...but then we are just open-coding a duplicate of fc_drop_locked() so we
> simply use that instead.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org      # v5.1+
> Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
> Fixes: 71d883c37e8d ("cgroup_do_mount(): massage calling conventions")
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

I dropped the ball on this and this didn't get pushed. Re-applied to
for-5.14-fixes. Will send out in a few days.

Thanks.

-- 
tejun
