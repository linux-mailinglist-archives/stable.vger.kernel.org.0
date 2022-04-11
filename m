Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726494FBF14
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 16:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347047AbiDKOaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 10:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347095AbiDKOaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 10:30:12 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 435573B034
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 07:27:57 -0700 (PDT)
Received: (qmail 342391 invoked by uid 1000); 11 Apr 2022 10:27:56 -0400
Date:   Mon, 11 Apr 2022 10:27:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        mdharm-usb@one-eyed-alien.net, stable@vger.kernel.org
Subject: Re: [PATCH v2] USB: storage: karma: fix rio_karma_init return
Message-ID: <YlQ67AgfvMXkUWEZ@rowland.harvard.edu>
References: <20220411060246.9887-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411060246.9887-1-linma@zju.edu.cn>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 11, 2022 at 02:02:46PM +0800, Lin Ma wrote:
> The function rio_karam_init() should return -ENOMEM instead of
> value 0 (USB_STOR_TRANSPORT_GOOD) when allocation fails.
> 
> Simlarlly, it should return -EIO when rio_karma_send_command() fails.
> 
> Cc: stable@vger.kernel.org
> Fixes: dfe0d3ba20e8 ("USB Storage: add rio karma eject support")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> ---

Acked-by: Alan Stern <stern@rowland.harvard.edu>

>  drivers/usb/storage/karma.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
> index 05cec81dcd3f..38ddfedef629 100644
> --- a/drivers/usb/storage/karma.c
> +++ b/drivers/usb/storage/karma.c
> @@ -174,24 +174,25 @@ static void rio_karma_destructor(void *extra)
>  
>  static int rio_karma_init(struct us_data *us)
>  {
> -	int ret = 0;
>  	struct karma_data *data = kzalloc(sizeof(struct karma_data), GFP_NOIO);
>  
>  	if (!data)
> -		goto out;
> +		return -ENOMEM;
>  
>  	data->recv = kmalloc(RIO_RECV_LEN, GFP_NOIO);
>  	if (!data->recv) {
>  		kfree(data);
> -		goto out;
> +		return -ENOMEM;
>  	}
>  
>  	us->extra = data;
>  	us->extra_destructor = rio_karma_destructor;
> -	ret = rio_karma_send_command(RIO_ENTER_STORAGE, us);
> -	data->in_storage = (ret == 0);
> -out:
> -	return ret;
> +	if (rio_karma_send_command(RIO_ENTER_STORAGE, us))
> +		return -EIO;
> +
> +	data->in_storage = 1;
> +
> +	return 0;
>  }
>  
>  static struct scsi_host_template karma_host_template;
