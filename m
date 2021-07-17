Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093F43CC66C
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 23:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhGQVGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 17:06:24 -0400
Received: from mx-out.tlen.pl ([193.222.135.142]:7177 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233666AbhGQVGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 17:06:24 -0400
Received: (wp-smtpd smtp.tlen.pl 5205 invoked from network); 17 Jul 2021 23:03:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1626555805; bh=FE1IwLYa5+z5yzmsIhR39LquL2tIsRR2uaObII7BvVA=;
          h=Subject:To:Cc:From;
          b=ygOC+NOc0hGQ7EG6Nh3G74srrnc/sZW0C2/oQc642pfg9Y736/CRwAmqPfa9Il487
           ktp8jjeqCTWatv0+93BmaJAQ22NSowkEujj8tEmrUMZ4AKPoCD2sNNlmS8z7who+3T
           GjmJ4RODcNTR2J4womW73lpjzGO1WwI0y1873klA=
Received: from aaff143.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.135.143])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <linux-rtc@vger.kernel.org>; 17 Jul 2021 23:03:24 +0200
Message-ID: <6357c8f3-e2b0-052e-0382-b5ed093a4bfa@o2.pl>
Date:   Sat, 17 Jul 2021 23:03:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [PATCH] rtc: mc146818: Use hours for checking RTC availability
Content-Language: en-GB
To:     linux-rtc@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        stable@vger.kernel.org
References: <113c6933-28c8-91cf-f802-5a38417da749@o2.pl>
 <20210707213844.115181-1-mat.jonczyk@o2.pl>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <20210707213844.115181-1-mat.jonczyk@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: dfe76dec5e23ce83d35340ea05206901
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [YVNE]                               
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
Please do not apply this patch, it causes trouble on my Intel Kaby Lake laptop.
(see below).

W dniu 07.07.2021 o 23:38, Mateusz Jończyk pisze:
> To prevent an infinite loop, it is necessary to ascertain the RTC is
> present. Previous code was checking if bit 6 in register 0x0D is
> cleared. This caused a false negative on a motherboard with an AMD SB710
> southbridge; according to the specification [1], bit 6 of register 0x0D
> on this chipset is a scratchbit.
>
> Use the RTC_HOURS register instead, which is expected to contain a value
> not larger then 24, in BCD format.
>
> Caveat: when I was playing with
>         while true; do cat /sys/class/rtc/rtc0/time; done
> I sometimes triggered this mechanism on my HP laptop. It appears that
> CMOS_READ(RTC_VALID) was sometimes reading the number of seconds from
> previous loop iteration. This happens very rarely, though, and this patch
> does not make it any more likely.

According to Intel's documentation [2]:

    The update cycle [of CMOS RTC registers, which happens every second]
    will start at least 488 μs after the UIP bit of register A is asserted, and
    the entire cycle does not take more than 1984 μs to complete. The time and date RAM
    locations (0–9) are disconnected from the external bus during this time.

Therefore, trying to access the RTC_HOURS register during the update time
is undefined behavior. In my tests, it frequently returned values from the
wrong register, such as the seconds or minutes register instead of the hours
register and the values failed the "< 24" comparison.

Indeed, the wrong readouts happen when the UIP bit is set.

I was not aware of this and blamed my firmware for accessing the RTC clock independently.


BTW, cmos_set_alarm() in drivers/rtc/rtc-cmos.c does not check for UIP bit.
As it writes to registers in the 0-9 range, it may fail to set the alarm time.

Greetings,

Mateusz

[2] 7th Generation Intel® Processor Family I/O for U/Y Platforms [...] Datasheet – Volume 1 of 2,
page 209
Intel's Document Number: 334658-006,
https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/7th-and-8th-gen-core-family-mobile-u-y-processor-lines-i-o-datasheet-vol-1.pdf

> [1] AMD SB700/710/750 Register Reference Guide, page 308,
> https://developer.amd.com/wordpress/media/2012/10/43009_sb7xx_rrg_pub_1.00.pdf
>
> Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
> Fixes: ebb22a059436 ("rtc: mc146818: Dont test for bit 0-5 in Register D")
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/rtc/rtc-cmos.c         |  6 +++---
>  drivers/rtc/rtc-mc146818-lib.c | 10 ++++++++--
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 670fd8a2970e..b0102fb31b3f 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -798,10 +798,10 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
>  
>  	spin_lock_irq(&rtc_lock);
>  
> -	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
> -	if ((CMOS_READ(RTC_VALID) & 0x40) != 0) {
> +	/* Ensure that the RTC is accessible (RTC_HOURS is in BCD format) */
> +	if (CMOS_READ(RTC_HOURS) > 0x24) {
>  		spin_unlock_irq(&rtc_lock);
> -		dev_warn(dev, "not accessible\n");
> +		dev_warn(dev, "not accessible or not working correctly\n");
>  		retval = -ENXIO;
>  		goto cleanup1;
>  	}
> diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
> index dcfaf09946ee..1d69c3c13257 100644
> --- a/drivers/rtc/rtc-mc146818-lib.c
> +++ b/drivers/rtc/rtc-mc146818-lib.c
> @@ -21,9 +21,15 @@ unsigned int mc146818_get_time(struct rtc_time *time)
>  
>  again:
>  	spin_lock_irqsave(&rtc_lock, flags);
> -	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
> -	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
> +
> +	/*
> +	 * Ensure that the RTC is accessible, to avoid an infinite loop.
> +	 * RTC_HOURS is in BCD format.
> +	 */
> +	if (CMOS_READ(RTC_HOURS) > 0x24) {
>  		spin_unlock_irqrestore(&rtc_lock, flags);
> +		pr_warn_once("Real-time clock is not accessible or not "
> +				"working correctly\n");
>  		memset(time, 0xff, sizeof(*time));
>  		return 0;
>  	}


