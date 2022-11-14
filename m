Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BAA62819A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbiKNNrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbiKNNra (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB4F24087
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668433591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1BcN/QO1Azbk1K0nDSLQnjoAEd5nt0uvBoLhgjnJtw=;
        b=Ov8pbmaYEpSbsz/8bgmxQN4JldfLAGEYYXstUFepfux6Uxd3y2hJMUHsvLowm0SqQcBE/Y
        njCyCmFQgnJsDPYELgSIPT8Qk3FKC8gYIQCVRmu1uVRigZFiz6FITJZHdNg6aMg7fHcePa
        SkKch3v/TTZO3unS2cM6wsA9pUk1la4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-48-DJEc1KCPNaGAM2WawOj5yg-1; Mon, 14 Nov 2022 08:46:30 -0500
X-MC-Unique: DJEc1KCPNaGAM2WawOj5yg-1
Received: by mail-pg1-f199.google.com with SMTP id 138-20020a630290000000b004708e8a8dcfso5848809pgc.11
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1BcN/QO1Azbk1K0nDSLQnjoAEd5nt0uvBoLhgjnJtw=;
        b=UkuOGKmJg0ZfXaZcew7ZnH1MboUHR2U05AAT9mT0ioqLlpwUBUvCMqLzzqCLDQdmxm
         +kfNZVui1HHa5yFatcP7l16w9dAXwbIy9/RpyYxtR7Jhr6b0B8iJRFRmQjflgksyUFnq
         JAuL4xhaJWB1Eqv140mayTQSqbdQl62NtiHwFK/O4u9Vo35nH7lmCXfx7+seEYnMPE+v
         tTksAVqHLQhG1oYzY99kcvHIubsoPjp1bmflReXWqyei0/SF6GMY33KHtPB5xR0PtInT
         jeDwVaxr4Cn+N4+CxVRjmbT7KgE3QB/2icsQABBrlyKCM4fkonZyTtkRSsTE7YFOU+YJ
         JCfg==
X-Gm-Message-State: ANoB5pk4PyCLX8Q1E3hbmOGQG0z67LaUovWpMjkNXNh3zyz/iGMIBOKQ
        W1lIQEL55XtVZ7siPNyv62p6XRKjdKyytCQ7cX7V4yv8wNEy4GvoJanthZaal34HrX+1ZCJ6g1a
        O4yXOZl8L6VudMNafdZGu8ekFWUlIwI7+r4YiWq69UhXHNSqKBPltHfpnQnV3CnUbMA==
X-Received: by 2002:a17:90b:3c8f:b0:212:9b3f:dee5 with SMTP id pv15-20020a17090b3c8f00b002129b3fdee5mr13647448pjb.62.1668433589124;
        Mon, 14 Nov 2022 05:46:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6ynxQTk5xe3X2zCMgFBN2EARpkH5K8+lbjAioDd32BscJZFicJ8pwOxc68lDhHNmzsMO+UJg==
X-Received: by 2002:a17:90b:3c8f:b0:212:9b3f:dee5 with SMTP id pv15-20020a17090b3c8f00b002129b3fdee5mr13647417pjb.62.1668433588622;
        Mon, 14 Nov 2022 05:46:28 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b13-20020aa78ecd000000b0056cee8af3a6sm6463020pfr.54.2022.11.14.05.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 05:46:28 -0800 (PST)
Subject: Re: [PATCH 2/2 v2] ceph: use a xarray to record all the opened files
 for each inode
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, viro@zeniv.linux.org.uk
Cc:     lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221114051901.15371-1-xiubli@redhat.com>
 <20221114051901.15371-3-xiubli@redhat.com>
 <46a1398be032ee6d06aef7df5e336b6ce2ba8f53.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <99686926-542d-d558-ce22-e4d5c883b838@redhat.com>
Date:   Mon, 14 Nov 2022 21:46:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <46a1398be032ee6d06aef7df5e336b6ce2ba8f53.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/11/2022 21:39, Jeff Layton wrote:
> On Mon, 2022-11-14 at 13:19 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When releasing the file locks the fl->fl_file memory could be
>> already released by another thread in filp_close(), so we couldn't
>> depend on fl->fl_file to get the inode. Just use a xarray to record
>> the opened files for each inode.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57986
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c  |  9 +++++++++
>>   fs/ceph/inode.c |  4 ++++
>>   fs/ceph/locks.c | 17 ++++++++++++++++-
>>   fs/ceph/super.h |  4 ++++
>>   4 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 85afcbbb5648..cb4a9c52df27 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -231,6 +231,13 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>>   			fi->flags |= CEPH_F_SYNC;
>>   
>>   		file->private_data = fi;
>> +
>> +		ret = xa_insert(&ci->i_opened_files, (unsigned long)file,
>> +				CEPH_FILP_AVAILABLE, GFP_KERNEL);
>> +		if (ret) {
>> +			kmem_cache_free(ceph_file_cachep, fi);
>> +			return ret;
>> +		}
>>   	}
>>   
>>   	ceph_get_fmode(ci, fmode, 1);
>> @@ -932,6 +939,8 @@ int ceph_release(struct inode *inode, struct file *file)
>>   		dout("release inode %p regular file %p\n", inode, file);
>>   		WARN_ON(!list_empty(&fi->rw_contexts));
>>   
>> +		xa_erase(&ci->i_opened_files, (unsigned long)file);
>> +
>>   		ceph_fscache_unuse_cookie(inode, file->f_mode & FMODE_WRITE);
>>   		ceph_put_fmode(ci, fi->fmode, 1);
>>   
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 77b0cd9af370..554450838e44 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -619,6 +619,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>   	INIT_LIST_HEAD(&ci->i_unsafe_iops);
>>   	spin_lock_init(&ci->i_unsafe_lock);
>>   
>> +	xa_init(&ci->i_opened_files);
>> +
>>   	ci->i_snap_realm = NULL;
>>   	INIT_LIST_HEAD(&ci->i_snap_realm_item);
>>   	INIT_LIST_HEAD(&ci->i_snap_flush_item);
>> @@ -637,6 +639,8 @@ void ceph_free_inode(struct inode *inode)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   
>> +	xa_destroy(&ci->i_opened_files);
>> +
>>   	kfree(ci->i_symlink);
>>   #ifdef CONFIG_FS_ENCRYPTION
>>   	kfree(ci->fscrypt_auth);
>> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
>> index d8385dd0076e..a176a30badd0 100644
>> --- a/fs/ceph/locks.c
>> +++ b/fs/ceph/locks.c
>> @@ -42,9 +42,10 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>>   
>>   static void ceph_fl_release_lock(struct file_lock *fl)
>>   {
>> -	struct ceph_file_info *fi = fl->fl_file->private_data;
>>   	struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
>>   	struct ceph_inode_info *ci;
>> +	struct ceph_file_info *fi;
>> +	void *val;
>>   
>>   	/*
>>   	 * If inode is NULL it should be a request file_lock,
>> @@ -54,6 +55,20 @@ static void ceph_fl_release_lock(struct file_lock *fl)
>>   		return;
>>   
>>   	ci = ceph_inode(inode);
>> +
>> +	/*
>> +	 * For Posix-style locks, it may race between filp_close()s,
>> +	 * and it's possible that the 'file' memory pointed by
>> +	 * 'fl->fl_file' has been released. If so just skip it.
>> +	 */
>> +	rcu_read_lock();
>> +	val = xa_load(&ci->i_opened_files, (unsigned long)fl->fl_file);
>> +	if (val == CEPH_FILP_AVAILABLE) {
>> +		fi = fl->fl_file->private_data;
>> +		atomic_dec(&fi->num_locks);
> Don't you need to remove the old atomic_dec from this function if you
> move it here?

Yeah, I thought I have removed that. Not sure why I added it back.

>
>> +	}
>> +	rcu_read_unlock();
>> +
>>   	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>>   		/* clear error when all locks are released */
>>   		spin_lock(&ci->i_ceph_lock);
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 7b75a84ba48d..b3e89192cbec 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -329,6 +329,8 @@ struct ceph_inode_xattrs_info {
>>   	u64 version, index_version;
>>   };
>>   
>> +#define CEPH_FILP_AVAILABLE         xa_mk_value(1)
>> +
>>   /*
>>    * Ceph inode.
>>    */
>> @@ -434,6 +436,8 @@ struct ceph_inode_info {
>>   	struct list_head i_unsafe_iops;   /* uncommitted mds inode ops */
>>   	spinlock_t i_unsafe_lock;
>>   
>> +	struct xarray		i_opened_files;
>> +
>>   	union {
>>   		struct ceph_snap_realm *i_snap_realm; /* snap realm (if caps) */
>>   		struct ceph_snapid_map *i_snapid_map; /* snapid -> dev_t */
> This looks like it'll work, but it's a lot of extra work, having to
> track this extra xarray just on the off chance that one of these fd's
> might have file locks. The num_locks field is only checked in one place
> in ceph_get_caps.
>
> Here's what I'd recommend instead:
>
> Have ceph_get_caps look at the lists in inode->i_flctx and see whether
> any of its locks have an fl_file that matches the @filp argument in that
> function. Most inodes never get any file locks, so in most cases  this
> will turn out to just be a NULL pointer check for i_flctx anyway.
>
> Then you can just remove the num_locks field and call the new helper
> from ceph_get_caps instead. I'll send along a proposed patch for the
> helper in a bit.

Sure, Thanks Jeff.

- Xiubo


