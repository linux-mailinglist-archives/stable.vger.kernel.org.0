Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FF61D1261
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 14:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgEMMLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 08:11:07 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:43760 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731811AbgEMMLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 08:11:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589371864; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=LHQGqU4NAittweNmmebxB6GmxQZjf/uw2yt+R0pasps=; b=KsSayFf5I7uc8p4+L5XNtZVxyGO4UTw2cJJO6xSrmeHTWvd0lmP9QpwGh262PUylfqsHmDKf
 dUJENN6MwfwCsbXfs+YgsMnnEegjzIUiVw3cZK5rDwR84mm3k3jmr2Rg+ucGUFsLA01d4yL6
 ehd2cnWP1eqhpgxoQDsn7af5WoE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebbe3ba.7f0123b53fb8-smtp-out-n01;
 Wed, 13 May 2020 12:10:34 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E845BC44788; Wed, 13 May 2020 12:10:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.0.102] (unknown [183.83.139.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C25CEC433D2;
        Wed, 13 May 2020 12:10:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C25CEC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=charante@codeaurora.org
Subject: Re: [PATCH v2] dma-buf: fix use-after-free in dmabuffs_dname
To:     Greg KH <greg@kroah.com>
Cc:     sumit.semwal@linaro.org, ghackmann@google.com, fengc@google.com,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, vinmenon@codeaurora.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
 <20200512085221.GB3557007@kroah.com>
From:   Charan Teja Kalla <charante@codeaurora.org>
Message-ID: <a3cbf675-becc-1713-bcdc-664ddfe4a544@codeaurora.org>
Date:   Wed, 13 May 2020 17:40:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512085221.GB3557007@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thank you Greg for the comments.
On 5/12/2020 2:22 PM, Greg KH wrote:
> On Fri, May 08, 2020 at 12:11:03PM +0530, Charan Teja Reddy wrote:
>> The following race occurs while accessing the dmabuf object exported as
>> file:
>> P1				P2
>> dma_buf_release()          dmabuffs_dname()
>> 			   [say lsof reading /proc/<P1 pid>/fd/<num>]
>>
>> 			   read dmabuf stored in dentry->d_fsdata
>> Free the dmabuf object
>> 			   Start accessing the dmabuf structure
>>
>> In the above description, the dmabuf object freed in P1 is being
>> accessed from P2 which is resulting into the use-after-free. Below is
>> the dump stack reported.
>>
>> We are reading the dmabuf object stored in the dentry->d_fsdata but
>> there is no binding between the dentry and the dmabuf which means that
>> the dmabuf can be freed while it is being read from ->d_fsdata and
>> inuse. Reviews on the patch V1 says that protecting the dmabuf inuse
>> with an extra refcount is not a viable solution as the exported dmabuf
>> is already under file's refcount and keeping the multiple refcounts on
>> the same object coordinated is not possible.
>>
>> As we are reading the dmabuf in ->d_fsdata just to get the user passed
>> name, we can directly store the name in d_fsdata thus can avoid the
>> reading of dmabuf altogether.
>>
>> Call Trace:
>>  kasan_report+0x12/0x20
>>  __asan_report_load8_noabort+0x14/0x20
>>  dmabuffs_dname+0x4f4/0x560
>>  tomoyo_realpath_from_path+0x165/0x660
>>  tomoyo_get_realpath
>>  tomoyo_check_open_permission+0x2a3/0x3e0
>>  tomoyo_file_open
>>  tomoyo_file_open+0xa9/0xd0
>>  security_file_open+0x71/0x300
>>  do_dentry_open+0x37a/0x1380
>>  vfs_open+0xa0/0xd0
>>  path_openat+0x12ee/0x3490
>>  do_filp_open+0x192/0x260
>>  do_sys_openat2+0x5eb/0x7e0
>>  do_sys_open+0xf2/0x180
>>
>> Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
>> Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
>> Cc: <stable@vger.kernel.org> [5.3+]
>> Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
>> ---
>>
>> Changes in v2: 
>>
>> - Pass the user passed name in ->d_fsdata instead of dmabuf
>> - Improve the commit message
>>
>> Changes in v1: (https://patchwork.kernel.org/patch/11514063/)
>>
>>  drivers/dma-buf/dma-buf.c | 17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index 01ce125..0071f7d 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/mount.h>
>>  #include <linux/pseudo_fs.h>
>> +#include <linux/dcache.h>
>>  
>>  #include <uapi/linux/dma-buf.h>
>>  #include <uapi/linux/magic.h>
>> @@ -40,15 +41,13 @@ struct dma_buf_list {
>>  
>>  static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>>  {
>> -	struct dma_buf *dmabuf;
>>  	char name[DMA_BUF_NAME_LEN];
>>  	size_t ret = 0;
>>  
>> -	dmabuf = dentry->d_fsdata;
>> -	dma_resv_lock(dmabuf->resv, NULL);
>> -	if (dmabuf->name)
>> -		ret = strlcpy(name, dmabuf->name, DMA_BUF_NAME_LEN);
>> -	dma_resv_unlock(dmabuf->resv);
>> +	spin_lock(&dentry->d_lock);
> 
> Are you sure this lock always protects d_fsdata?

I think yes. In the dma-buf.c, I have to make sure that d_fsdata should
always be under d_lock thus it will be protected. (In this posted patch
there is one place(in dma_buf_set_name) that is missed, will update this
in V3).

> 
>> +	if (dentry->d_fsdata)
>> +		ret = strlcpy(name, dentry->d_fsdata, DMA_BUF_NAME_LEN);
>> +	spin_unlock(&dentry->d_lock);
>>  
>>  	return dynamic_dname(dentry, buffer, buflen, "/%s:%s",
>>  			     dentry->d_name.name, ret > 0 ? name : "");
> 
> If the above check fails the name will be what?  How could d_name.name
> be valid but d_fsdata not be valid?

In case of check fails, empty string "" is appended to the name by the
code, ret > 0 ? name : "", ret is initialized to zero. Thus the name
string will be like "/dmabuf:".

Regarding the validity of d_fsdata, we are setting the dmabuf's
dentry->d_fsdata to NULL in the dma_buf_release() thus can go invalid if
that dmabuf is in the free path.


> 
> 
>> @@ -80,12 +79,16 @@ static int dma_buf_fs_init_context(struct fs_context *fc)
>>  static int dma_buf_release(struct inode *inode, struct file *file)
>>  {
>>  	struct dma_buf *dmabuf;
>> +	struct dentry *dentry = file->f_path.dentry;
>>  
>>  	if (!is_dma_buf_file(file))
>>  		return -EINVAL;
>>  
>>  	dmabuf = file->private_data;
>>  
>> +	spin_lock(&dentry->d_lock);
>> +	dentry->d_fsdata = NULL;
>> +	spin_unlock(&dentry->d_lock);
>>  	BUG_ON(dmabuf->vmapping_counter);
>>  
>>  	/*
>> @@ -343,6 +346,7 @@ static long dma_buf_set_name(struct dma_buf *dmabuf, const char __user *buf)
>>  	}
>>  	kfree(dmabuf->name);
>>  	dmabuf->name = name;
>> +	dmabuf->file->f_path.dentry->d_fsdata = name;
> 
> You are just changing the use of d_fsdata from being a pointer to the
> dmabuf to being a pointer to the name string?  What's to keep that name
> string around and not have the same reference counting issues that the
> dmabuf structure itself has?  Who frees that string memory?
> 

Yes, I am just storing the name string in the d_fsdata in place of
dmabuf and this helps to get rid of any extra refcount requirement.
Because the user passed name carried in the d_fsdata is copied to the
local buffer in dmabuffs_dname under spin_lock(d_lock) and the same
d_fsdata is set to NULL(under the d_lock only) when that dmabuf is in
the release path. So, when d_fsdata is NULL, name string is not accessed
from the dmabuffs_dname thus extra count is not required.

String memory, stored in the dmabuf->name, is released from the
dma_buf_release(). Flow will be like, It fist sets d_fsdata=NULL and
then free the dmabuf->name.

However from your comments I have realized that there is a race in this
patch when using the name string between dma_buf_set_name() and
dmabuffs_dname(). But, If the idea of passing the name string inplace of
dmabuf in d_fsdata looks fine, I can update this next patch.

> thanks,
> 
> greg k-h
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project
