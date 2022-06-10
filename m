Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343EC546147
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 11:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348362AbiFJJPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 05:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348301AbiFJJO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 05:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FB11E453A;
        Fri, 10 Jun 2022 02:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12C6561DB0;
        Fri, 10 Jun 2022 09:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3784C34114;
        Fri, 10 Jun 2022 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654852477;
        bh=Z7sJ4lfH5jzBl3NmwNE0JCRIvhUvBJGBRUXOTcKx7bE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DcDy5NwM6eHMxZL+x0GBmcQJfruGy9nTMfO/Rp1948pmixF5yWCO6Ms5JxaTqWFOE
         DKELTZcD16kUcS/VCd68jbGMcSXinBetcP/wc5P+pnIcXSPNdXKtyRO0O1J1fGmgAZ
         ImWzI9667Fgs6PGNV2bdni/Tp3jaL/DtwF16rN2c=
Date:   Fri, 10 Jun 2022 11:14:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
Cc:     Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, Jack Pham <quic_jackp@quicinc.com>,
        Michael Wu <michael@allwinnertech.com>,
        John Keeping <john@metanate.com>
Subject: Re: [PATCH v4 1/2] usb: gadget: f_fs: change ep->status safe in
 ffs_epfile_io()
Message-ID: <YqMLeipEA4eEUD/3@kroah.com>
References: <1654311295-9700-1-git-send-email-quic_linyyuan@quicinc.com>
 <1654311295-9700-2-git-send-email-quic_linyyuan@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654311295-9700-2-git-send-email-quic_linyyuan@quicinc.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 04, 2022 at 10:54:54AM +0800, Linyu Yuan wrote:
> If a task read/write data in blocking mode, it will wait the completion
> in ffs_epfile_io(), if function unbind occurs, ffs_func_unbind() will
> kfree ffs ep, once the task wake up, it still dereference the ffs ep to
> obtain the request status.
> 
> Fix it by moving the request status to io_data which is stack-safe.
> 
> Cc: <stable@vger.kernel.org> # 5.15
> Reported-by: Michael Wu <michael@allwinnertech.com>
> Tested-by: Michael Wu <michael@allwinnertech.com>
> Reviewed-by: John Keeping <john@metanate.com>
> Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
> ---
> v2: correct interrupted assignment
> v3: add Reviewed-by and Reported-by
> v4: add Tetsed-by from Michael Wu,
>     remove one empty line
>     cc stable kernel
> 
>  drivers/usb/gadget/function/f_fs.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index 4585ee3..3958c60 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -122,8 +122,6 @@ struct ffs_ep {
>  	struct usb_endpoint_descriptor	*descs[3];
>  
>  	u8				num;
> -
> -	int				status;	/* P: epfile->mutex */
>  };
>  
>  struct ffs_epfile {
> @@ -227,6 +225,9 @@ struct ffs_io_data {
>  	bool use_sg;
>  
>  	struct ffs_data *ffs;
> +
> +	int status;
> +	struct completion done;
>  };
>  
>  struct ffs_desc_helper {
> @@ -707,12 +708,12 @@ static const struct file_operations ffs_ep0_operations = {
>  
>  static void ffs_epfile_io_complete(struct usb_ep *_ep, struct usb_request *req)
>  {
> +	struct ffs_io_data *io_data = req->context;
> +
>  	ENTER();
> -	if (req->context) {
> -		struct ffs_ep *ep = _ep->driver_data;
> -		ep->status = req->status ? req->status : req->actual;
> -		complete(req->context);
> -	}
> +
> +	io_data->status = req->status ? req->status : req->actual;

Please do not use ? : lines unless you have to.  Please write this as
normal if () lines.

thanks,

greg k-h
