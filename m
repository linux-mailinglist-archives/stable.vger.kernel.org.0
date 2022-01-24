Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57814982AB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbiAXOpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:45:52 -0500
Received: from mx-out.tlen.pl ([193.222.135.148]:52367 "EHLO mx-out.tlen.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbiAXOpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 09:45:51 -0500
Received: (wp-smtpd smtp.tlen.pl 9594 invoked from network); 24 Jan 2022 15:45:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1643035541; bh=NiCcjtdMw4VE8zgmw8NOSIaxgS0lQTmC8aqWQWez6Nw=;
          h=Subject:To:Cc:From;
          b=INHrFSK/z0tM4qcycRf1zRDgUAyVFoCuMcc00gJ84PYllBpUBSNW6moypEeCssPkd
           jxcca9t5GyQDdaCyAWXLQjAfP1GdZVl9J0obo6KwZ7iO2mp7WEyyYtDsMX65EzGq29
           81T9wk9ffl5xA7VS9YveUT9xUMvpO2oNhSRUCbv4=
Received: from aafh166.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.137.166])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <gregkh@linuxfoundation.org>; 24 Jan 2022 15:45:41 +0100
Message-ID: <df1a2547-c863-f416-58c9-4f64cce1f522@o2.pl>
Date:   Mon, 24 Jan 2022 15:45:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: FAILED: patch "[PATCH] rtc: mc146818-lib: fix RTC presence check"
 failed to apply to 5.16-stable tree
Content-Language: en-GB
To:     gregkh@linuxfoundation.org, a.zummo@towertech.it,
        alexandre.belloni@bootlin.com, tglx@linutronix.de
Cc:     stable@vger.kernel.org
References: <164302970310788@kroah.com>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <164302970310788@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: a9c0df7d77079e4a01724d23782a94bc
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [gaPE]                               
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W dniu 24.01.2022 o 14:08, gregkh@linuxfoundation.org pisze:
> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
Wait, this patch was not intended for submission into stable yet, at least not in this form.
Why did it end up in the stable queue?

The return values from mc146818_get_time() changed in between,
so it is natural that it does not apply.

See
commit d35786b3a28dee20 ("rtc: mc146818-lib: change return values of mc146818_get_time()")

Greetings,
Mateusz Jończyk
> ------------------ original commit in Linus's tree ------------------
>
> >From ea6fa4961aab8f90a8aa03575a98b4bda368d4b6 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
> Date: Fri, 10 Dec 2021 21:01:26 +0100
> Subject: [PATCH] rtc: mc146818-lib: fix RTC presence check
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> To prevent an infinite loop in mc146818_get_time(),
> commit 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
> added a check for RTC availability. Together with a later fix, it
> checked if bit 6 in register 0x0d is cleared.
>
> This, however, caused a false negative on a motherboard with an AMD
> SB710 southbridge; according to the specification [1], bit 6 of register
> 0x0d of this chipset is a scratchbit. This caused a regression in Linux
> 5.11 - the RTC was determined broken by the kernel and not used by
> rtc-cmos.c [3]. This problem was also reported in Fedora [4].
>
> As a better alternative, check whether the UIP ("Update-in-progress")
> bit is set for longer then 10ms. If that is the case, then apparently
> the RTC is either absent (and all register reads return 0xff) or broken.
> Also limit the number of loop iterations in mc146818_get_time() to 10 to
> prevent an infinite loop there.
>
> The functions mc146818_get_time() and mc146818_does_rtc_work() will be
> refactored later in this patch series, in order to fix a separate
> problem with reading / setting the RTC alarm time. This is done so to
> avoid a confusion about what is being fixed when.
>
> In a previous approach to this problem, I implemented a check whether
> the RTC_HOURS register contains a value <= 24. This, however, sometimes
> did not work correctly on my Intel Kaby Lake laptop. According to
> Intel's documentation [2], "the time and date RAM locations (0-9) are
> disconnected from the external bus" during the update cycle so reading
> this register without checking the UIP bit is incorrect.
>
> [1] AMD SB700/710/750 Register Reference Guide, page 308,
> https://developer.amd.com/wordpress/media/2012/10/43009_sb7xx_rrg_pub_1.00.pdf
>
> [2] 7th Generation Intel ® Processor Family I/O for U/Y Platforms [...] Datasheet
> Volume 1 of 2, page 209
> Intel's Document Number: 334658-006,
> https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/7th-and-8th-gen-core-family-mobile-u-y-processor-lines-i-o-datasheet-vol-1.pdf
>
> [3] Functions in arch/x86/kernel/rtc.c apparently were using it.
>
> [4] https://bugzilla.redhat.com/show_bug.cgi?id=1936688
>
> Fixes: 211e5db19d15 ("rtc: mc146818: Detect and handle broken RTCs")
> Fixes: ebb22a059436 ("rtc: mc146818: Dont test for bit 0-5 in Register D")
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Link: https://lore.kernel.org/r/20211210200131.153887-5-mat.jonczyk@o2.pl
>
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index d0f58cca5c20..b90a603d6b12 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -800,16 +800,14 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
>  
>  	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
>  
> -	spin_lock_irq(&rtc_lock);
> -
> -	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
> -	if ((CMOS_READ(RTC_VALID) & 0x40) != 0) {
> -		spin_unlock_irq(&rtc_lock);
> -		dev_warn(dev, "not accessible\n");
> +	if (!mc146818_does_rtc_work()) {
> +		dev_warn(dev, "broken or not accessible\n");
>  		retval = -ENXIO;
>  		goto cleanup1;
>  	}
>  
> +	spin_lock_irq(&rtc_lock);
> +
>  	if (!(flags & CMOS_RTC_FLAGS_NOFREQ)) {
>  		/* force periodic irq to CMOS reset default of 1024Hz;
>  		 *
> diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
> index ccd974b8a75a..d8e67a01220e 100644
> --- a/drivers/rtc/rtc-mc146818-lib.c
> +++ b/drivers/rtc/rtc-mc146818-lib.c
> @@ -8,10 +8,36 @@
>  #include <linux/acpi.h>
>  #endif
>  
> +/*
> + * If the UIP (Update-in-progress) bit of the RTC is set for more then
> + * 10ms, the RTC is apparently broken or not present.
> + */
> +bool mc146818_does_rtc_work(void)
> +{
> +	int i;
> +	unsigned char val;
> +	unsigned long flags;
> +
> +	for (i = 0; i < 10; i++) {
> +		spin_lock_irqsave(&rtc_lock, flags);
> +		val = CMOS_READ(RTC_FREQ_SELECT);
> +		spin_unlock_irqrestore(&rtc_lock, flags);
> +
> +		if ((val & RTC_UIP) == 0)
> +			return true;
> +
> +		mdelay(1);
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
> +
>  unsigned int mc146818_get_time(struct rtc_time *time)
>  {
>  	unsigned char ctrl;
>  	unsigned long flags;
> +	unsigned int iter_count = 0;
>  	unsigned char century = 0;
>  	bool retry;
>  
> @@ -20,13 +46,13 @@ unsigned int mc146818_get_time(struct rtc_time *time)
>  #endif
>  
>  again:
> -	spin_lock_irqsave(&rtc_lock, flags);
> -	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
> -	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
> -		spin_unlock_irqrestore(&rtc_lock, flags);
> +	if (iter_count > 10) {
>  		memset(time, 0, sizeof(*time));
>  		return -EIO;
>  	}
> +	iter_count++;
> +
> +	spin_lock_irqsave(&rtc_lock, flags);
>  
>  	/*
>  	 * Check whether there is an update in progress during which the
> diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
> index 0661af17a758..69c80c4325bf 100644
> --- a/include/linux/mc146818rtc.h
> +++ b/include/linux/mc146818rtc.h
> @@ -123,6 +123,7 @@ struct cmos_rtc_board_info {
>  #define RTC_IO_EXTENT_USED      RTC_IO_EXTENT
>  #endif /* ARCH_RTC_LOCATION */
>  
> +bool mc146818_does_rtc_work(void);
>  unsigned int mc146818_get_time(struct rtc_time *time);
>  int mc146818_set_time(struct rtc_time *time);
>  
>

