Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54BB139AEA
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 21:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgAMUoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 15:44:38 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37662 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgAMUoh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 15:44:37 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so4801717pjb.2
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 12:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LiFsMtdAAL8u3Mj0AGyqGHgFmKeTnlkzoFp9HCe1YXQ=;
        b=AsP9QdUZWbSz3XbZMOIu2GyZ32IclKNg5YZkJfK4IhM7dZ5nj9oUFt0ocelbNFbEgs
         Rb3LMq8142gvvYHw10tFiftycAD0/U0Aik2EKSXROHOqWl1Y16dDljyyoFlkwi+g/+kb
         crfuqLwmmeJZ6XxitBAmg7h0d5w7xuOgQ3glBpX41isDyKIJWOMScpQtYx752vGztC/G
         phwgIj4tv9oWtNAB/Y9E9q958Morc0O+KuC8ZRawsHwP+xRIKe5Gnb/MUYgDMbDaZFHt
         IoBrT1LRhIliK6yT7rM/tItcOKByJlxeoDqCLbS3OJc1YpYxaecvSREwPRtanRZ8Q7fv
         qOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LiFsMtdAAL8u3Mj0AGyqGHgFmKeTnlkzoFp9HCe1YXQ=;
        b=XYjyHNh7KUj/YnK+ccIqdlMTEQQLgaLrALqpouPsF65MF3sYIPt/W0PNGKSy7AUHzK
         br8E9nBJuL4tvZIRcw1KM9d88qmbHitgpzYxv+Yu35F66puHs2D++55wfbdU2QNTOXgr
         wOkqgi0PCwK/9iWR8Ex+uR5uVfbR6HyOFOpPYNrXRTkp8UfKKb0IJhIupwrT2N+tgaMt
         yiYVxCfaNc+1ndNoczaJOALEmectQKY4QplUhVC/sg6SYbK6TdSWcDoHlHAWb6ts4HCk
         q5dMPUP1yqQ4a5lkEc/lQ53S5ZY5e6vl2vkZf+F5nhJ+yPun4SKtAOTyvcLsh7GQf4wL
         SvRQ==
X-Gm-Message-State: APjAAAUDvpadsOvPv1+7nN/2KNa/S1t8uIXoB2y/1eys7iuB88Aqdv7C
        Sf3KUO6NRTfXS9eWf1X4vILN4pemNlWiNQ==
X-Google-Smtp-Source: APXvYqxB9FPndISQYGvk4yGPRO+2+5uGOYS+K/yYRUaE8HA1sUXn4OuH/5WveFLl5zAGFMii65AIYg==
X-Received: by 2002:a17:902:74cb:: with SMTP id f11mr15497395plt.139.1578948276493;
        Mon, 13 Jan 2020 12:44:36 -0800 (PST)
Received: from ?IPv6:2620:10d:c082:1055:14f9:7e4a:9f6f:4d05? ([2620:10d:c090:200::3:ee39])
        by smtp.gmail.com with ESMTPSA id b4sm15557205pfd.18.2020.01.13.12.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 12:44:35 -0800 (PST)
Subject: Re: [PATCH] btrfs: relocation: fix reloc_root lifespan and access
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, nborisov@suse.com,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        stable@vger.kernel.org
References: <20200113191617.3542-1-dsterba@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <c40269a4-d914-a564-9293-3f92cfa0d290@toxicpanda.com>
Date:   Mon, 13 Jan 2020 12:44:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200113191617.3542-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/13/20 11:16 AM, David Sterba wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> This is what I'm going to commit, but as this has a long discussion
> behind I'm sending it to the mailinglist.
> 
> * there are 2 helpers to avoid using raw barriers in the tests where there
>    are at least 2 places
> * each barrier is commented
> * subject and changelog have been updated to reflect the changes
> 
> https://lore.kernel.org/linux-btrfs/20200108051200.8909-1-wqu@suse.com/
> 
> ---
> 
> [BUG]
> There are several different KASAN reports for balance + snapshot
> workloads.  Involved call paths include:
> 
>     should_ignore_root+0x54/0xb0 [btrfs]
>     build_backref_tree+0x11af/0x2280 [btrfs]
>     relocate_tree_blocks+0x391/0xb80 [btrfs]
>     relocate_block_group+0x3e5/0xa00 [btrfs]
>     btrfs_relocate_block_group+0x240/0x4d0 [btrfs]
>     btrfs_relocate_chunk+0x53/0xf0 [btrfs]
>     btrfs_balance+0xc91/0x1840 [btrfs]
>     btrfs_ioctl_balance+0x416/0x4e0 [btrfs]
>     btrfs_ioctl+0x8af/0x3e60 [btrfs]
>     do_vfs_ioctl+0x831/0xb10
> 
>     create_reloc_root+0x9f/0x460 [btrfs]
>     btrfs_reloc_post_snapshot+0xff/0x6c0 [btrfs]
>     create_pending_snapshot+0xa9b/0x15f0 [btrfs]
>     create_pending_snapshots+0x111/0x140 [btrfs]
>     btrfs_commit_transaction+0x7a6/0x1360 [btrfs]
>     btrfs_mksubvol+0x915/0x960 [btrfs]
>     btrfs_ioctl_snap_create_transid+0x1d5/0x1e0 [btrfs]
>     btrfs_ioctl_snap_create_v2+0x1d3/0x270 [btrfs]
>     btrfs_ioctl+0x241b/0x3e60 [btrfs]
>     do_vfs_ioctl+0x831/0xb10
> 
>     btrfs_reloc_pre_snapshot+0x85/0xc0 [btrfs]
>     create_pending_snapshot+0x209/0x15f0 [btrfs]
>     create_pending_snapshots+0x111/0x140 [btrfs]
>     btrfs_commit_transaction+0x7a6/0x1360 [btrfs]
>     btrfs_mksubvol+0x915/0x960 [btrfs]
>     btrfs_ioctl_snap_create_transid+0x1d5/0x1e0 [btrfs]
>     btrfs_ioctl_snap_create_v2+0x1d3/0x270 [btrfs]
>     btrfs_ioctl+0x241b/0x3e60 [btrfs]
>     do_vfs_ioctl+0x831/0xb10
> 
> [CAUSE]
> All these call sites are only relying on root->reloc_root, which can
> undergo btrfs_drop_snapshot(), and since we don't have real refcount
> based protection to reloc roots, we can reach already dropped reloc
> root, triggering KASAN.
> 
> [FIX]
> To avoid such access to unstable root->reloc_root, we should check
> BTRFS_ROOT_DEAD_RELOC_TREE bit first.
> 
> This patch introduces wrappers that provide the correct way to check the
> bit with memory barriers protection.
> 
> Most callers don't distinguish merged reloc tree and no reloc tree.  The
> only exception is should_ignore_root(), as merged reloc tree can be
> ignored, while no reloc tree shouldn't.
> 
> [CRITICAL SECTION ANALYSIS]
> Although test_bit()/set_bit()/clear_bit() doesn't imply a barrier, the
> DEAD_RELOC_TREE bit has extra help from transaction as a higher level
> barrier, the lifespan of root::reloc_root and DEAD_RELOC_TREE bit are:
> 
> 	NULL: reloc_root is NULL	PTR: reloc_root is not NULL
> 	0: DEAD_RELOC_ROOT bit not set	DEAD: DEAD_RELOC_ROOT bit set
> 
> 	(NULL, 0)    Initial state		 __
> 	  |					 /\ Section A
>          btrfs_init_reloc_root()			 \/
> 	  |				 	 __
> 	(PTR, 0)     reloc_root initialized      /\
>            |					 |
> 	btrfs_update_reloc_root()		 |  Section B
>            |					 |
> 	(PTR, DEAD)  reloc_root has been merged  \/
>            |					 __
> 	=== btrfs_commit_transaction() ====================
> 	  |					 /\
> 	clean_dirty_subvols()			 |
> 	  |					 |  Section C
> 	(NULL, DEAD) reloc_root cleanup starts   \/
>            |					 __
> 	btrfs_drop_snapshot()			 /\
> 	  |					 |  Section D
> 	(NULL, 0)    Back to initial state	 \/
> 
> Every have_reloc_root() or test_bit(DEAD_RELOC_ROOT) caller holds
> transaction handle, so none of such caller can cross transaction boundary.
> 
> In Section A, every caller just found no DEAD bit, and grab reloc_root.
> 
> In the cross section A-B, caller may get no DEAD bit, but since reloc_root
> is still completely valid thus accessing reloc_root is completely safe.
> 
> No test_bit() caller can cross the boundary of Section B and Section C.
> 
> In Section C, every caller found the DEAD bit, so no one will access
> reloc_root.
> 
> In the cross section C-D, either caller gets the DEAD bit set, avoiding
> access reloc_root no matter if it's safe or not.  Or caller get the DEAD
> bit cleared, then access reloc_root, which is already NULL, nothing will
> be wrong.
> 
> The memory write barriers are between the reloc_root updates and bit
> set/clear, the pairing read side is before test_bit.
> 
> Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
> CC: stable@vger.kernel.org # 5.4+
> Suggested-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> [ barriers ]
> Signed-off-by: David Sterba <dsterba@suse.com>

Let's just get this fixed, the root refcounting stuff will solve this so we just 
need something for now.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
