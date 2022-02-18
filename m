Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73144BB4B5
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 09:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiBRI7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 03:59:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiBRI7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 03:59:54 -0500
Received: from web-bm.overkiz.com (web-bm.overkiz.com [92.222.103.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80C940910
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 00:59:36 -0800 (PST)
Received: from [192.168.1.59] (4.106.24.93.rev.sfr.net [93.24.106.4])
        (Authenticated sender: m.gardet@overkiz.com)
        by web-bm.overkiz.com (Postfix) with ESMTPSA id 6A1C01BF29E;
        Fri, 18 Feb 2022 09:59:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=overkiz.com;
        s=202003; t=1645174775;
        bh=dXEHoLFIAvkH1zkIoUGf2lU7wyOuC1RMiX1R00g7H6g=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=c92WARRd+GFIZG7fiiWD2+6k+9kP8mw+V+NivoK32oV16if6kzEwgqmn85ZaA0HNH
         pKlVMWf5RE1u+vxMZLmKBfbWI6L9VIEyH/xa7Hcn0+EZC8awh2NTXDjX5ykPxiLln3
         P/lDRN08Ul0SgeHVNBBLl4K01A16p7VVE/0cNDK5FcEsmwYKBVa4Nf+c+y6yl42ob1
         gUyd6OBGUhVEbgnoiMs4aDqlzNC7GFcUWX/RxqbCKrmoSpMLsP9ipjgko+vaV31BPS
         1VELhA5CbNnE/qtmGn6u6qvxcE2s3CG3fba/3oIYnVuUiUxbSfLn7lK62XpKkrxYnY
         1wbMnDehf4Otg==
Content-Type: multipart/mixed; boundary="------------CMS4S0HudF0DHP98Waqx01Mb"
Message-ID: <1ed07d2b-ab56-4b55-bb7d-e858e0f1cf92@overkiz.com>
Date:   Fri, 18 Feb 2022 09:59:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.0
Content-Language: fr
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        =?UTF-8?Q?K=c3=a9vin_Raymond?= <k.raymond@overkiz.com>,
        Tudor.Ambarus@microchip.com
References: <b8147153-5bcc-8a6d-7aac-5c0abbd43379@overkiz.com>
 <Yg9dAZI3hSbD9Epl@kroah.com>
From:   Mickael GARDET <m.gardet@overkiz.com>
Subject: Re: Atmel UART with dma enabled does not work on branch 5.4.Y from
 version 5.4.174.
In-Reply-To: <Yg9dAZI3hSbD9Epl@kroah.com>
X-Bm-Milter-Handled: f125012e-72d2-4729-b87c-a5ab9341072c
X-Bm-Transport-Timestamp: 1645174775599
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------CMS4S0HudF0DHP98Waqx01Mb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Yes sorry,

enclosed signed patch.


Le 18/02/2022 à 09:46, Greg KH a écrit :
> On Fri, Feb 18, 2022 at 09:40:55AM +0100, Mickael GARDET wrote:
>> Hi,
>>
>> we observed a regression on our atmel platforms on branch 5.4.Y from version
>> 5.4.174.
>> uarts are no longer functional if DMA is enabled.
>>
>> the following patch
>> Commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a dmaengine: at_xdmac: Start
>> transfer for cyclic channels in issue_pending
>> Link:
>> https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
>> has not been backported but is needed if the patch
>> Commit 4f4b9b5895614eb2e2b5f4cab7858f44bd113e1b tty: serial: atmel: Call
>> dma_async_issue_pending()
>> Link:
>> https://lore.kernel.org/r/20211125090028.786832-4-tudor.ambarus@microchip.com
>> is applied.
>>
>> enclosed commit fix this issue and work for me.
>>
>> Best regards,
>> Mickael GARDET
>>
>>  From 9877f93c066be8c2f4e33a6edd4dfa3d6d6974d9 Mon Sep 17 00:00:00 2001
>> From: Tudor Ambarus <tudor.ambarus@microchip.com>
>> Date: Wed, 15 Dec 2021 13:01:05 +0200
>> Subject: [PATCH] dmaengine: at_xdmac: Start transfer for cyclic channels in
>> issue_pending
>>
>> commit e6af9b05bec63cd4d1de2a33968cd0be2a91282a upstream.
>>
>> Cyclic channels must too call issue_pending in order to start a transfer.
>> Start the transfer in issue_pending regardless of the type of channel.
>> This wrongly worked before, because in the past the transfer was started
>> at tx_submit level when only a desc in the transfer list.
>>
>> Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended
>> DMA Controller driver")
>> Change-Id: If1bf3e13329cebb9904ae40620f6cf2b7f06fe9f
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>> Link:
>> https://lore.kernel.org/r/20211215110115.191749-3-tudor.ambarus@microchip.com
>> Signed-off-by: Vinod Koul <vkoul@kernel.org>
>> ---
>> drivers/dma/at_xdmac.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
>> index f63d141481a3..9aae6b3da356 100644
>> --- a/drivers/dma/at_xdmac.c
>> +++ b/drivers/dma/at_xdmac.c
>> @@ -1726,11 +1726,13 @@ static irqreturn_t at_xdmac_interrupt(int irq,
>> void *dev_id)
>> static void at_xdmac_issue_pending(struct dma_chan *chan)
>> {
>> struct at_xdmac_chan *atchan = to_at_xdmac_chan(chan);
>> +    unsigned long flags;
>>
>> dev_dbg(chan2dev(&atchan->chan), "%s\n", __func__);
>>
>> -    if (!at_xdmac_chan_is_cyclic(atchan))
>> -        at_xdmac_advance_work(atchan);
>> +    spin_lock_irqsave(&atchan->lock, flags);
>> +    at_xdmac_advance_work(atchan);
>> +    spin_unlock_irqrestore(&atchan->lock, flags);
>>
>> return;
>> }
>>
>> base-commit: 7b3eb66d0daf61e91cccdb2fe5d271ae5adc5a76
>>
>> -- 
>> 2.35.1
>>
> 
> The patch is whitespace damaged and can not be applied at all :(
> 
> Can you try fixing your email client up, or worst case, attach the
> patch, and we can take it from there?
> 
> Also be sure to sign-off on the patch, as you have modified it to work
> properly on this branch.
> 
> thanks,
> 
> greg k-h
--------------CMS4S0HudF0DHP98Waqx01Mb
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-dmaengine-at_xdmac-Start-transfer-for-cyclic-channel.patch"
Content-Disposition: attachment;
 filename*0="0001-dmaengine-at_xdmac-Start-transfer-for-cyclic-channel.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAxMzEwZjViYTJmMmQxOTllNjUyN2QyYTI4OTE5MmZmOTlkOGM2YzgzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBUdWRvciBBbWJhcnVzIDx0dWRvci5hbWJhcnVzQG1p
Y3JvY2hpcC5jb20+CkRhdGU6IFdlZCwgMTUgRGVjIDIwMjEgMTM6MDE6MDUgKzAyMDAKU3Vi
amVjdDogW1BBVENIXSBkbWFlbmdpbmU6IGF0X3hkbWFjOiBTdGFydCB0cmFuc2ZlciBmb3Ig
Y3ljbGljIGNoYW5uZWxzIGluCiBpc3N1ZV9wZW5kaW5nCgpjb21taXQgZTZhZjliMDViZWM2
M2NkNGQxZGUyYTMzOTY4Y2QwYmUyYTkxMjgyYSB1cHN0cmVhbS4KCkN5Y2xpYyBjaGFubmVs
cyBtdXN0IHRvbyBjYWxsIGlzc3VlX3BlbmRpbmcgaW4gb3JkZXIgdG8gc3RhcnQgYSB0cmFu
c2Zlci4KU3RhcnQgdGhlIHRyYW5zZmVyIGluIGlzc3VlX3BlbmRpbmcgcmVnYXJkbGVzcyBv
ZiB0aGUgdHlwZSBvZiBjaGFubmVsLgpUaGlzIHdyb25nbHkgd29ya2VkIGJlZm9yZSwgYmVj
YXVzZSBpbiB0aGUgcGFzdCB0aGUgdHJhbnNmZXIgd2FzIHN0YXJ0ZWQKYXQgdHhfc3VibWl0
IGxldmVsIHdoZW4gb25seSBhIGRlc2MgaW4gdGhlIHRyYW5zZmVyIGxpc3QuCgpGaXhlczog
ZTFmN2M5ZWVlNzA3ICgiZG1hZW5naW5lOiBhdF94ZG1hYzogY3JlYXRpb24gb2YgdGhlIGF0
bWVsIGVYdGVuZGVkIERNQSBDb250cm9sbGVyIGRyaXZlciIpCkNoYW5nZS1JZDogSWYxYmYz
ZTEzMzI5Y2ViYjk5MDRhZTQwNjIwZjZjZjJiN2YwNmZlOWYKU2lnbmVkLW9mZi1ieTogVHVk
b3IgQW1iYXJ1cyA8dHVkb3IuYW1iYXJ1c0BtaWNyb2NoaXAuY29tPgpMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9yLzIwMjExMjE1MTEwMTE1LjE5MTc0OS0zLXR1ZG9yLmFtYmFy
dXNAbWljcm9jaGlwLmNvbQpTaWduZWQtb2ZmLWJ5OiBWaW5vZCBLb3VsIDx2a291bEBrZXJu
ZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBNaWNrYWVsIEdBUkRFVCA8bS5nYXJkZXRAb3Zlcmtp
ei5jb20+Ci0tLQogZHJpdmVycy9kbWEvYXRfeGRtYWMuYyB8IDYgKysrKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZG1hL2F0X3hkbWFjLmMgYi9kcml2ZXJzL2RtYS9hdF94ZG1hYy5jCmluZGV4
IGY2M2QxNDE0ODFhMy4uOWFhZTZiM2RhMzU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL2RtYS9h
dF94ZG1hYy5jCisrKyBiL2RyaXZlcnMvZG1hL2F0X3hkbWFjLmMKQEAgLTE3MjYsMTEgKzE3
MjYsMTMgQEAgc3RhdGljIGlycXJldHVybl90IGF0X3hkbWFjX2ludGVycnVwdChpbnQgaXJx
LCB2b2lkICpkZXZfaWQpCiBzdGF0aWMgdm9pZCBhdF94ZG1hY19pc3N1ZV9wZW5kaW5nKHN0
cnVjdCBkbWFfY2hhbiAqY2hhbikKIHsKIAlzdHJ1Y3QgYXRfeGRtYWNfY2hhbiAqYXRjaGFu
ID0gdG9fYXRfeGRtYWNfY2hhbihjaGFuKTsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOwogCiAJ
ZGV2X2RiZyhjaGFuMmRldigmYXRjaGFuLT5jaGFuKSwgIiVzXG4iLCBfX2Z1bmNfXyk7CiAK
LQlpZiAoIWF0X3hkbWFjX2NoYW5faXNfY3ljbGljKGF0Y2hhbikpCi0JCWF0X3hkbWFjX2Fk
dmFuY2Vfd29yayhhdGNoYW4pOworCXNwaW5fbG9ja19pcnFzYXZlKCZhdGNoYW4tPmxvY2ss
IGZsYWdzKTsKKwlhdF94ZG1hY19hZHZhbmNlX3dvcmsoYXRjaGFuKTsKKwlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZhdGNoYW4tPmxvY2ssIGZsYWdzKTsKIAogCXJldHVybjsKIH0KLS0g
CjIuMzUuMQoK

--------------CMS4S0HudF0DHP98Waqx01Mb--
