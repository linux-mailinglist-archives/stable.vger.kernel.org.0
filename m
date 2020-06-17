Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE1C1FC62D
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 08:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgFQG2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 02:28:50 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:12869 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbgFQG2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 02:28:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592375328; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=s/Vm4bvk2cxG6VkzRYO3gzXCbP6ddUmYHI9BmSE6AD4=; b=AqAHdhbsacOODeSKAfbxZGGTu4qT26y1qvam9l0nE3a8NYre+nrA8HBBO33ApYJdyH0L3d5i
 +njsLsrqbt1x+baZHk/N+J5XSy7R1LIGOJyxR4u9hXGJCsdDb+VMmm4HuRpFfM3dTmsQWlSW
 dJkRdBYqrU2RfQP5r2ZcGfJJkHA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n15.prod.us-west-2.postgun.com with SMTP id
 5ee9b81dfe1db4db89e07cdf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Jun 2020 06:28:45
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4F01DC433CB; Wed, 17 Jun 2020 06:28:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.102] (unknown [183.83.143.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EDC99C433C8;
        Wed, 17 Jun 2020 06:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EDC99C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=charante@codeaurora.org
Subject: Re: [PATCH] dmabuf: use spinlock to access dmabuf->name
To:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Cc:     Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "vinmenon@codeaurora.org" <vinmenon@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <316a5cf9-ca71-6506-bf8b-e79ded9055b2@codeaurora.org>
 <14063C7AD467DE4B82DEDB5C278E8663010F365EF5@fmsmsx107.amr.corp.intel.com>
 <14063C7AD467DE4B82DEDB5C278E8663010F365F7D@fmsmsx107.amr.corp.intel.com>
From:   Charan Teja Kalla <charante@codeaurora.org>
Message-ID: <5b960c9a-ef9d-b43d-716d-113efc793fe5@codeaurora.org>
Date:   Wed, 17 Jun 2020 11:58:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663010F365F7D@fmsmsx107.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Michael for the comments..

On 6/16/2020 7:29 PM, Ruhl, Michael J wrote:
>> -----Original Message-----
>> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of
>> Ruhl, Michael J
>> Sent: Tuesday, June 16, 2020 9:51 AM
>> To: Charan Teja Kalla <charante@codeaurora.org>; Sumit Semwal
>> <sumit.semwal@linaro.org>; open list:DMA BUFFER SHARING FRAMEWORK
>> <linux-media@vger.kernel.org>; DRI mailing list <dri-
>> devel@lists.freedesktop.org>
>> Cc: Linaro MM SIG <linaro-mm-sig@lists.linaro.org>;
>> vinmenon@codeaurora.org; LKML <linux-kernel@vger.kernel.org>;
>> stable@vger.kernel.org
>> Subject: RE: [PATCH] dmabuf: use spinlock to access dmabuf->name
>>
>>> -----Original Message-----
>>> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of
>>> Charan Teja Kalla
>>> Sent: Thursday, June 11, 2020 9:40 AM
>>> To: Sumit Semwal <sumit.semwal@linaro.org>; open list:DMA BUFFER
>>> SHARING FRAMEWORK <linux-media@vger.kernel.org>; DRI mailing list <dri-
>>> devel@lists.freedesktop.org>
>>> Cc: Linaro MM SIG <linaro-mm-sig@lists.linaro.org>;
>>> vinmenon@codeaurora.org; LKML <linux-kernel@vger.kernel.org>;
>>> stable@vger.kernel.org
>>> Subject: [PATCH] dmabuf: use spinlock to access dmabuf->name
>>>
>>> There exists a sleep-while-atomic bug while accessing the dmabuf->name
>>> under mutex in the dmabuffs_dname(). This is caused from the SELinux
>>> permissions checks on a process where it tries to validate the inherited
>>> files from fork() by traversing them through iterate_fd() (which
>>> traverse files under spin_lock) and call
>>> match_file(security/selinux/hooks.c) where the permission checks happen.
>>> This audit information is logged using dump_common_audit_data() where it
>>> calls d_path() to get the file path name. If the file check happen on
>>> the dmabuf's fd, then it ends up in ->dmabuffs_dname() and use mutex to
>>> access dmabuf->name. The flow will be like below:
>>> flush_unauthorized_files()
>>>  iterate_fd()
>>>    spin_lock() --> Start of the atomic section.
>>>      match_file()
>>>        file_has_perm()
>>>          avc_has_perm()
>>>            avc_audit()
>>>              slow_avc_audit()
>>> 	        common_lsm_audit()
>>> 		  dump_common_audit_data()
>>> 		    audit_log_d_path()
>>> 		      d_path()
>>>                        dmabuffs_dname()
>>>                          mutex_lock()--> Sleep while atomic.
>>>
>>> Call trace captured (on 4.19 kernels) is below:
>>> ___might_sleep+0x204/0x208
>>> __might_sleep+0x50/0x88
>>> __mutex_lock_common+0x5c/0x1068
>>> __mutex_lock_common+0x5c/0x1068
>>> mutex_lock_nested+0x40/0x50
>>> dmabuffs_dname+0xa0/0x170
>>> d_path+0x84/0x290
>>> audit_log_d_path+0x74/0x130
>>> common_lsm_audit+0x334/0x6e8
>>> slow_avc_audit+0xb8/0xf8
>>> avc_has_perm+0x154/0x218
>>> file_has_perm+0x70/0x180
>>> match_file+0x60/0x78
>>> iterate_fd+0x128/0x168
>>> selinux_bprm_committing_creds+0x178/0x248
>>> security_bprm_committing_creds+0x30/0x48
>>> install_exec_creds+0x1c/0x68
>>> load_elf_binary+0x3a4/0x14e0
>>> search_binary_handler+0xb0/0x1e0
>>>
>>> So, use spinlock to access dmabuf->name to avoid sleep-while-atomic.
>>>
>>> Cc: <stable@vger.kernel.org> [5.3+]
>>> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
>>> ---
>>> drivers/dma-buf/dma-buf.c | 13 +++++++------
>>> include/linux/dma-buf.h   |  1 +
>>> 2 files changed, 8 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>>> index 01ce125..2e0456c 100644
>>> --- a/drivers/dma-buf/dma-buf.c
>>> +++ b/drivers/dma-buf/dma-buf.c
>>> @@ -45,10 +45,10 @@ static char *dmabuffs_dname(struct dentry *dentry,
>>> char *buffer, int buflen)
>>> 	size_t ret = 0;
>>>
>>> 	dmabuf = dentry->d_fsdata;
>>> -	dma_resv_lock(dmabuf->resv, NULL);
>>> +	spin_lock(&dmabuf->name_lock);
>>> 	if (dmabuf->name)
>>> 		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
>>> -	dma_resv_unlock(dmabuf->resv);
>>> +	spin_unlock(&dmabuf->name_lock);
>>
>> I am not really clear on why you need this lock.
>>
>> If name == NULL you have no issues.
>> If name is real, you have no issues.

Yeah, ideal cases...

>>
>> If name is freed you will copy garbage, but the only way
>> for that to happen is that _set_name or _release have to be called
>> at just the right time.
>>
>> And the above would probably only be an issue if the set_name
>> was called, so you will get NULL or a real name.

And there exists a use-after-free to avoid which requires the lock. Say
that memcpy() in dmabuffs_dname is in progress and in parallel _set_name
will free the same buffer that memcpy is operating on.

>>
>> Is there a reason for the lock here?
>>
>> Mike
> 
> Maybe dmabuf->name = NULL after the kfree(dmabuf->name) in:
> 
> dma_buf_release()
> 
> Would be sufficient?

I don't think that we will access the 'dmabuf'(thus dmabuf->name) once
it is in the dma_buf_release(). So, setting the NULL in the _release()
is not required at all.

> 
> M
>>> 	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
>>> 			     dentry->d_name.name, ret > 0 ? name : "");
>>> @@ -335,7 +335,7 @@ static long dma_buf_set_name(struct dma_buf
>>> *dmabuf, const char __user *buf)
>>> 	if (IS_ERR(name))
>>> 		return PTR_ERR(name);
>>>
>>> -	dma_resv_lock(dmabuf->resv, NULL);
>>> +	spin_lock(&dmabuf->name_lock);
>>> 	if (!list_empty(&dmabuf->attachments)) {
>>> 		ret = -EBUSY;
>>> 		kfree(name);
>>> @@ -345,7 +345,7 @@ static long dma_buf_set_name(struct dma_buf
>>> *dmabuf, const char __user *buf)
>>> 	dmabuf->name = name;
>>>
>>> out_unlock:
>>> -	dma_resv_unlock(dmabuf->resv);
>>> +	spin_unlock(&dmabuf->name_lock);
>>> 	return ret;
>>> }
>>>
>>> @@ -405,10 +405,10 @@ static void dma_buf_show_fdinfo(struct seq_file
>>> *m, struct file *file)
>>> 	/* Don't count the temporary reference taken inside procfs seq_show
>>> */
>>> 	seq_printf(m, "count:\t%ld\n", file_count(dmabuf->file) - 1);
>>> 	seq_printf(m, "exp_name:\t%s\n", dmabuf->exp_name);
>>> -	dma_resv_lock(dmabuf->resv, NULL);
>>> +	spin_lock(&dmabuf->name_lock);
>>> 	if (dmabuf->name)
>>> 		seq_printf(m, "name:\t%s\n", dmabuf->name);
>>> -	dma_resv_unlock(dmabuf->resv);
>>> +	spin_unlock(&dmabuf->name_lock);
>>> }
>>>
>>> static const struct file_operations dma_buf_fops = {
>>> @@ -546,6 +546,7 @@ struct dma_buf *dma_buf_export(const struct
>>> dma_buf_export_info *exp_info)
>>> 	dmabuf->size = exp_info->size;
>>> 	dmabuf->exp_name = exp_info->exp_name;
>>> 	dmabuf->owner = exp_info->owner;
>>> +	spin_lock_init(&dmabuf->name_lock);
>>> 	init_waitqueue_head(&dmabuf->poll);
>>> 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
>>> 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>> index ab0c156..93108fd 100644
>>> --- a/include/linux/dma-buf.h
>>> +++ b/include/linux/dma-buf.h
>>> @@ -311,6 +311,7 @@ struct dma_buf {
>>> 	void *vmap_ptr;
>>> 	const char *exp_name;
>>> 	const char *name;
>>> +	spinlock_t name_lock;
>>> 	struct module *owner;
>>> 	struct list_head list_node;
>>> 	void *priv;
>>> --
>>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>>> Forum, a Linux Foundation Collaborative Project
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project
