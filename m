Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA51519BB28
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 06:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgDBEkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 00:40:47 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:16632 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgDBEkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 00:40:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585802447; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Lz/im469WIpyD4xx+SFO8X6KLpxB3mpYk3mSqPNHaxA=; b=cRrNza7fn47YOmAd3oCAmzafdQKs6TsI5ctjbaUmXoW+oaPWfscoqOxP7h19gPw/P8W3fRl7
 XQ8PEi0h++OfsPdrFtiUJ87Lujnwy/5j+MYC+Bu5TDTlLYPO+SyE4GOOTZvvHg1dNmDdsySy
 Fkl7LdaS7jWpamCA71D8PfjM0VE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e856cbd.7f08b7daeed8-smtp-out-n03;
 Thu, 02 Apr 2020 04:40:29 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9140DC433D2; Thu,  2 Apr 2020 04:40:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [10.111.194.152] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mgautam)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4C7DC433F2;
        Thu,  2 Apr 2020 04:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4C7DC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=mgautam@codeaurora.org
Subject: Re: [PATCH] usb: f_fs: Clear OS Extended descriptor counts to zero in
 ffs_data_reset()
To:     Sriharsha Allenki <sallenki@codeaurora.org>, balbi@kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        ugoswami@codeaurora.org
Cc:     jackp@codeaurora.org, stable@vger.kernel.org
References: <20200402043210.2342-1-sallenki@codeaurora.org>
From:   Manu Gautam <mgautam@codeaurora.org>
Message-ID: <1040af70-2298-df80-614d-a4d3cf6cca57@codeaurora.org>
Date:   Thu, 2 Apr 2020 10:10:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200402043210.2342-1-sallenki@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 4/2/2020 10:02 AM, Sriharsha Allenki wrote:
> From: Udipto Goswami <ugoswami@codeaurora.org>
>
> For userspace functions using OS Descriptors, if a function also supplies
> Extended Property descriptors currently the counts and lengths stored in
> the ms_os_descs_ext_prop_{count,name_len,data_len} variables are not
> getting reset to 0 during an unbind or when the epfiles are closed. If
> the same function is re-bound and the descriptors are re-written, this
> results in those count/length variables to monotonically increase
> causing the VLA allocation in _ffs_func_bind() to grow larger and larger
> at each bind/unbind cycle and eventually fail to allocate.
>
> Fix this by clearing the ms_os_descs_ext_prop count & lengths to 0 in
> ffs_data_reset().
>
> Change-Id: I3b292fe5386ab54b53df2b9f15f07430dc3df24a
Please remove this.
> Fixes: f0175ab51993 ("usb: gadget: f_fs: OS descriptors support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Udipto Goswami <ugoswami@codeaurora.org>
> Signed-off-by: Sriharsha Allenki <sallenki@codeaurora.org>
> ---
>  drivers/usb/gadget/function/f_fs.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
> index c81023b195c3..10f01f974f67 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -1813,6 +1813,10 @@ static void ffs_data_reset(struct ffs_data *ffs)
>  	ffs->state = FFS_READ_DESCRIPTORS;
>  	ffs->setup_state = FFS_NO_SETUP;
>  	ffs->flags = 0;
> +
> +	ffs->ms_os_descs_ext_prop_count = 0;
> +	ffs->ms_os_descs_ext_prop_name_len = 0;
> +	ffs->ms_os_descs_ext_prop_data_len = 0;
>  }
>  
>  

Reviewed-by: Manu Gautam <mgautam@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
