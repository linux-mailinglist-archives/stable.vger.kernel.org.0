Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6162F4FF
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 13:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbiKRMg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 07:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241758AbiKRMgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 07:36:11 -0500
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Nov 2022 04:35:48 PST
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBDAB8FFA1;
        Fri, 18 Nov 2022 04:35:47 -0800 (PST)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 6E04124065;
        Fri, 18 Nov 2022 13:29:03 +0100 (CET)
Message-ID: <53dde473-2e88-7f51-7417-fce3a73fb8c8@gmail.com>
Date:   Fri, 18 Nov 2022 13:29:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Content-Language: en-US
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Ferry Toth <ftoth@exalondelft.nl>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
 <20221117205411.11489-3-ftoth@exalondelft.nl>
 <20221118021107.3uhixtck6sawluoy@synopsys.com>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <20221118021107.3uhixtck6sawluoy@synopsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18-11-2022 03:11, Thinh Nguyen wrote:
> On Thu, Nov 17, 2022, Ferry Toth wrote:
>> Since commit 0f010171
> I don't your update as noted in the v3 change (ie. Greg's suggestions).

Indeed. I seem to have sent in the wrong sha. Sorry about this.

>> Dual Role support on Intel Merrifield platform broke due to rearranging
>> the call to dwc3_get_extcon().
>>
>> It appears to be caused by ulpi_read_id() masking the timeout on the first
>> test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
>> followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
>> On deferred probe ulpi_read_id() finally succeeded.
>>
>> As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
>> need to handle the error by calling dwc3_core_soft_reset() and request
>> -EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.
>>
>> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
>> ---
>>   drivers/usb/dwc3/core.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 648f1c570021..2779f17bffaf 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -1106,8 +1106,13 @@ static int dwc3_core_init(struct dwc3 *dwc)
>>   
>>   	if (!dwc->ulpi_ready) {
>>   		ret = dwc3_core_ulpi_init(dwc);
>> -		if (ret)
>> +		if (ret) {
>> +			if (ret == -ETIMEDOUT) {
>> +				dwc3_core_soft_reset(dwc);
> I'm not sure if you saw my previous response. I wanted to check to see
> if we need to do soft-reset once before ulpi init as part of its
> initialization.
I missed it but found it now. I will try your suggestion and answer.
> I'm just curious why Andrey Smirnov test doesn't require this change. If
> it's a quirk for this specific configuration, then the change here is
> fine. If it's required for all ULPI setup, then we can unconditionally
> do that for all ULPI setup during initialization.

Yes me too. I can reproduce that when I build kernel and rootfs with 
buildroot there is no issue. But as soon as I add ftrace / bootconfig 
the issue appears and then I can't analyze the flow. It's seems some 
kind of timing / race.

However, I have tried deferring without dwc3_core_soft_reset() (to 
verify if it is just a matter of time) and that doesn't work. dwc3 is 
deferred about 10x and then gives up without phy. So, it's not just the 
time and not just a matter of retrying the test write.

>> +				ret = -EPROBE_DEFER;
>> +			}
>>   			goto err0;
>> +		}
>>   		dwc->ulpi_ready = true;
>>   	}
>>   
>> -- 
>> 2.37.2
>>
> Thanks,
> Thinh
