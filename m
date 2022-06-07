Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BAD54042D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbiFGQ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 12:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345273AbiFGQ4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 12:56:51 -0400
X-Greylist: delayed 395 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jun 2022 09:56:48 PDT
Received: from smtp92.iad3a.emailsrvr.com (smtp92.iad3a.emailsrvr.com [173.203.187.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ADE1021E1
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1654620613;
        bh=G3y0N4OKbPtDPijdqDkBNVn3xPy9cD0B7C2rHkIiM+E=;
        h=Date:Subject:To:From:From;
        b=XXbzMLjVGQviW+qSIPQKtKL8BMtjBFTN/Q9NEZdcTmPITH9+Ur3r64wUm918anPz7
         oenbeqpsru+C+6q/il0+dkZPJUMO1SrVVxR7CBGypqEWeyIOS/lUu6D+u+R3LpYNZQ
         LtVO9RN+zShzOMg9VkgXgoXKtt1YXPlQ39zQAerU=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp12.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 974E125007;
        Tue,  7 Jun 2022 12:50:12 -0400 (EDT)
Message-ID: <d2696256-639b-4b20-3612-6dcfe68313a1@mev.co.uk>
Date:   Tue, 7 Jun 2022 17:50:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] comedi: vmk80xx: fix expression for tx buffer size
Content-Language: en-GB
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
References: <20220606105237.13937-1-abbotti@mev.co.uk>
 <Yp95+QKSqeH5AG0a@hovoldconsulting.com>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
In-Reply-To: <Yp95+QKSqeH5AG0a@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: ceb2d575-4980-4a92-8241-c2e47c699594-1-1
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/06/2022 17:16, Johan Hovold wrote:
> On Mon, Jun 06, 2022 at 11:52:37AM +0100, Ian Abbott wrote:
>> The expression for setting the size of the allocated bulk TX buffer
>> (`devpriv->usb_tx_buf`) is calling `usb_endpoint_maxp(devpriv->ep_rx)`,
>> which is using the wrong endpoint (should be `devpriv->ep_tx`).  Fix it.
> 
> Bah. Good catch.
> 
>> Fixes: a23461c47482 ("comedi: vmk80xx: fix transfer-buffer overflow")
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: stable@vger.kernel.org # 5.10, 5.15+
> 
> I believe this one is needed in all stable trees (e.g. 4.9+).

True.  I didn't think the patch it fixes had been applied yet, but I 
didn't look hard enough.  I'll send a v2 with amended Cc line.

> 
>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>> ---
>>   drivers/comedi/drivers/vmk80xx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/comedi/drivers/vmk80xx.c b/drivers/comedi/drivers/vmk80xx.c
>> index 46023adc5395..4536ed43f65b 100644
>> --- a/drivers/comedi/drivers/vmk80xx.c
>> +++ b/drivers/comedi/drivers/vmk80xx.c
>> @@ -684,7 +684,7 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
>>   	if (!devpriv->usb_rx_buf)
>>   		return -ENOMEM;
>>   
>> -	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
>> +	size = max(usb_endpoint_maxp(devpriv->ep_tx), MIN_BUF_SIZE);
>>   	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
>>   	if (!devpriv->usb_tx_buf)
>>   		return -ENOMEM;
> 
> Looks good otherwise:
> 
> Reviewed-by: Johan Hovold <johan@kernel.org>

Thanks for the review!

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
