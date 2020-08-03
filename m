Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73748239EA8
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 07:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgHCFQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 01:16:51 -0400
Received: from mailout09.rmx.de ([94.199.88.74]:53497 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgHCFQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 01:16:50 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4BKmMd4xzCzbj4g;
        Mon,  3 Aug 2020 07:16:45 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BKmMK0C8lz2TTLy;
        Mon,  3 Aug 2020 07:16:29 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.30) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 3 Aug
 2020 07:16:16 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Jonathan Cameron <jic23@kernel.org>
CC:     <stable@vger.kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: trigger: sysfs: Disable irqs before calling iio_trigger_poll()
Date:   Mon, 3 Aug 2020 07:16:14 +0200
Message-ID: <2272098.D4WoNcAbr4@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20200801170234.2953b087@archlinux>
References: <20200727145714.4377-1-ceggers@arri.de> <20200801170234.2953b087@archlinux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.30]
X-RMX-ID: 20200803-071635-4BKmMK0C8lz2TTLy-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Saturday, 1 August 2020, 18:02:34 CEST, Jonathan Cameron wrote:
> On Mon, 27 Jul 2020 16:57:13 +0200
> 
> Christian Eggers <ceggers@arri.de> wrote:
> > iio_trigger_poll() calls generic_handle_irq(). This function expects to
> > be run with local IRQs disabled.
> 
> Was there an error or warning that lead to this patch?
[   17.448466] 000: ------------[ cut here ]------------
[   17.448481] 000: WARNING: CPU: 0 PID: 9 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x55/0xae
[   17.448511] 000: irq 236 handler irq_default_primary_handler+0x1/0x4 enabled interrupts
[   17.448526] 000: Modules linked in: bridge stp llc usb_f_ncm u_ether libcomposite sd_mod configfs cdc_acm usb_storage scsi_mod ci_hdrc_imx ci_hdrc st_magn_spi ulpi st_sensors_spi ehci_hcd regmap_spi tcpm roles st_magn_i2c typec st_sensors_i2c udc_core st_magn as73211 st_sensors imx_thermal usb49xx usbcore industrialio_triggered_buffer rtc_rv3028 kfifo_buf at24 usb_common nls_base i2c_dev usbmisc_imx phy_mxs_usb anatop_regulator imx2_wdt imx_fan spidev leds_pwm leds_gpio led_class iio_trig_sysfs imx6sx_adc industrialio fixed at25 spi_imx spi_bitbang imx_napi dev imx_sdma virt_dma nfsv3 nfs lockd grace sunrpc ksz9477_i2c ksz9477 tag_ksz ksz_common dsa_core phylink regmap_i2c i2c_imx i2c_core fec ptp pps_core micrel
[   17.448712] 000: CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.4.47-rt28+ #446
[   17.448723] 000: Hardware name: Freescale i.MX6 Ultralite (Device Tree)
[   17.448738] 000: [<c0108265>] (unwind_backtrace) from [<c01070a7>] (show_stack+0xb/0xc)
[   17.448754] 000: [<c01070a7>] (show_stack) from [<c0110673>] (__warn+0x7b/0x8c)
[   17.448772] 000: [<c0110673>] (__warn) from [<c01106b5>] (warn_slowpath_fmt+0x31/0x50)
[   17.448787] 000: [<c01106b5>] (warn_slowpath_fmt) from [<c012be53>] (__handle_irq_event_percpu+0x55/0xae)
[   17.448807] 000: [<c012be53>] (__handle_irq_event_percpu) from [<c012bec5>] (handle_irq_event_percpu+0x19/0x40)
[   17.448823] 000: [<c012bec5>] (handle_irq_event_percpu) from [<c012bf2b>] (handle_irq_event+0x3f/0x5c)
[   17.448839] 000: [<c012bf2b>] (handle_irq_event) from [<c012dd73>] (handle_simple_irq+0x67/0x6a)
[   17.448854] 000: [<c012dd73>] (handle_simple_irq) from [<c012b915>] (generic_handle_irq+0xd/0x16)
[   17.448870] 000: [<c012b915>] (generic_handle_irq) from [<bf8fcf05>] (iio_trigger_poll+0x33/0x44 [industrialio])
[   17.448962] 000: [<bf8fcf05>] (iio_trigger_poll [industrialio]) from [<c0147b93>] (irq_work_run_list+0x43/0x66)
[   17.449010] 000: [<c0147b93>] (irq_work_run_list) from [<c013804f>] (run_timer_softirq+0x7/0x3c)
[   17.449029] 000: [<c013804f>] (run_timer_softirq) from [<c01022cf>] (__do_softirq+0x10f/0x160)
[   17.449045] 000: [<c01022cf>] (__do_softirq) from [<c0112255>] (run_ksoftirqd+0x19/0x2c)
[   17.449061] 000: [<c0112255>] (run_ksoftirqd) from [<c012153b>] (smpboot_thread_fn+0x13b/0x140)
[   17.449078] 000: [<c012153b>] (smpboot_thread_fn) from [<c011f823>] (kthread+0xa3/0xac)
[   17.449095] 000: [<c011f823>] (kthread) from [<c01010f1>] (ret_from_fork+0x11/0x20)
[   17.449110] 000: Exception stack(0xc2063fb0 to 0xc2063ff8)
[   17.449119] 000: 3fa0:                                     00000000 00000000 00000000 00000000
[   17.449130] 000: 3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   17.449139] 000: 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   17.449146] 000: ---[ end trace 0000000000000002 ]---



> Or can you point to what call in generic_handle_irq is making the
> assumption that we are breaking?
> 
> Given this is using the irq_work framework I'm wondering if this is
> a more general problem?

If I understand correctly, the kernel temporarily disables hardware interrupts
while hardware irq handlers are run. In case of the iio-trig-hrtim and iio-trig-sysfs
interrupts, __handle_irq_event_percpu() is not called from a hardware irq
(where interrupts would be disabled), but from software.

Similar examples found here:
0a29ac5bd3 ("net: usb: lan78xx: Disable interrupts before calling generic_handle_irq()")

and
drivers/i2c/busses/i2c-cht-wc.c:103


> 
> Basically more info please!
> 
> Thanks,
> 
> Jonathan
> 
Regards
Christian



