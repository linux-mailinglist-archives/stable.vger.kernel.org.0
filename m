Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A460F1C33FC
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgEDIFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727827AbgEDIFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:05:14 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5F2C061A0F
        for <stable@vger.kernel.org>; Mon,  4 May 2020 01:05:13 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so19758000wrx.4
        for <stable@vger.kernel.org>; Mon, 04 May 2020 01:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TW5sBRpo/YovaEfvGvwj3MSBq0/ytrBMh4na3w3/wC4=;
        b=Gu9yXS48OKcopziozZMjKwXRZWcKzNvJ+duJS9Ckr8h226rg0DZ+YeIyacJpwQ+Bda
         eKn49Mn4hx4W1fpA7Uz05acJQFvAwP2sVxTSTiqKpV0xr0I9wAppmz9cQnes30Z5cP9H
         0kc6Ew63a4gQAVdviMiManHLD5ql1twciwZtqrtiWfQL7obmi2OtbpBEdvjArgaLsUos
         cjA6rTehU32xRE1xCo+dGmGqh9wiQX9hgfqC9D9Os6loRNwzteyc46sNG1LMDLmv67M0
         I8orH4SEd8wJBBIe9pSxmxmtG06G6uux6QFwYJLwsXYf/eD4/wyrj16bjjQFE76YqTMR
         zJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=TW5sBRpo/YovaEfvGvwj3MSBq0/ytrBMh4na3w3/wC4=;
        b=oUGWQ9vSE/cWidCZGQg5k64kuo7Da+EUbtBK7iaJn0pFHU9X40avSniNnc9Ys0w+XM
         zB5LX9+9SA/jj6lLi2qfJc9ovCoyqyli9YbA2Ez9zmPL35QJo2RvtrDnkv8TaAjcI1VL
         GX0zJMpMk5QtTDxj87NnqGf8I/XGX1wW1SalyxfopWD2j7kwzD84qVDm1ZUJE2og+8RL
         s51+9+o8+Cm66/pekVRmrk1QWJK4XrbnBfTjmQATUsQT0hpwwKK37wy1+L1VOYhzmrAe
         E0SSz4P07gNEjmBJf+WxqnnAVnh7Hxmrxl7RGUd1PZidJUBTYkqYkOPbHCjfXMZf8Nvf
         M0uw==
X-Gm-Message-State: AGi0PuaguTToITbT9AIzi2IUaM9/1axBcXPZJ5rGBGwNZrxV1/Zotcu4
        fkF4YwG3WF8lrWAR03eAexw/ew==
X-Google-Smtp-Source: APiQypIIJl/1BkC+pU0YDwuqwNHWOmTT/zmjbnadLRwFRDLLGn5eO42Hq/TIqKLWZJVAvO+6QPUT/w==
X-Received: by 2002:adf:ecc3:: with SMTP id s3mr15255246wro.116.1588579512157;
        Mon, 04 May 2020 01:05:12 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id n18sm8775043wrw.90.2020.05.04.01.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 01:05:11 -0700 (PDT)
Subject: Re: [PATCH 01/12] aio: fix async fsync creds
To:     Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org,
        Giuseppe Scrivano <gscrivan@redhat.com>, stable@vger.kernel.org
References: <20191128155940.17530-1-mszeredi@redhat.com>
 <20191128155940.17530-2-mszeredi@redhat.com>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <37c7880a-a551-b381-fe07-581059f17f06@scylladb.com>
Date:   Mon, 4 May 2020 11:05:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20191128155940.17530-2-mszeredi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping on this unapplied patch. Its lack makes it hard to use containers 
for development of storage systems.


On 28/11/2019 17.59, Miklos Szeredi wrote:
> Avi Kivity reports that on fuse filesystems running in a user namespace
> asyncronous fsync fails with EOVERFLOW.
>
> The reason is that f_ops->fsync() is called with the creds of the kthread
> performing aio work instead of the creds of the process originally
> submitting IOCB_CMD_FSYNC.
>
> Fuse sends the creds of the caller in the request header and it needs to
> translate the uid and gid into the server's user namespace.  Since the
> kthread is running in init_user_ns, the translation will fail and the
> operation returns an error.
>
> It can be argued that fsync doesn't actually need any creds, but just
> zeroing out those fields in the header (as with requests that currently
> don't take creds) is a backward compatibility risk.
>
> Instead of working around this issue in fuse, solve the core of the problem
> by calling the filesystem with the proper creds.
>
> Reported-by: Avi Kivity <avi@scylladb.com>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Fixes: c9582eb0ff7d ("fuse: Fail all requests with invalid uids or gids")
> Cc: stable@vger.kernel.org  # 4.18+
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>   fs/aio.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 0d9a559d488c..37828773e2fe 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -176,6 +176,7 @@ struct fsync_iocb {
>   	struct file		*file;
>   	struct work_struct	work;
>   	bool			datasync;
> +	struct cred		*creds;
>   };
>   
>   struct poll_iocb {
> @@ -1589,8 +1590,11 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
>   static void aio_fsync_work(struct work_struct *work)
>   {
>   	struct aio_kiocb *iocb = container_of(work, struct aio_kiocb, fsync.work);
> +	const struct cred *old_cred = override_creds(iocb->fsync.creds);
>   
>   	iocb->ki_res.res = vfs_fsync(iocb->fsync.file, iocb->fsync.datasync);
> +	revert_creds(old_cred);
> +	put_cred(iocb->fsync.creds);
>   	iocb_put(iocb);
>   }
>   
> @@ -1604,6 +1608,10 @@ static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
>   	if (unlikely(!req->file->f_op->fsync))
>   		return -EINVAL;
>   
> +	req->creds = prepare_creds();
> +	if (!req->creds)
> +		return -ENOMEM;
> +
>   	req->datasync = datasync;
>   	INIT_WORK(&req->work, aio_fsync_work);
>   	schedule_work(&req->work);
