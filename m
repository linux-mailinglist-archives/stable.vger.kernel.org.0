Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64562D6F5C
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 05:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbgLKEf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 23:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgLKEf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 23:35:27 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3450C0613CF;
        Thu, 10 Dec 2020 20:34:46 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id bj5so3977963plb.4;
        Thu, 10 Dec 2020 20:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aTXqGAx4LIBP/b47PLWDasM5O37a5Kvxs3eOBQFay84=;
        b=qCbIOJZDlolJnHOiOWdS6s5Yotpb3dRkMkaALZ1h/7fxyZExM4jHo+IR0NUqK7X8kw
         Yeg0JeGaAQairX+pmJSlTA+vvZFtfoqN57hDD2b941ZhYEbtJ74p8c3vtyhu93NVANl+
         xjC386HeaDXCwpOllhNEEEWnFoTXMpAONdLyUDc50dXKQM/YH/hxjdTFow9FFWuhyGuO
         5/Bw6gMiMpbJ95tTWv4TfyVO1PRW1d6JZoVmcKdiXQuCwhJrImHBmzg2HBvdTj1Ay3Uc
         FjXPMLyDGd5nblJ8eaN3c490JLGyFk5t6Vg33hxyhi2B9UWhO7Gf1YwHzBYLqM4oNY+1
         qSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aTXqGAx4LIBP/b47PLWDasM5O37a5Kvxs3eOBQFay84=;
        b=ZoItiQGYmBC1qaqWo/v+YAV+W7PFuQLhnLSN8XFTiy4vxNKKgKeHJHQ09HukwEMGYo
         0qbNvxrHJ4j64KHuNZOLWToN7h83Yya5iVJWIaN8b2zrr6+4QDCglSlt2Z9V3J6iEu8d
         AhLZJzxK6tc8hIDUTVv86yiuH0z7W+AzI06DkET2KLoyExbT6iC7xV7COK3ZoH4YCfvE
         UYKtYjpjT9/xzQLJWz6n2tNAWWizqgbDUEVnDvpA2LWw+fAz6TUgkXAodeM2LubONiOL
         nPbSN06nsobiQAotFXVaKL87zHOECLM0dTSL3GyO4HNBTbeZJ4iH2gWap0/bjnKblz4S
         NOqA==
X-Gm-Message-State: AOAM532xty35rVsOE+BJFOKADylQBBIr0Y8mQxfmCCwta+LYjlrZF3tO
        44berWrAvPGuVlHtrGk/CfwloRErw6g=
X-Google-Smtp-Source: ABdhPJwbXxDhT8PeCjCU4hCG1GNiIQ4w4pyjo0a2kZkc8O72r0DsPioVk9Cp/6wXjKcA8g+Z8r89tw==
X-Received: by 2002:a17:90a:4817:: with SMTP id a23mr11258295pjh.16.1607661286283;
        Thu, 10 Dec 2020 20:34:46 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:a6ae:11ff:fe11:4b46])
        by smtp.gmail.com with ESMTPSA id l66sm7909781pgl.24.2020.12.10.20.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 20:34:45 -0800 (PST)
Date:   Fri, 11 Dec 2020 13:34:42 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Suleiman Souhlal <suleiman@google.com>,
        linux-fscrypt@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [stable] ext4 fscrypt_get_encryption_info() circular locking
 dependency
Message-ID: <20201211043442.GG1667627@google.com>
References: <20201211033657.GE1667627@google.com>
 <X9LsDPsXdLNv0+va@sol.localdomain>
 <20201211040807.GF1667627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211040807.GF1667627@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/12/11 13:08), Sergey Senozhatsky wrote:
> > 
> > How interested are you in having this fixed?  Did you encounter an actual
> > deadlock or just the lockdep report?
>

Got one more. fscrypt_get_encryption_info() again, but from ext4_lookup().

[  162.840909] kswapd0/80 is trying to acquire lock:                                                        
[  162.840912] 0000000078ea628f (jbd2_handle){++++}, at: start_this_handle+0x1f9/0x859                      
[  162.840919]                                                                                              
               but task is already holding lock:                                                            
[  162.840922] 00000000314ed5a0 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x2f                       
[  162.840929]                                                                                              
               which lock already depends on the new lock.                                                  
                                                                                                            
[  162.840932]                                                                                              
               the existing dependency chain (in reverse order) is:                                         
[  162.840934]                                                                                              
               -> #2 (fs_reclaim){+.+.}:                                                                    
[  162.840940]        kmem_cache_alloc_trace+0x44/0x28b
[  162.840944]        mempool_create_node+0x46/0x92                                                         
[  162.840947]        fscrypt_initialize+0xa0/0xbf                                                          
[  162.840950]        fscrypt_get_encryption_info+0xa4/0x774
[  162.840953]        fscrypt_setup_filename+0x99/0x2d1
[  162.840956]        __fscrypt_prepare_lookup+0x25/0x6b
[  162.840960]        ext4_lookup+0x1b2/0x323                                                               
[  162.840963]        path_openat+0x9a5/0x156d                                                              
[  162.840966]        do_filp_open+0x97/0x13e                                                               
[  162.840970]        do_sys_open+0x128/0x3a3                                                               
[  162.840973]        do_syscall_64+0x6f/0x22a                                                              
[  162.840977]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  162.840979]                                                                                              
               -> #1 (fscrypt_init_mutex){+.+.}:                                                            
[  162.840983]        mutex_lock_nested+0x20/0x26                                                           
[  162.840986]        fscrypt_initialize+0x20/0xbf                                                          
[  162.840989]        fscrypt_get_encryption_info+0xa4/0x774
[  162.840992]        fscrypt_inherit_context+0xbe/0xe6
[  162.840995]        __ext4_new_inode+0x11ee/0x1631                                                        
[  162.840999]        ext4_mkdir+0x112/0x416                                                                
[  162.841002]        vfs_mkdir2+0x135/0x1c6                                                                
[  162.841004]        do_mkdirat+0xc3/0x138                                                                 
[  162.841007]        do_syscall_64+0x6f/0x22a                                                              
[  162.841011]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  162.841012]                                                                                              
               -> #0 (jbd2_handle){++++}:                                                                   
[  162.841017]        start_this_handle+0x21c/0x859                                                         
[  162.841019]        jbd2__journal_start+0xa2/0x282                                                        
[  162.841022]        ext4_release_dquot+0x58/0x93                                                          
[  162.841025]        dqput+0x196/0x1ec                                                                     
[  162.841028]        __dquot_drop+0x8d/0xb2                                                                
[  162.841032]        ext4_clear_inode+0x22/0x8c                                                            
[  162.841035]        ext4_evict_inode+0x127/0x662                                                          
[  162.841038]        evict+0xc0/0x241                                                                      
[  162.841041]        dispose_list+0x36/0x54                                                                
[  162.841045]        prune_icache_sb+0x56/0x76                                                             
[  162.841048]        super_cache_scan+0x13a/0x19c                                                          
[  162.841051]        shrink_slab+0x39a/0x572                                                               
[  162.841054]        shrink_node+0x3f8/0x63b                                                               
[  162.841056]        balance_pgdat+0x1bd/0x326                                                             
[  162.841059]        kswapd+0x2ad/0x510                                                                    
[  162.841062]        kthread+0x14d/0x155                                                                   
[  162.841066]        ret_from_fork+0x24/0x50                                                               
[  162.841068]                                                                                              
               other info that might help us debug this:

[  162.841070] Chain exists of:                                                                             
                 jbd2_handle --> fscrypt_init_mutex --> fs_reclaim

[  162.841075]  Possible unsafe locking scenario:                                                           

[  162.841077]        CPU0                    CPU1                                                          
[  162.841079]        ----                    ----                                                          
[  162.841081]   lock(fs_reclaim);                                                                          
[  162.841084]                                lock(fscrypt_init_mutex);
[  162.841086]                                lock(fs_reclaim);
[  162.841089]   lock(jbd2_handle);                                                                         
[  162.841091]                                                                                              
                *** DEADLOCK ***                                                                            

[  162.841095] 3 locks held by kswapd0/80:                                                                  
[  162.841097]  #0: 00000000314ed5a0 (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x5/0x2f
[  162.841102]  #1: 00000000be0d2066 (shrinker_rwsem){++++}, at: shrink_slab+0x3b/0x572
[  162.841107]  #2: 000000007c23fde5 (&type->s_umount_key#45){++++}, at: trylock_super+0x1b/0x47
[  162.841111]                                                                                              
               stack backtrace:                                                                             
[  162.841115] CPU: 0 PID: 80 Comm: kswapd0 Not tainted 4.19.161 #44
[  162.841121] Call Trace:                                                                                  
[  162.841127]  dump_stack+0xbd/0x11d                                                                       
[  162.841131]  ? print_circular_bug+0x2c1/0x2d4                                                            
[  162.841135]  __lock_acquire+0x1977/0x1981                                                                
[  162.841139]  ? start_this_handle+0x1f9/0x859                                                             
[  162.841142]  lock_acquire+0x1b7/0x202                                                                    
[  162.841145]  ? start_this_handle+0x1f9/0x859                                                             
[  162.841149]  start_this_handle+0x21c/0x859                                                               
[  162.841151]  ? start_this_handle+0x1f9/0x859                                                             
[  162.841155]  ? kmem_cache_alloc+0x1d1/0x27d                                                              
[  162.841159]  jbd2__journal_start+0xa2/0x282                                                              
[  162.841162]  ? __ext4_journal_start_sb+0x10b/0x208                                                       
[  162.841165]  ext4_release_dquot+0x58/0x93                                                                
[  162.841169]  dqput+0x196/0x1ec                                                                           
[  162.841172]  __dquot_drop+0x8d/0xb2                                                                      
[  162.841175]  ? dquot_drop+0x27/0x43                                                                      
[  162.841179]  ext4_clear_inode+0x22/0x8c                                                                  
[  162.841183]  ext4_evict_inode+0x127/0x662
[  162.841187]  evict+0xc0/0x241
[  162.841191]  dispose_list+0x36/0x54
[  162.841195]  prune_icache_sb+0x56/0x76
[  162.841198]  super_cache_scan+0x13a/0x19c
[  162.841202]  shrink_slab+0x39a/0x572
[  162.841206]  shrink_node+0x3f8/0x63b
[  162.841212]  balance_pgdat+0x1bd/0x326
[  162.841217]  kswapd+0x2ad/0x510
[  162.841223]  ? init_wait_entry+0x2e/0x2e
[  162.841227]  kthread+0x14d/0x155
[  162.841230]  ? wakeup_kswapd+0x20d/0x20d
[  162.841233]  ? kthread_destroy_worker+0x62/0x62
[  162.841237]  ret_from_fork+0x24/0x50

	-ss
