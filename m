Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF1A627FAC
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiKNNBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237696AbiKNNBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D3E264A6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668430819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XbnOKNFz0QFpr0L/BEERrr3p9C0lyZVLkIZ75c02Fh8=;
        b=Y/TnewrhcWgbomFyrU7PB8mUZF8NmOthxHu6M2Q70l4yIuESurBvX69/NqVmvd0KfWudpc
        9xwZEgcqtmK/e0U+mZqusQpkiAvTLfj140UHcJ4Y1BZsf6XOtYgQ2q3Dr4bzP0Qxi9YEBI
        k1w7Wvv6Kel4AuTW4NID4AcPoMf0KBU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-GJWyMD5COfW-xu_a3a3Nkw-1; Mon, 14 Nov 2022 08:00:18 -0500
X-MC-Unique: GJWyMD5COfW-xu_a3a3Nkw-1
Received: by mail-pj1-f71.google.com with SMTP id g6-20020a17090a300600b00212f609f6aeso5745447pjb.9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbnOKNFz0QFpr0L/BEERrr3p9C0lyZVLkIZ75c02Fh8=;
        b=59d7QEO+HB1vRh7VsTYOeZEbyWa9u5ruMWFUTOMqx2hOcYpJggylaiBawVjvfG+8VF
         QcxdrrkhIJkSbGkK8wirh2hsZfLvnODUD4j74NuS4/ylqqlKRlap3CQG6rJ7nly31twR
         VflABJjyhd+BWdGqRcTathMNfuEtylVc2Gad0/9fXVfdXvKann0aTrsp2vz8Jn6Z4m9n
         UNBpfbwmRrXLp27LNTI1Hzlk9EPT4fSJfD+pYQyyxXmAxFudpvv1H1bvwtO4WfJheMQF
         SSnTfmtXrc/GQWp5wDIpsolBYaYavURUOPJtJFSqKswVYooe3yBlnlRQvqMUGXIdfRHi
         jAuQ==
X-Gm-Message-State: ANoB5pmBDIEOdvUZ+oSIzYDA4xQ713XOrRpIdprbgG638PCgBgMC/gIJ
        ze6UYr+clzD/ocwIvQ6PcqyPMMRiQ/2PoXqJQvOZHlVZUUotCjd79sLuG3/8uuXOItyV3BOFyvy
        eT3Y1QLO+3WsbyNXb9sztVom0C5VBh67vCVuDCer9Et6VLrB0YI0Gtju41Z5mS53HFg==
X-Received: by 2002:a17:902:6b87:b0:187:1a3f:d552 with SMTP id p7-20020a1709026b8700b001871a3fd552mr14015252plk.5.1668430816787;
        Mon, 14 Nov 2022 05:00:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7PelnllhUECNg95HS+A2FAfeyz67tAnA4tlyPp96EoUln1X8uQMw0aPOqBKxB+EIWHj+s1Hw==
X-Received: by 2002:a17:902:6b87:b0:187:1a3f:d552 with SMTP id p7-20020a1709026b8700b001871a3fd552mr14015186plk.5.1668430816228;
        Mon, 14 Nov 2022 05:00:16 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n3-20020a17090ab80300b00210c84b8ae5sm6377845pjr.35.2022.11.14.05.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 05:00:15 -0800 (PST)
Subject: Re: [PATCH 1/2 v2] ceph: add ceph_lock_info support for file_lock
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, viro@zeniv.linux.org.uk
Cc:     lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221114051901.15371-1-xiubli@redhat.com>
 <20221114051901.15371-2-xiubli@redhat.com>
 <f2d6f7a3fa75710a1170a8969d948e85d056c272.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <46c13ca8-ed59-d033-cf7a-0c35770e7df0@redhat.com>
Date:   Mon, 14 Nov 2022 21:00:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f2d6f7a3fa75710a1170a8969d948e85d056c272.camel@kernel.org>
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


On 14/11/2022 19:24, Jeff Layton wrote:
> On Mon, 2022-11-14 at 13:19 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When ceph releasing the file_lock it will try to get the inode pointer
>> from the fl->fl_file, which the memory could already be released by
>> another thread in filp_close(). Because in VFS layer the fl->fl_file
>> doesn't increase the file's reference counter.
>>
>> Will switch to use ceph dedicate lock info to track the inode.
>>
>> And in ceph_fl_release_lock() we should skip all the operations if
>> the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
>> the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
>> inserting it to the inode lock list, which is when copying the lock.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57986
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/locks.c                 | 18 +++++++++++++++---
>>   include/linux/ceph/ceph_fs_fl.h | 26 ++++++++++++++++++++++++++
>>   include/linux/fs.h              |  2 ++
>>   3 files changed, 43 insertions(+), 3 deletions(-)
>>   create mode 100644 include/linux/ceph/ceph_fs_fl.h
>>
>> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
>> index 3e2843e86e27..d8385dd0076e 100644
>> --- a/fs/ceph/locks.c
>> +++ b/fs/ceph/locks.c
>> @@ -34,22 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>>   {
>>   	struct ceph_file_info *fi = dst->fl_file->private_data;
>>   	struct inode *inode = file_inode(dst->fl_file);
>> +
>>   	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
>>   	atomic_inc(&fi->num_locks);
>> +	dst->fl_u.ceph_fl.fl_inode = igrab(inode);
>>   }
>>   
>>   static void ceph_fl_release_lock(struct file_lock *fl)
>>   {
>>   	struct ceph_file_info *fi = fl->fl_file->private_data;
>> -	struct inode *inode = file_inode(fl->fl_file);
>> -	struct ceph_inode_info *ci = ceph_inode(inode);
>> -	atomic_dec(&fi->num_locks);
>> +	struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
>> +	struct ceph_inode_info *ci;
>> +
>> +	/*
>> +	 * If inode is NULL it should be a request file_lock,
>> +	 * nothing we can do.
>> +	 */
>> +	if (!inode)
>> +		return;
>> +
>> +	ci = ceph_inode(inode);
>>   	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>>   		/* clear error when all locks are released */
>>   		spin_lock(&ci->i_ceph_lock);
>>   		ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>>   		spin_unlock(&ci->i_ceph_lock);
>>   	}
>> +	iput(inode);
>> +	atomic_dec(&fi->num_locks);
> It doesn't look like this fixes the original issue. "fi" may be pointing
> to freed memory at this point, right?

Yeah, I didn't fix this in the this patch. I fixed it in a dedicated 2/2 
patch.

>   I think you may need to get rid of
> the "num_locks" field in ceph_file_info, and do that in a different way?
>
This is a dedicated field for each 'file' struct. I have no idea how to 
fix this in a different way yet.

Thanks!

- Xiubo


>>   }
>>   
>>   static const struct file_lock_operations ceph_fl_lock_ops = {
>> diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_fs_fl.h
>> new file mode 100644
>> index 000000000000..02a412b26095
>> --- /dev/null
>> +++ b/include/linux/ceph/ceph_fs_fl.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * ceph_fs.h - Ceph constants and data types to share between kernel and
>> + * user space.
>> + *
>> + * Most types in this file are defined as little-endian, and are
>> + * primarily intended to describe data structures that pass over the
>> + * wire or that are stored on disk.
>> + *
>> + * LGPL2
>> + */
>> +
>> +#ifndef CEPH_FS_FL_H
>> +#define CEPH_FS_FL_H
>> +
>> +#include <linux/fs.h>
>> +
>> +/*
>> + * Ceph lock info
>> + */
>> +
>> +struct ceph_lock_info {
>> +	struct inode *fl_inode;
>> +};
>> +
>> +#endif
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index e654435f1651..db4810d19e26 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
>>   
>>   /* that will die - we need it for nfs_lock_info */
>>   #include <linux/nfs_fs_i.h>
>> +#include <linux/ceph/ceph_fs_fl.h>
>>   
>>   /*
>>    * struct file_lock represents a generic "file lock". It's used to represent
>> @@ -1119,6 +1120,7 @@ struct file_lock {
>>   			int state;		/* state of grant or error if -ve */
>>   			unsigned int	debug_id;
>>   		} afs;
>> +		struct ceph_lock_info	ceph_fl;
>>   	} fl_u;
>>   } __randomize_layout;
>>   

