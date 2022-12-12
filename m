Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050B364A29F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiLLN4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiLLN42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:56:28 -0500
X-Greylist: delayed 1115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Dec 2022 05:56:16 PST
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256F615A2B;
        Mon, 12 Dec 2022 05:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=cO3Dx3OHHxJSEXzaZsdDqnwyc7eLG61Edw6kEr88FUU=; b=PIQL8
        ifItxTKeDkURpz5aWa2Szu4wbUbPUFIZ/PBC1DzBkkbw4AqIoX2oJJSZS/z0fFB94RtbBN8iKFZJg
        uZR3hqZ+C3AZz5J2pS+eao6GdpH5bTt4Op0V8S2PqBvApykhwFZxE86rebXibIlbHczI0XomGMuvD
        IqUVhDRbEL/Q4OuRu8f5If7WdhMwZLdODpQ7jGAoDF5eBfrAcGeCBP+hVN6qKa8q5tWgYjwafQPIh
        BTt1yjNgLigmm7pj9zkp3VRo8HiiOrKiGhamiJm9xfDqE8cQeV2RvGRx7uKgd57mK2mOZCQbwf+T5
        vaPUkMWPMVhhloR9njp8L0UCy8qaQ==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <john@metanate.com>)
        id 1p4izs-0007Q1-Hs;
        Mon, 12 Dec 2022 13:37:33 +0000
Date:   Mon, 12 Dec 2022 13:37:31 +0000
From:   John Keeping <john@metanate.com>
To:     Prashanth K <quic_prashk@quicinc.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Message-ID: <Y5cum5pYxro1SYtx@donbot>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
X-Authenticated: YES
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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
> 
> Cc: <stable@vger.kernel.org> # 5.15
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

I don't understand the problem here, ki_complete() is declared with a
long parameter, so won't integer promotion kick in so that the function
is called with a long?  Why is the explicit cast necessary?

>  
>  	if (io_data->ffs->ffs_eventfd && !kiocb_has_eventfd)
>  		eventfd_signal(io_data->ffs->ffs_eventfd, 1);
> -- 
> 2.7.4
> 
