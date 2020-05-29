Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8511E7B35
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 13:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgE2LGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 07:06:13 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:55513 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgE2LGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 07:06:12 -0400
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ecpyjcKFtdPgTecq1jD6Rt; Fri, 29 May 2020 13:06:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1590750370; bh=iZ3HHdYqUSDZBJAdKsd/Ncf4TLqe2ptx0GPv4iwoMuM=;
        h=Subject:From:To:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=Z8RTndI8ZXoXj7FlVD12qVFYd5op7FsRPXvCacp14tP/mXn6t0bPZj3/2cgkZ7K2Q
         wdRgy4xwYrxxSkAf6PyVGP8gXCaA1Y5VixrBCcnDGcdBYIfxOUXuY1fcJB19+UjNWe
         2eNzyW/b8IXOaXyocg2xi1uhen1T1KAGcL05YA6gdKRnCSCLxr0vYYhpV+HUxQ9T6l
         NnFHnRFgH/UWEc1ut4j2FxXWxQsbi5A6/y7KXsiX3TyNs9TSbJdU/tuyCAwWdX0f5q
         lUk1Jmd2RvjYNkor8CLz4s+7uK7YUeC3Z1NDRoQKsDMIOvwyNZnBmLmHKzeGGsj15e
         GF6CpkibCsMdg==
Subject: Re: [PATCH] gpio: fix locking open drain IRQ lines
From:   Hans Verkuil <hverkuil@xs4all.nl>
To:     Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org
References: <20200527140758.162280-1-linus.walleij@linaro.org>
 <79d89e93-4e40-089c-606d-e7787013bc80@xs4all.nl>
Message-ID: <3965eb9a-d3ea-2844-68a1-57f88ff9f8b4@xs4all.nl>
Date:   Fri, 29 May 2020 13:06:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <79d89e93-4e40-089c-606d-e7787013bc80@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfD04Efs4R1t+Nz2SB0FA2A4xUm7RxHv6qT0hbAfyjORxpLoK1d2y5AlZiTPsgnh9UlwV8/PZn7ls5U+E3OX4ANOZVHpppQzhRtG80zl/AS1QlcFGv7gV
 KZTTp1af8wr7G5yJxRJR8h26B28JgRrkwekJdIWC8RVAK4igHb0dQ9lVM29BcEpCMlj5q25sAcxGo5radpkz/Js/fbf1hh5LC8flhuGpfdqbddH59MD/MlIM
 9L6VsJW07uA9x48ZFDm1JEwdYtQI/3JQO42ZDXoApraC6Vus7rl5zkHcggDw8fvAR4gf8r2TXxj+NBqao0zdMg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/05/2020 14:24, Hans Verkuil wrote:
> On 27/05/2020 16:07, Linus Walleij wrote:
>> We provided the right semantics on open drain lines being
>> by definition output but incidentally the irq set up function
>> would only allow IRQs on lines that were "not output".
>>
>> Fix the semantics to allow output open drain lines to be used
>> for IRQs.
>>
>> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Tested-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Whether this is the right/best fix or not, I cannot tell, but it certainly
> fixes the cec-gpio driver!

Close, but no cigar. I didn't check the kernel log and I now see this warning:

[    4.157000] ------------[ cut here ]------------
[    4.161699] WARNING: CPU: 0 PID: 1 at drivers/gpio/gpiolib.c:4260 gpiochip_enable_irq+0x6c/0x78
[    4.170522] Modules linked in:
[    4.173626] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.7.0-rc2-rpi3 #179
[    4.180510] Hardware name: Raspberry Pi 3 Model B (DT)
[    4.185724] pstate: 80000085 (Nzcv daIf -PAN -UAO)
[    4.190585] pc : gpiochip_enable_irq+0x6c/0x78
[    4.195094] lr : gpiochip_irq_enable+0x20/0x58
[    4.199597] sp : ffff8000100239e0
[    4.202956] x29: ffff8000100239e0 x28: 0000000000000000
[    4.208346] x27: ffff0000042b9808 x26: ffff00000425eca4
[    4.213735] x25: 0000000000000000 x24: ffff00000425ed58
[    4.219124] x23: 0000000000000000 x22: 0000000000000000
[    4.224512] x21: 0000000000000001 x20: ffff0000041d1b00
[    4.229902] x19: ffff00000425ec00 x18: 0000000000000000
[    4.235291] x17: ffff8000107ddce0 x16: ffff8000107dd1b8
[    4.240680] x15: ffff000037870450 x14: ffffffffffffffff
[    4.246070] x13: ffff0000041d1a87 x12: ffff0000041d1a85
[    4.251459] x11: 0000000000000000 x10: 0000000000000040
[    4.256848] x9 : 0000000000000000 x8 : 0000000000000080
[    4.262237] x7 : 0000000000000000 x6 : 000000000000003f
[    4.267626] x5 : 0000000000000000 x4 : ffff0000372d3990
[    4.273014] x3 : ffff00000425ec28 x2 : 0000000000000036
[    4.278403] x1 : ffff0000372d40e0 x0 : 0000000000000683
[    4.283793] Call trace:
[    4.286274]  gpiochip_enable_irq+0x6c/0x78
[    4.290432]  irq_enable+0x3c/0x80
[    4.293795]  __irq_startup+0x7c/0xa8
[    4.297419]  irq_startup+0x5c/0x138
[    4.300957]  __setup_irq+0x82c/0x8f8
[    4.304583]  request_threaded_irq+0xd8/0x198
[    4.308913]  devm_request_threaded_irq+0x78/0xf8
[    4.313599]  cec_gpio_probe+0x118/0x288
[    4.317490]  platform_drv_probe+0x54/0xb0
[    4.321558]  really_probe+0xd8/0x330
[    4.325184]  driver_probe_device+0x58/0xf8
[    4.329339]  device_driver_attach+0x74/0x80
[    4.333582]  __driver_attach+0x58/0xe0
[    4.337383]  bus_for_each_dev+0x70/0xc0
[    4.341273]  driver_attach+0x24/0x30
[    4.344899]  bus_add_driver+0x150/0x1e0
[    4.348789]  driver_register+0x64/0x128
[    4.352678]  __platform_driver_register+0x48/0x58
[    4.357452]  cec_gpio_pdrv_init+0x1c/0x28
[    4.361519]  do_one_initcall+0x54/0x1b8
[    4.365412]  kernel_init_freeable+0x1cc/0x244
[    4.369833]  kernel_init+0x14/0x108
[    4.373371]  ret_from_fork+0x10/0x1c
[    4.377000] ---[ end trace 49bf91ba04222a1a ]---
[    4.382253] Registered IR keymap rc-cec
[    4.386344] rc rc0: cec-gpio@7 as /devices/platform/cec-gpio@7/rc/rc0
[    4.393135] input: cec-gpio@7 as /devices/platform/cec-gpio@7/rc/rc0/input0

The fix seems to be to just add this change to the patch:

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 40f2d7f69be2..5a8214d5e927 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4255,7 +4257,8 @@ void gpiochip_enable_irq(struct gpio_chip *gc, unsigned int offset)

 	if (!IS_ERR(desc) &&
 	    !WARN_ON(!test_bit(FLAG_USED_AS_IRQ, &desc->flags))) {
-		WARN_ON(test_bit(FLAG_IS_OUT, &desc->flags));
+		WARN_ON(test_bit(FLAG_IS_OUT, &desc->flags) &&
+			!test_bit(FLAG_OPEN_DRAIN, &desc->flags));
 		set_bit(FLAG_IRQ_IS_ENABLED, &desc->flags);
 	}
 }

I wish I could test this on the BeagleBone Black, which is the other use-case,
but it's in another country and the earliest I can test is probably August or
September (depending on how long the travel restrictions stay in place).

If someone else has a BBB handy, then it would be nice if this patch can be
tested.

Regards,

	Hans


> 
> Regards,
> 
> 	Hans
> 
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: stable@vger.kernel.org
>> Fixes: 256efaea1fdc ("gpiolib: fix up emulated open drain outputs")
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>  drivers/gpio/gpiolib.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index b4b5792fe2ff..edd74ff31cea 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -4220,7 +4220,9 @@ int gpiochip_lock_as_irq(struct gpio_chip *gc, unsigned int offset)
>>  		}
>>  	}
>>  
>> -	if (test_bit(FLAG_IS_OUT, &desc->flags)) {
>> +	/* To be valid for IRQ the line needs to be input or open drain */
>> +	if (test_bit(FLAG_IS_OUT, &desc->flags) &&
>> +	    !test_bit(FLAG_OPEN_DRAIN, &desc->flags)) {
>>  		chip_err(gc,
>>  			 "%s: tried to flag a GPIO set as output for IRQ\n",
>>  			 __func__);
>>
> 

