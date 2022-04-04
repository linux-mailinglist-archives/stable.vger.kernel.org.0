Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7A4F12F5
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 12:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356944AbiDDKTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 06:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356925AbiDDKTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 06:19:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8F1C3C716
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 03:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649067471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5AC28C8MkjKe0cn5E/SYMPX5kQ/uAt9l6ElEd2BSqs=;
        b=JhD1mAx/ZqfT+X5GQGWroBmAXqjN2tnOvEo1ZnfXBBX5u4Um8/MveG1PfLxAZtJUKQUT3o
        rl9EkXZFJkb7H6q4LTgwxVBmCavtH7NJM6E0/GBWI0sOx72gTkw00K5fNlVg1W5yvaYgt+
        a065/J20KzbS7bZpHDkys+KWChYgm0A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-vFsdlEwjO9KrUT6yb7rreA-1; Mon, 04 Apr 2022 06:17:50 -0400
X-MC-Unique: vFsdlEwjO9KrUT6yb7rreA-1
Received: by mail-wr1-f72.google.com with SMTP id e4-20020adfa444000000b002060b7347f8so683513wra.6
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 03:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=l5AC28C8MkjKe0cn5E/SYMPX5kQ/uAt9l6ElEd2BSqs=;
        b=1tS/75AP78KBpnQ0eeGc5x+OJB4mOZlx/U1bUAPFuQzFqjC5ABvl5HQvSsDElkaOyg
         VXSJf8WDvJuwAW0ckfcf/lMPRz86+zcoIhg8fP1hy9VbeUJPtOz9rXnjOCXAJoytP44Q
         Ps46a9J2upmFr2wufVWjLOeRThdaLGYUo2ZDdEvOaDulN0liGLDU56Vcy27VhF0iB004
         DjeWaUB6Pa7aTa/Wp3kEmVY8mJ1XrlqkbXaArVeFiKrzygKyBSBCAe8qkDcHeINF2mFx
         Ncgm+sYAiBBDYfAtr7cN4nZMqafRD1FaC9QLkHNS6QjpsbvFJRnRI1cXc465fimNCLVG
         DXRA==
X-Gm-Message-State: AOAM533ooAB1yqkjNgXE27lpG6l2bMJ89/xPtlz69HM5WOFjEXCZaC+9
        vMc8H3MU8nlO7SGInnfTL+cWR7kFPsLzcYt2uhZJV3/zFo5GWbd2xQqDx03DL1G98vamMPG2isN
        aW6j/SQiTGIgD2l7S
X-Received: by 2002:a5d:4f8a:0:b0:205:8ff4:c301 with SMTP id d10-20020a5d4f8a000000b002058ff4c301mr16497258wru.41.1649067468887;
        Mon, 04 Apr 2022 03:17:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHWfNk3Fkg1pc1nY9/gwDlD9GKny6u/ozx8cdAFjot93W+aoG/Xsca5he1n6Fl3qN6CtYFCw==
X-Received: by 2002:a5d:4f8a:0:b0:205:8ff4:c301 with SMTP id d10-20020a5d4f8a000000b002058ff4c301mr16497239wru.41.1649067468612;
        Mon, 04 Apr 2022 03:17:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:4100:c220:ede7:17d4:6ff4? (p200300cbc7044100c220ede717d46ff4.dip0.t-ipconnect.de. [2003:cb:c704:4100:c220:ede7:17d4:6ff4])
        by smtp.gmail.com with ESMTPSA id t9-20020a05600c198900b0038cb8b38f9fsm17326599wmq.21.2022.04.04.03.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 03:17:48 -0700 (PDT)
Message-ID: <5a220426-6b83-6a0e-5af0-ee4c76e72c79@redhat.com>
Date:   Mon, 4 Apr 2022 12:17:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: FAILED: patch "[PATCH] proc/vmcore: fix possible deadlock on
 concurrent mmap and" failed to apply to 5.16-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        bhe@redhat.com, boqun.feng@gmail.com, dyoung@redhat.com,
        josh@joshtriplett.org, paulmck@kernel.org, peterz@infradead.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vgoyal@redhat.com
References: <164889941824213@kroah.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <164889941824213@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.04.22 13:36, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

I don't think we need that particular patch in -stable. The deadlock
shouldn't really happen in practice (concurrent addition/removal of a
callback doesn't really happen in a kdump anvironment). Thanks.

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 5039b170369d22613ebc07e81410891f52280a45 Mon Sep 17 00:00:00 2001
> From: David Hildenbrand <david@redhat.com>
> Date: Wed, 23 Mar 2022 16:05:23 -0700
> Subject: [PATCH] proc/vmcore: fix possible deadlock on concurrent mmap and
>  read
> 
> Lockdep noticed that there is chance for a deadlock if we have concurrent
> mmap, concurrent read, and the addition/removal of a callback.
> 
> As nicely explained by Boqun:
>  "Lockdep warned about the above sequences because rw_semaphore is a
>   fair read-write lock, and the following can cause a deadlock:
> 
> 	TASK 1			TASK 2		TASK 3
> 	======			======		======
> 	down_write(mmap_lock);
> 				down_read(vmcore_cb_rwsem)
> 						down_write(vmcore_cb_rwsem); // blocked
> 	down_read(vmcore_cb_rwsem); // cannot get the lock because of the fairness
> 				down_read(mmap_lock); // blocked
> 
>   IOW, a reader can block another read if there is a writer queued by
>   the second reader and the lock is fair"
> 
> To fix this, convert to srcu to make this deadlock impossible.  We need
> srcu as our callbacks can sleep.  With this change, I cannot trigger any
> lockdep warnings.
> 
>     ======================================================
>     WARNING: possible circular locking dependency detected
>     5.17.0-0.rc0.20220117git0c947b893d69.68.test.fc36.x86_64 #1 Not tainted
>     ------------------------------------------------------
>     makedumpfile/542 is trying to acquire lock:
>     ffffffff832d2eb8 (vmcore_cb_rwsem){.+.+}-{3:3}, at: mmap_vmcore+0x340/0x580
> 
>     but task is already holding lock:
>     ffff8880af226438 (&mm->mmap_lock#2){++++}-{3:3}, at: vm_mmap_pgoff+0x84/0x150
> 
>     which lock already depends on the new lock.
> 
>     the existing dependency chain (in reverse order) is:
> 
>     -> #1 (&mm->mmap_lock#2){++++}-{3:3}:
>            lock_acquire+0xc3/0x1a0
>            __might_fault+0x4e/0x70
>            _copy_to_user+0x1f/0x90
>            __copy_oldmem_page+0x72/0xc0
>            read_from_oldmem+0x77/0x1e0
>            read_vmcore+0x2c2/0x310
>            proc_reg_read+0x47/0xa0
>            vfs_read+0x101/0x340
>            __x64_sys_pread64+0x5d/0xa0
>            do_syscall_64+0x43/0x90
>            entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>     -> #0 (vmcore_cb_rwsem){.+.+}-{3:3}:
>            validate_chain+0x9f4/0x2670
>            __lock_acquire+0x8f7/0xbc0
>            lock_acquire+0xc3/0x1a0
>            down_read+0x4a/0x140
>            mmap_vmcore+0x340/0x580
>            proc_reg_mmap+0x3e/0x90
>            mmap_region+0x504/0x880
>            do_mmap+0x38a/0x520
>            vm_mmap_pgoff+0xc1/0x150
>            ksys_mmap_pgoff+0x178/0x200
>            do_syscall_64+0x43/0x90
>            entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
>     other info that might help us debug this:
> 
>      Possible unsafe locking scenario:
> 
>            CPU0                    CPU1
>            ----                    ----
>       lock(&mm->mmap_lock#2);
>                                    lock(vmcore_cb_rwsem);
>                                    lock(&mm->mmap_lock#2);
>       lock(vmcore_cb_rwsem);
> 
>      *** DEADLOCK ***
> 
>     1 lock held by makedumpfile/542:
>      #0: ffff8880af226438 (&mm->mmap_lock#2){++++}-{3:3}, at: vm_mmap_pgoff+0x84/0x150
> 
>     stack backtrace:
>     CPU: 0 PID: 542 Comm: makedumpfile Not tainted 5.17.0-0.rc0.20220117git0c947b893d69.68.test.fc36.x86_64 #1
>     Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>     Call Trace:
>      __lock_acquire+0x8f7/0xbc0
>      lock_acquire+0xc3/0x1a0
>      down_read+0x4a/0x140
>      mmap_vmcore+0x340/0x580
>      proc_reg_mmap+0x3e/0x90
>      mmap_region+0x504/0x880
>      do_mmap+0x38a/0x520
>      vm_mmap_pgoff+0xc1/0x150
>      ksys_mmap_pgoff+0x178/0x200
>      do_syscall_64+0x43/0x90
> 
> Link: https://lkml.kernel.org/r/20220119193417.100385-1-david@redhat.com
> Fixes: cc5f2704c934 ("proc/vmcore: convert oldmem_pfn_is_ram callback to more generic vmcore callbacks")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Reported-by: Baoquan He <bhe@redhat.com>
> Acked-by: Baoquan He <bhe@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> index 702754dd1daf..edeb01dfe05d 100644
> --- a/fs/proc/vmcore.c
> +++ b/fs/proc/vmcore.c
> @@ -62,7 +62,8 @@ core_param(novmcoredd, vmcoredd_disabled, bool, 0);
>  /* Device Dump Size */
>  static size_t vmcoredd_orig_sz;
>  
> -static DECLARE_RWSEM(vmcore_cb_rwsem);
> +static DEFINE_SPINLOCK(vmcore_cb_lock);
> +DEFINE_STATIC_SRCU(vmcore_cb_srcu);
>  /* List of registered vmcore callbacks. */
>  static LIST_HEAD(vmcore_cb_list);
>  /* Whether the vmcore has been opened once. */
> @@ -70,8 +71,8 @@ static bool vmcore_opened;
>  
>  void register_vmcore_cb(struct vmcore_cb *cb)
>  {
> -	down_write(&vmcore_cb_rwsem);
>  	INIT_LIST_HEAD(&cb->next);
> +	spin_lock(&vmcore_cb_lock);
>  	list_add_tail(&cb->next, &vmcore_cb_list);
>  	/*
>  	 * Registering a vmcore callback after the vmcore was opened is
> @@ -79,14 +80,14 @@ void register_vmcore_cb(struct vmcore_cb *cb)
>  	 */
>  	if (vmcore_opened)
>  		pr_warn_once("Unexpected vmcore callback registration\n");
> -	up_write(&vmcore_cb_rwsem);
> +	spin_unlock(&vmcore_cb_lock);
>  }
>  EXPORT_SYMBOL_GPL(register_vmcore_cb);
>  
>  void unregister_vmcore_cb(struct vmcore_cb *cb)
>  {
> -	down_write(&vmcore_cb_rwsem);
> -	list_del(&cb->next);
> +	spin_lock(&vmcore_cb_lock);
> +	list_del_rcu(&cb->next);
>  	/*
>  	 * Unregistering a vmcore callback after the vmcore was opened is
>  	 * very unusual (e.g., forced driver removal), but we cannot stop
> @@ -94,7 +95,9 @@ void unregister_vmcore_cb(struct vmcore_cb *cb)
>  	 */
>  	if (vmcore_opened)
>  		pr_warn_once("Unexpected vmcore callback unregistration\n");
> -	up_write(&vmcore_cb_rwsem);
> +	spin_unlock(&vmcore_cb_lock);
> +
> +	synchronize_srcu(&vmcore_cb_srcu);
>  }
>  EXPORT_SYMBOL_GPL(unregister_vmcore_cb);
>  
> @@ -103,9 +106,8 @@ static bool pfn_is_ram(unsigned long pfn)
>  	struct vmcore_cb *cb;
>  	bool ret = true;
>  
> -	lockdep_assert_held_read(&vmcore_cb_rwsem);
> -
> -	list_for_each_entry(cb, &vmcore_cb_list, next) {
> +	list_for_each_entry_srcu(cb, &vmcore_cb_list, next,
> +				 srcu_read_lock_held(&vmcore_cb_srcu)) {
>  		if (unlikely(!cb->pfn_is_ram))
>  			continue;
>  		ret = cb->pfn_is_ram(cb, pfn);
> @@ -118,9 +120,9 @@ static bool pfn_is_ram(unsigned long pfn)
>  
>  static int open_vmcore(struct inode *inode, struct file *file)
>  {
> -	down_read(&vmcore_cb_rwsem);
> +	spin_lock(&vmcore_cb_lock);
>  	vmcore_opened = true;
> -	up_read(&vmcore_cb_rwsem);
> +	spin_unlock(&vmcore_cb_lock);
>  
>  	return 0;
>  }
> @@ -133,6 +135,7 @@ ssize_t read_from_oldmem(char *buf, size_t count,
>  	unsigned long pfn, offset;
>  	size_t nr_bytes;
>  	ssize_t read = 0, tmp;
> +	int idx;
>  
>  	if (!count)
>  		return 0;
> @@ -140,7 +143,7 @@ ssize_t read_from_oldmem(char *buf, size_t count,
>  	offset = (unsigned long)(*ppos % PAGE_SIZE);
>  	pfn = (unsigned long)(*ppos / PAGE_SIZE);
>  
> -	down_read(&vmcore_cb_rwsem);
> +	idx = srcu_read_lock(&vmcore_cb_srcu);
>  	do {
>  		if (count > (PAGE_SIZE - offset))
>  			nr_bytes = PAGE_SIZE - offset;
> @@ -165,7 +168,7 @@ ssize_t read_from_oldmem(char *buf, size_t count,
>  						       offset, userbuf);
>  		}
>  		if (tmp < 0) {
> -			up_read(&vmcore_cb_rwsem);
> +			srcu_read_unlock(&vmcore_cb_srcu, idx);
>  			return tmp;
>  		}
>  
> @@ -176,8 +179,8 @@ ssize_t read_from_oldmem(char *buf, size_t count,
>  		++pfn;
>  		offset = 0;
>  	} while (count);
> +	srcu_read_unlock(&vmcore_cb_srcu, idx);
>  
> -	up_read(&vmcore_cb_rwsem);
>  	return read;
>  }
>  
> @@ -568,18 +571,18 @@ static int vmcore_remap_oldmem_pfn(struct vm_area_struct *vma,
>  			    unsigned long from, unsigned long pfn,
>  			    unsigned long size, pgprot_t prot)
>  {
> -	int ret;
> +	int ret, idx;
>  
>  	/*
> -	 * Check if oldmem_pfn_is_ram was registered to avoid
> -	 * looping over all pages without a reason.
> +	 * Check if a callback was registered to avoid looping over all
> +	 * pages without a reason.
>  	 */
> -	down_read(&vmcore_cb_rwsem);
> +	idx = srcu_read_lock(&vmcore_cb_srcu);
>  	if (!list_empty(&vmcore_cb_list))
>  		ret = remap_oldmem_pfn_checked(vma, from, pfn, size, prot);
>  	else
>  		ret = remap_oldmem_pfn_range(vma, from, pfn, size, prot);
> -	up_read(&vmcore_cb_rwsem);
> +	srcu_read_unlock(&vmcore_cb_srcu, idx);
>  	return ret;
>  }
>  
> 


-- 
Thanks,

David / dhildenb

