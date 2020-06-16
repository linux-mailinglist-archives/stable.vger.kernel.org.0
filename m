Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A501FB268
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 15:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgFPNoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 09:44:08 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:27162 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbgFPNoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 09:44:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1592315044; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=neAnsfkRMgdLmxrFAs43gbDE9/rNCoat18mjJVvgJoU=; b=c9tqymhkloHgFvwk8XM/q4YwgrK6AlXcOCwI9HfKL148ujqhzaD/TYOXfO03VJSWT4Tj5TOB
 LPzPAJoBty4hbJn0xRIz76JjpWh41Mz9g4oDfame05gR2mFIKY1FNXJwdXAqgioEh2EDG3HS
 B3b/cKz2KSBaCzirH7hnEogJOck=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5ee8cc996bebe35deb85aa39 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 16 Jun 2020 13:43:53
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7B2CEC43395; Tue, 16 Jun 2020 13:43:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.102] (unknown [183.83.143.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: charante)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BBD87C433C9;
        Tue, 16 Jun 2020 13:43:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BBD87C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=charante@codeaurora.org
Subject: Re: [PATCH v2] dma-buf: Move dma_buf_release() from fops to
 dentry_ops
To:     Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Chenbo Feng <fengc@google.com>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <20200611114418.19852-1-sumit.semwal@linaro.org>
From:   Charan Teja Kalla <charante@codeaurora.org>
Message-ID: <59f0062d-5ca9-84f1-ba92-c3463ff0e73d@codeaurora.org>
Date:   Tue, 16 Jun 2020 19:13:47 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611114418.19852-1-sumit.semwal@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Sumit for the fix.

On 6/11/2020 5:14 PM, Sumit Semwal wrote:
> Charan Teja reported a 'use-after-free' in dmabuffs_dname [1], which
> happens if the dma_buf_release() is called while the userspace is
> accessing the dma_buf pseudo fs's dmabuffs_dname() in another process,
> and dma_buf_release() releases the dmabuf object when the last reference
> to the struct file goes away.
> 
> I discussed with Arnd Bergmann, and he suggested that rather than tying
> the dma_buf_release() to the file_operations' release(), we can tie it to
> the dentry_operations' d_release(), which will be called when the last ref
> to the dentry is removed.
> 
> The path exercised by __fput() calls f_op->release() first, and then calls
> dput, which eventually calls d_op->d_release().
> 
> In the 'normal' case, when no userspace access is happening via dma_buf
> pseudo fs, there should be exactly one fd, file, dentry and inode, so
> closing the fd will kill of everything right away.
> 
> In the presented case, the dentry's d_release() will be called only when
> the dentry's last ref is released.
> 
> Therefore, lets move dma_buf_release() from fops->release() to
> d_ops->d_release()
> 
> Many thanks to Arnd for his FS insights :)
> 
> [1]: https://lore.kernel.org/patchwork/patch/1238278/
> 
> Fixes: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls")
> Reported-by: syzbot+3643a18836bce555bff6@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> [5.3+]
> Cc: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Charan Teja Reddy <charante@codeaurora.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> 

Tested this patch for Android running on Snapdragon hardware and see no
issues.
Tested-by: Charan Teja Reddy <charante@codeaurora.org>

> ---
> v2: per Arnd: Moved dma_buf_release() above to avoid forward declaration;
>      removed dentry_ops check.
> ---
>  drivers/dma-buf/dma-buf.c | 54 ++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 01ce125f8e8d..412629601ad3 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -54,37 +54,11 @@ static char *dmabuffs_dname(struct dentry *dentry, char *buffer, int buflen)
>  			     dentry->d_name.name, ret > 0 ? name : "");
>  }
>  
> -static const struct dentry_operations dma_buf_dentry_ops = {
> -	.d_dname = dmabuffs_dname,
> -};
> -
> -static struct vfsmount *dma_buf_mnt;
> -
> -static int dma_buf_fs_init_context(struct fs_context *fc)
> -{
> -	struct pseudo_fs_context *ctx;
> -
> -	ctx = init_pseudo(fc, DMA_BUF_MAGIC);
> -	if (!ctx)
> -		return -ENOMEM;
> -	ctx->dops = &dma_buf_dentry_ops;
> -	return 0;
> -}
> -
> -static struct file_system_type dma_buf_fs_type = {
> -	.name = "dmabuf",
> -	.init_fs_context = dma_buf_fs_init_context,
> -	.kill_sb = kill_anon_super,
> -};
> -
> -static int dma_buf_release(struct inode *inode, struct file *file)
> +static void dma_buf_release(struct dentry *dentry)
>  {
>  	struct dma_buf *dmabuf;
>  
> -	if (!is_dma_buf_file(file))
> -		return -EINVAL;
> -
> -	dmabuf = file->private_data;
> +	dmabuf = dentry->d_fsdata;
>  
>  	BUG_ON(dmabuf->vmapping_counter);
>  
> @@ -110,9 +84,32 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>  	module_put(dmabuf->owner);
>  	kfree(dmabuf->name);
>  	kfree(dmabuf);
> +}
> +
> +static const struct dentry_operations dma_buf_dentry_ops = {
> +	.d_dname = dmabuffs_dname,
> +	.d_release = dma_buf_release,
> +};
> +
> +static struct vfsmount *dma_buf_mnt;
> +
> +static int dma_buf_fs_init_context(struct fs_context *fc)
> +{
> +	struct pseudo_fs_context *ctx;
> +
> +	ctx = init_pseudo(fc, DMA_BUF_MAGIC);
> +	if (!ctx)
> +		return -ENOMEM;
> +	ctx->dops = &dma_buf_dentry_ops;
>  	return 0;
>  }
>  
> +static struct file_system_type dma_buf_fs_type = {
> +	.name = "dmabuf",
> +	.init_fs_context = dma_buf_fs_init_context,
> +	.kill_sb = kill_anon_super,
> +};
> +
>  static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct dma_buf *dmabuf;
> @@ -412,7 +409,6 @@ static void dma_buf_show_fdinfo(struct seq_file *m, struct file *file)
>  }
>  
>  static const struct file_operations dma_buf_fops = {
> -	.release	= dma_buf_release,
>  	.mmap		= dma_buf_mmap_internal,
>  	.llseek		= dma_buf_llseek,
>  	.poll		= dma_buf_poll,
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project
