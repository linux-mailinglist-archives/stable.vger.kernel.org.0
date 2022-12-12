Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CA664A2A6
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiLLN5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiLLN5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:57:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C497B9FDF;
        Mon, 12 Dec 2022 05:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4104561115;
        Mon, 12 Dec 2022 13:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C2C433F0;
        Mon, 12 Dec 2022 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853433;
        bh=SosdTNqvZlwkRrhdbSd1fjxE5vGZbAdcWj210RKTI3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o52V7S3C2/BOF2hvCpJBT3nZMNMTaJw5lytNmb8LuvDuJqKK8rnGrgR7vdIaWNefT
         Vfzo/Y2FAxBzTu+EGJhQLNEXM6lcEjRjtpEw3Olu6xVcMxg9EBvrSb53G1lsFI5GB2
         MQJIJO//nzvxRzUd4qCe4THaT7/LUVrsSQfa6RT8=
Date:   Mon, 12 Dec 2022 14:35:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Prashanth K <quic_prashk@quicinc.com>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Message-ID: <Y5cuCMhFIaKraUyi@kroah.com>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> Function pointer ki_complete() expects 'long' as its second
> argument, but we pass integer from ffs_user_copy_worker. This
> might cause a CFI failure, as ki_complete is an indirect call
> with mismatched prototype. Fix this by typecasting the second
> argument to long.

"might"?  Does it or not?  If it does, why hasn't this been reported
before?

> Cc: <stable@vger.kernel.org> # 5.15

CFI first showed up in 6.1, not 5.15, right?

> Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
> 
> ---
>  drivers/usb/gadget/function/f_fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 73dc10a7..9c26561 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -835,7 +835,7 @@ static void ffs_user_copy_worker(struct work_struct *work)
>  		kthread_unuse_mm(io_data->mm);
>  	}
>  
> -	io_data->kiocb->ki_complete(io_data->kiocb, ret);
> +	io_data->kiocb->ki_complete(io_data->kiocb, (long)ret);

Why just fix up this one instance?  What about ep_user_copy_worker()?
And what about all other calls to ki_complete that are not using a
(long) cast?

This feels wrong, what exactly is the reported error and how come other
kernel calls to this function pointer have not had a problem with CFI?
ceph_aio_complete() would be another example, right?

thanks,

greg k-h
