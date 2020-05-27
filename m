Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903D71E3490
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 03:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgE0BQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 21:16:32 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57754 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgE0BQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 21:16:32 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04R1GUbm093022;
        Tue, 26 May 2020 20:16:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590542190;
        bh=YaLjPcSfIGjeXsxNRxJYxq5PIRurQHe+sHMb1HbpNqE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=D7QwxQvI4mWsmsEqjEAoTQozZj4ML/fZ6w9wuvRxqoH3WYQ7+PRgi2m9R9ypPzeuN
         smCNq/6pRllEq8X+20mADyFmNpoVN8IyGWjHECdzSV8NI+PMy/JxOV3C6VuqpyGXlH
         +/p2I0rp8lOHKe4Dhxs6w6kvhL6XTeUiCsB/I3Vw=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04R1GU96045204;
        Tue, 26 May 2020 20:16:30 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 20:16:30 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 20:16:30 -0500
Received: from [10.250.38.163] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04R1GTSS001014;
        Tue, 26 May 2020 20:16:29 -0500
Subject: Re: [RFC] power: supply: bq27xxx_battery: Fix polling interval after
 re-bind
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>
References: <20200525113220.369-1-krzk@kernel.org>
From:   "Andrew F. Davis" <afd@ti.com>
Message-ID: <65ccf383-85a3-3ccd-f38c-e92ddae8fe1e@ti.com>
Date:   Tue, 26 May 2020 21:16:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525113220.369-1-krzk@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/25/20 7:32 AM, Krzysztof Kozlowski wrote:
> This reverts commit 8cfaaa811894a3ae2d7360a15a6cfccff3ebc7db.
> 
> If device was unbound and bound, the polling interval would be set to 0.
> This is both unexpected and messes up with other bq27xxx devices (if
> more than one battery device is used).
> 
> This reset of polling interval was added in commit 8cfaaa811894
> ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> stating that power_supply_unregister() calls get_property().  However in
> Linux kernel v3.1 and newer, such call trace does not exist.
> Unregistering power supply does not call get_property() on unregistered
> power supply.
> 
> Fixes: 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00 driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> I really could not identify the issue being fixed in offending commit
> 8cfaaa811894 ("bq27x00_battery: Fix OOPS caused by unregistring bq27x00
> driver"), therefore maybe I missed here something important.
> 
> Please share your thoughts on this.


I'm having a hard time finding the OOPS also. Maybe there is a window
where the poll function is running or about to run where
cancel_delayed_work_sync() is called and cancels the work, only to have
an interrupt or late get_property call in to the poll function and
re-schedule it.

What we really need is to do is look at how we are handling the polling
function. It gets called from the workqueue, from a threaded interrupt
context, and from a power supply framework callback, possibly all at the
same time. Sometimes its protected by a lock, sometimes not. Updating
the device's cached data should always be locked.

What's more is the poll function is self-arming, so if we call
cancel_delayed_work_sync() (remove it from the work queue then then wait
for it to finish if running), are we sure it wont have just re-arm itself?

We should make the only way we call the poll function be through the
work queue, (plus make sure all accesses to the cache are locked).

Andrew


> ---
>  drivers/power/supply/bq27xxx_battery.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
> index 942c92127b6d..4c94ee72de95 100644
> --- a/drivers/power/supply/bq27xxx_battery.c
> +++ b/drivers/power/supply/bq27xxx_battery.c
> @@ -1905,14 +1905,6 @@ EXPORT_SYMBOL_GPL(bq27xxx_battery_setup);
>  
>  void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
>  {
> -	/*
> -	 * power_supply_unregister call bq27xxx_battery_get_property which
> -	 * call bq27xxx_battery_poll.
> -	 * Make sure that bq27xxx_battery_poll will not call
> -	 * schedule_delayed_work again after unregister (which cause OOPS).
> -	 */
> -	poll_interval = 0;
> -
>  	cancel_delayed_work_sync(&di->work);
>  
>  	power_supply_unregister(di->bat);
> 
