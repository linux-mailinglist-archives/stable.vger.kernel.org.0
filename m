Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1055239FAB
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgHCGht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 02:37:49 -0400
Received: from www381.your-server.de ([78.46.137.84]:48910 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCGht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 02:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
         s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=62c/AjnRcHAoMlQa6MQpji2BM/UTp2G50U2aDfeBM8A=; b=aa6ftx51qgvzJmq9sIAulebFuc
        0AgcDvkq4RyNI5bGQVSmVYp5xhXmQ8uxhZz/FQ5xJJcqA1ZpRBP4mP98G+BRd/ANY8XCEf1UcKrKY
        gYb8dB9l5v+1q9sf6ZcuF9tov7ZzRy6MF8yysiNFsJhs24GTbfRtgQeLaI+EyR9jzO/k6L+rBPYsa
        vE+BLDxXs7n+Pssbod+GRBqQgK6O+aC8U+ZNiOprN1MlVpxy3mhd12Q6ukDZR27jZFVONjczTC1Td
        yXONBcSR+UzmkekU1rvslB64VPogW4ue/TlU/H3aDUm/k9tAb4RXBfxjR+j7aPrPC3nWdkp0pJwUf
        hAg6UbjQ==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www381.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <lars@metafoo.de>)
        id 1k2U6R-0001Bb-OG; Mon, 03 Aug 2020 08:37:44 +0200
Received: from [2001:a61:2517:6d01:9e5c:8eff:fe01:8578]
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1k2U6R-000S1r-Ji; Mon, 03 Aug 2020 08:37:43 +0200
Subject: Re: [PATCH] iio: trigger: sysfs: Disable irqs before calling
 iio_trigger_poll()
To:     Christian Eggers <ceggers@arri.de>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     stable@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200727145714.4377-1-ceggers@arri.de>
 <20200801170234.2953b087@archlinux> <2272098.D4WoNcAbr4@n95hx1g2>
From:   Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <2443aad4-b631-bfe7-e79c-2cb585685a1e@metafoo.de>
Date:   Mon, 3 Aug 2020 08:37:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2272098.D4WoNcAbr4@n95hx1g2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.102.4/25892/Sun Aug  2 17:01:36 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/20 7:16 AM, Christian Eggers wrote:
> On Saturday, 1 August 2020, 18:02:34 CEST, Jonathan Cameron wrote:
>> On Mon, 27 Jul 2020 16:57:13 +0200
>>
>> Christian Eggers <ceggers@arri.de> wrote:
>>> iio_trigger_poll() calls generic_handle_irq(). This function expects to
>>> be run with local IRQs disabled.
>> Was there an error or warning that lead to this patch?
> [   17.448466] 000: ------------[ cut here ]------------
> [   17.448481] 000: WARNING: CPU: 0 PID: 9 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x55/0xae
> [   17.448511] 000: irq 236 handler irq_default_primary_handler+0x1/0x4 enabled interrupts
> [   17.448526] 000: Modules linked in: bridge stp llc usb_f_ncm u_ether libcomposite sd_mod configfs cdc_acm usb_storage scsi_mod ci_hdrc_imx ci_hdrc st_magn_spi ulpi st_sensors_spi ehci_hcd regmap_spi tcpm roles st_magn_i2c typec st_sensors_i2c udc_core st_magn as73211 st_sensors imx_thermal usb49xx usbcore industrialio_triggered_buffer rtc_rv3028 kfifo_buf at24 usb_common nls_base i2c_dev usbmisc_imx phy_mxs_usb anatop_regulator imx2_wdt imx_fan spidev leds_pwm leds_gpio led_class iio_trig_sysfs imx6sx_adc industrialio fixed at25 spi_imx spi_bitbang imx_napi dev imx_sdma virt_dma nfsv3 nfs lockd grace sunrpc ksz9477_i2c ksz9477 tag_ksz ksz_common dsa_core phylink regmap_i2c i2c_imx i2c_core fec ptp pps_core micrel
> [   17.448712] 000: CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.47-rt28+ #446
> [   17.448723] 000: Hardware name: Freescale i.MX6 Ultralite (Device Tree)
> [   17.448738] 000: [<c0108265>] (unwind_backtrace) from [<c01070a7>] (show_stack+0xb/0xc)
> [   17.448754] 000: [<c01070a7>] (show_stack) from [<c0110673>] (__warn+0x7b/0x8c)
> [   17.448772] 000: [<c0110673>] (__warn) from [<c01106b5>] (warn_slowpath_fmt+0x31/0x50)
> [   17.448787] 000: [<c01106b5>] (warn_slowpath_fmt) from [<c012be53>] (__handle_irq_event_percpu+0x55/0xae)
> [   17.448807] 000: [<c012be53>] (__handle_irq_event_percpu) from [<c012bec5>] (handle_irq_event_percpu+0x19/0x40)
> [   17.448823] 000: [<c012bec5>] (handle_irq_event_percpu) from [<c012bf2b>] (handle_irq_event+0x3f/0x5c)
> [   17.448839] 000: [<c012bf2b>] (handle_irq_event) from [<c012dd73>] (handle_simple_irq+0x67/0x6a)
> [   17.448854] 000: [<c012dd73>] (handle_simple_irq) from [<c012b915>] (generic_handle_irq+0xd/0x16)
> [   17.448870] 000: [<c012b915>] (generic_handle_irq) from [<bf8fcf05>] (iio_trigger_poll+0x33/0x44 [industrialio])
> [   17.448962] 000: [<bf8fcf05>] (iio_trigger_poll [industrialio]) from [<c0147b93>] (irq_work_run_list+0x43/0x66)
> [   17.449010] 000: [<c0147b93>] (irq_work_run_list) from [<c013804f>] (run_timer_softirq+0x7/0x3c)
> [   17.449029] 000: [<c013804f>] (run_timer_softirq) from [<c01022cf>] (__do_softirq+0x10f/0x160)
> [   17.449045] 000: [<c01022cf>] (__do_softirq) from [<c0112255>] (run_ksoftirqd+0x19/0x2c)
> [   17.449061] 000: [<c0112255>] (run_ksoftirqd) from [<c012153b>] (smpboot_thread_fn+0x13b/0x140)
> [   17.449078] 000: [<c012153b>] (smpboot_thread_fn) from [<c011f823>] (kthread+0xa3/0xac)
> [   17.449095] 000: [<c011f823>] (kthread) from [<c01010f1>] (ret_from_fork+0x11/0x20)
> [   17.449110] 000: Exception stack(0xc2063fb0 to 0xc2063ff8)
> [   17.449119] 000: 3fa0:                                     00000000 00000000 00000000 00000000
> [   17.449130] 000: 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   17.449139] 000: 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [   17.449146] 000: ---[ end trace 0000000000000002 ]---
>
>
>
>> Or can you point to what call in generic_handle_irq is making the
>> assumption that we are breaking?
>>
>> Given this is using the irq_work framework I'm wondering if this is
>> a more general problem?
> If I understand correctly, the kernel temporarily disables hardware interrupts
> while hardware irq handlers are run. In case of the iio-trig-hrtim and iio-trig-sysfs
> interrupts, __handle_irq_event_percpu() is not called from a hardware irq
> (where interrupts would be disabled), but from software.

The sysfs IIO trigger uses irq_work to schedule the iio_trigger_poll() 
and the promise of irq_work is that the callback will run in hard IRQ 
context. That's the whole point of it.

irq_work_run_list(), which shows up in your callgraph, has as 
BUG_ON(!irqs_disabled())[1], so we should never even get to calling 
iio_trigger_poll() if IRQs where not disabled at this point. That's the 
same condition that triggers the WARN_ON() in __handle_irq_event_percpu.

Are you using a non-upstream kernel? Maybe a RT kernel?

- Lars

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/irq_work.c#n163


