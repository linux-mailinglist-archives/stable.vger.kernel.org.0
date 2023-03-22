Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821706C5172
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 17:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCVQ7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 12:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjCVQ7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 12:59:47 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FC51ACC5;
        Wed, 22 Mar 2023 09:59:31 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pf1o8-0006Q5-3R; Wed, 22 Mar 2023 17:59:28 +0100
Message-ID: <3fcc707b-f757-e74b-2800-3b6314217868@leemhuis.info>
Date:   Wed, 22 Mar 2023 17:59:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: kernel error at led trigger "phy0tpt"
Content-Language: en-US, de-DE
To:     Sean Wang <sean.wang@mediatek.com>
References: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tobias Dahms <dahms.tobias@web.de>
In-Reply-To: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1679504372;a00c729a;
X-HE-SMSGID: 1pf1o8-0006Q5-3R
X-Spam-Status: No, score=0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[adding the maintainer for drivers/leds/leds-mt6323.c as well as the LED
subsystem maintainers to the list of recipients]

Note, I first thought this might have been a vendor kernel, but it's
not, as Tobias clarified (thx!):
https://lore.kernel.org/all/f8f7d7ae-7e4b-e0fb-6a21-1d4fdcc22035@web.de/

[TLDR for the rest of this mail: I'm adding below report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form. See link in footer if these mails annoy you.]

On 20.03.23 20:44, Tobias Dahms wrote:
> Hello,
> 
> since some kernel versions I get a kernel errror while setting led
> trigger to phy0tpt.
> 
> command to reproduce:
> echo phy0tpt > /sys/class/leds/bpi-r2\:isink\:blue/trigger
> 
> same trigger, other led location => no error:
> echo phy0tpt > /sys/class/leds/bpi-r2\:pio\:blue/trigger
> 
> other trigger, same led location => no error:
> echo phy0tx > /sys/class/leds/bpi-r2\:isink\:blue/trigger
> 
> last good kernel:
> bpi-r2 5.19.17-bpi-r2
> 
> error at kernel versions:
> bpi-r2 6.0.19-bpi-r2
> up to
> bpi-r2 6.3.0-rc1-bpi-r2+
> 
> wireless lan card:
> 01:00.0 Network controller: MEDIATEK Corp. MT7612E 802.11acbgn PCI
> Express Wireless Network Adapter
> 
> distribution:
> Arch-Linux-ARM (with vanilla kernel instead of original distribution
> kernel)
> 
> board:
> BananaPi-R2
> 
> log messages:
> Mär 12 12:54:55 bpi-r2 kernel: BUG: scheduling while atomic:
> swapper/0/0/0x00000100
> Mär 12 12:54:55 bpi-r2 kernel: Modules linked in: aes_arm_bs crypto_simd
> cryptd nft_masq nft_ct nf_log_syslog nft_log nft_chain_nat nf_nat
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink mt76x2e
> mt76x2_common mt76x02_lib mt76 spi_mt65xx pwm_mediatek mt6577_auxadc
> sch_fq_codel fuse configfs ip_tables x_tables
> Mär 12 12:54:55 bpi-r2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> 6.3.0-rc1-bpi-r2+ #1
> Mär 12 12:54:55 bpi-r2 kernel: Hardware name: Mediatek Cortex-A7 (Device
> Tree)
> Mär 12 12:54:55 bpi-r2 kernel: Backtrace:
> Mär 12 12:54:55 bpi-r2 kernel:  dump_backtrace from show_stack+0x20/0x24
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c14ab340 r6:00000000 r5:c12507fc
> r4:600f0113
> Mär 12 12:54:55 bpi-r2 kernel:  show_stack from dump_stack_lvl+0x48/0x54
> Mär 12 12:54:55 bpi-r2 kernel:  dump_stack_lvl from dump_stack+0x18/0x1c
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  dump_stack from __schedule_bug+0x60/0x70
> Mär 12 12:54:55 bpi-r2 kernel:  __schedule_bug from __schedule+0x6b0/0x904
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:eed9d340
> Mär 12 12:54:55 bpi-r2 kernel:  __schedule from schedule+0x6c/0xe8
> Mär 12 12:54:55 bpi-r2 kernel:  r10:c1501ba0 r9:00000000 r8:00001b58
> r7:c1508fc0 r6:00001b58 r5:0000004a
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c1508fc0
> Mär 12 12:54:55 bpi-r2 kernel:  schedule from
> schedule_hrtimeout_range_clock+0xec/0x14c
> Mär 12 12:54:55 bpi-r2 kernel:  r5:0000004a r4:47ac1837
> Mär 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range_clock from
> schedule_hrtimeout_range+0x28/0x30
> Mär 12 12:54:55 bpi-r2 kernel:  r10:c1501c50 r9:c1508fc0 r8:00000002
> r7:00000000 r6:c1501ba0 r5:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  r4:00001b58
> Mär 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range from
> usleep_range_state+0x6c/0x90
> Mär 12 12:54:55 bpi-r2 kernel:  usleep_range_state from
> pwrap_read16+0xfc/0x2a0
> Mär 12 12:54:55 bpi-r2 kernel:  r9:0000004a r8:4844840c r7:0000004a
> r6:48447f8a r5:01980000 r4:c2703940
> Mär 12 12:54:55 bpi-r2 kernel:  pwrap_read16 from
> pwrap_regmap_read+0x24/0x28
> Mär 12 12:54:55 bpi-r2 kernel:  r10:00001f00 r9:00000000 r8:00000f00
> r7:c2703940 r6:c1501c50 r5:00000330
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:c06f3fbc
> Mär 12 12:54:55 bpi-r2 kernel:  pwrap_regmap_read from
> _regmap_read+0x70/0x160
> Mär 12 12:54:55 bpi-r2 kernel:  _regmap_read from
> _regmap_update_bits+0xc8/0x108
> Mär 12 12:54:55 bpi-r2 kernel:  r10:00001f00 r9:00000000 r8:00000f00
> r7:c1508fc0 r6:00000330 r5:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  _regmap_update_bits from
> regmap_update_bits_base+0x60/0x84
> Mär 12 12:54:55 bpi-r2 kernel:  r10:00000000 r9:00000f00 r8:00000000
> r7:00001f00 r6:00000000 r5:00000330
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c196e000
> Mär 12 12:54:55 bpi-r2 kernel:  regmap_update_bits_base from
> mt6323_led_set_blink+0xf0/0x148
> Mär 12 12:54:55 bpi-r2 kernel:  r10:eed94800 r9:c16998c0 r8:c196e000
> r7:c31f0c48 r6:c2456f48 r5:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  r4:0000014e
> Mär 12 12:54:55 bpi-r2 kernel:  mt6323_led_set_blink from
> led_blink_setup+0x3c/0x110
> Mär 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000770 r7:c1501d60
> r6:c1501d5c r5:c1501d60 r4:c31f0c48
> Mär 12 12:54:55 bpi-r2 kernel:  led_blink_setup from
> led_blink_set+0x60/0x64
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c31f0c58
> r4:c31f0c48
> Mär 12 12:54:55 bpi-r2 kernel:  led_blink_set from
> led_trigger_blink+0x44/0x58
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c5b69740
> r4:c31f0c48
> Mär 12 12:54:55 bpi-r2 kernel:  led_trigger_blink from
> tpt_trig_timer+0x10c/0x130
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c0df71f0 r6:c1508fc0 r5:c5b685a0
> r4:c597b628
> Mär 12 12:54:55 bpi-r2 kernel:  tpt_trig_timer from
> call_timer_fn+0x48/0x168
> Mär 12 12:54:55 bpi-r2 kernel:  r6:c597b628 r5:00000100 r4:c16998c0
> Mär 12 12:54:55 bpi-r2 kernel:  call_timer_fn from
> run_timer_softirq+0x600/0x6c8
> Mär 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000000 r7:00000770
> r6:00000000 r5:c1501de4 r4:c597b628
> Mär 12 12:54:55 bpi-r2 kernel:  run_timer_softirq from
> __do_softirq+0x140/0x34c
> Mär 12 12:54:55 bpi-r2 kernel:  r10:00000082 r9:00000100 r8:c1698481
> r7:c1698f60 r6:00000001 r5:00000002
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c1503084
> Mär 12 12:54:55 bpi-r2 kernel:  __do_softirq from irq_exit+0xb8/0xe8
> Mär 12 12:54:55 bpi-r2 kernel:  r10:10c5387d r9:c1508fc0 r8:c1698481
> r7:c1501f0c r6:00000000 r5:c1501ed8
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c14aaf58
> Mär 12 12:54:55 bpi-r2 kernel:  irq_exit from
> generic_handle_arch_irq+0x48/0x4c
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1501ed8 r4:c14aaf58
> Mär 12 12:54:55 bpi-r2 kernel:  generic_handle_arch_irq from
> __irq_svc+0x88/0xb0
> Mär 12 12:54:55 bpi-r2 kernel: Exception stack(0xc1501ed8 to 0xc1501f20)
> Mär 12 12:54:55 bpi-r2 kernel: 1ec0:
>                   000862f4 2d8f2000
> Mär 12 12:54:55 bpi-r2 kernel: 1ee0: c1508fc0 00000000 c1699cc0 c1504f10
> c1504f70 00000001 c1698481 c123a9b4
> Mär 12 12:54:55 bpi-r2 kernel: 1f00: 10c5387d c1501f3c 00000001 c1501f28
> c0e36fa0 c0e3767c 600f0013 ffffffff
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c1501f0c r6:ffffffff r5:600f0013
> r4:c0e3767c
> Mär 12 12:54:55 bpi-r2 kernel:  default_idle_call from do_idle+0xc4/0x124
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1504f10 r4:00000001
> Mär 12 12:54:55 bpi-r2 kernel:  do_idle from cpu_startup_entry+0x28/0x2c
> Mär 12 12:54:55 bpi-r2 kernel:  r9:efffcd40 r8:00000000 r7:00000045
> r6:c1326068 r5:c16fb9b8 r4:000000ec
> Mär 12 12:54:55 bpi-r2 kernel:  cpu_startup_entry from rest_init+0xc0/0xc4
> Mär 12 12:54:55 bpi-r2 kernel:  rest_init from
> arch_post_acpi_subsys_init+0x0/0x30
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c16fb9b8 r4:c16cc038
> Mär 12 12:54:55 bpi-r2 kernel:  arch_call_rest_init from
> start_kernel+0x6c0/0x704
> Mär 12 12:54:55 bpi-r2 kernel:  start_kernel from 0x0
> Mär 12 12:54:55 bpi-r2 kernel: bad: scheduling from the idle thread!
> Mär 12 12:54:55 bpi-r2 kernel: CPU: 0 PID: 0 Comm: swapper/0 Tainted: G
>       W          6.3.0-rc1-bpi-r2+ #1
> Mär 12 12:54:55 bpi-r2 kernel: Hardware name: Mediatek Cortex-A7 (Device
> Tree)
> Mär 12 12:54:55 bpi-r2 kernel: Backtrace:
> Mär 12 12:54:55 bpi-r2 kernel:  dump_backtrace from show_stack+0x20/0x24
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c14ab340 r6:00000001 r5:c12507fc
> r4:60070013
> Mär 12 12:54:55 bpi-r2 kernel:  show_stack from dump_stack_lvl+0x48/0x54
> Mär 12 12:54:55 bpi-r2 kernel:  dump_stack_lvl from dump_stack+0x18/0x1c
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:eed9d340
> Mär 12 12:54:55 bpi-r2 kernel:  dump_stack from dequeue_task_idle+0x30/0x44
> Mär 12 12:54:55 bpi-r2 kernel:  dequeue_task_idle from
> __schedule+0x4bc/0x904
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1508fc0 r4:eed9d340
> Mär 12 12:54:55 bpi-r2 kernel:  __schedule from schedule+0x6c/0xe8
> Mär 12 12:54:55 bpi-r2 kernel:  r10:c1501ba0 r9:00000000 r8:00001b58
> r7:c1508fc0 r6:00001b58 r5:0000004a
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c1508fc0
> Mär 12 12:54:55 bpi-r2 kernel:  schedule from
> schedule_hrtimeout_range_clock+0xec/0x14c
> Mär 12 12:54:55 bpi-r2 kernel:  r5:0000004a r4:492d8817
> Mär 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range_clock from
> schedule_hrtimeout_range+0x28/0x30
> Mär 12 12:54:55 bpi-r2 kernel:  r10:c1501c50 r9:c1508fc0 r8:00000002
> r7:00000000 r6:c1501ba0 r5:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  r4:00001b58
> Mär 12 12:54:55 bpi-r2 kernel:  schedule_hrtimeout_range from
> usleep_range_state+0x6c/0x90
> Mär 12 12:54:55 bpi-r2 kernel:  usleep_range_state from
> pwrap_read16+0xfc/0x2a0
> Mär 12 12:54:55 bpi-r2 kernel:  r9:0000004a r8:49c5f439 r7:0000004a
> r6:49c5f0eb r5:01990000 r4:c2703940
> Mär 12 12:54:55 bpi-r2 kernel:  pwrap_read16 from
> pwrap_regmap_read+0x24/0x28
> Mär 12 12:54:55 bpi-r2 kernel:  r10:0000ffff r9:00000000 r8:0000014d
> r7:c2703940 r6:c1501c50 r5:00000332
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:c06f3fbc
> Mär 12 12:54:55 bpi-r2 kernel:  pwrap_regmap_read from
> _regmap_read+0x70/0x160
> Mär 12 12:54:55 bpi-r2 kernel:  _regmap_read from
> _regmap_update_bits+0xc8/0x108
> Mär 12 12:54:55 bpi-r2 kernel:  r10:0000ffff r9:00000000 r8:0000014d
> r7:c1508fc0 r6:00000332 r5:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c196e000 r3:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  _regmap_update_bits from
> regmap_update_bits_base+0x60/0x84
> Mär 12 12:54:55 bpi-r2 kernel:  r10:00000000 r9:0000014d r8:00000000
> r7:0000ffff r6:00000000 r5:00000332
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c196e000
> Mär 12 12:54:55 bpi-r2 kernel:  regmap_update_bits_base from
> mt6323_led_set_blink+0x138/0x148
> Mär 12 12:54:55 bpi-r2 kernel:  r10:eed94800 r9:00000000 r8:c196e000
> r7:c31f0c48 r6:c2456f48 r5:00000000
> Mär 12 12:54:55 bpi-r2 kernel:  r4:0000014e
> Mär 12 12:54:55 bpi-r2 kernel:  mt6323_led_set_blink from
> led_blink_setup+0x3c/0x110
> Mär 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000770 r7:c1501d60
> r6:c1501d5c r5:c1501d60 r4:c31f0c48
> Mär 12 12:54:55 bpi-r2 kernel:  led_blink_setup from
> led_blink_set+0x60/0x64
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c31f0c58
> r4:c31f0c48
> Mär 12 12:54:55 bpi-r2 kernel:  led_blink_set from
> led_trigger_blink+0x44/0x58
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c1501d60 r6:c1501d5c r5:c5b69740
> r4:c31f0c48
> Mär 12 12:54:55 bpi-r2 kernel:  led_trigger_blink from
> tpt_trig_timer+0x10c/0x130
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c0df71f0 r6:c1508fc0 r5:c5b685a0
> r4:c597b628
> Mär 12 12:54:55 bpi-r2 kernel:  tpt_trig_timer from
> call_timer_fn+0x48/0x168
> Mär 12 12:54:55 bpi-r2 kernel:  r6:c597b628 r5:00000100 r4:c16998c0
> Mär 12 12:54:55 bpi-r2 kernel:  call_timer_fn from
> run_timer_softirq+0x600/0x6c8
> Mär 12 12:54:55 bpi-r2 kernel:  r9:c16998c0 r8:00000000 r7:00000770
> r6:00000000 r5:c1501de4 r4:c597b628
> Mär 12 12:54:55 bpi-r2 kernel:  run_timer_softirq from
> __do_softirq+0x140/0x34c
> Mär 12 12:54:55 bpi-r2 kernel:  r10:00000082 r9:00000100 r8:c1698481
> r7:c1698f60 r6:00000001 r5:00000002
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c1503084
> Mär 12 12:54:55 bpi-r2 kernel:  __do_softirq from irq_exit+0xb8/0xe8
> Mär 12 12:54:55 bpi-r2 kernel:  r10:10c5387d r9:c1508fc0 r8:c1698481
> r7:c1501f0c r6:00000000 r5:c1501ed8
> Mär 12 12:54:55 bpi-r2 kernel:  r4:c14aaf58
> Mär 12 12:54:55 bpi-r2 kernel:  irq_exit from
> generic_handle_arch_irq+0x48/0x4c
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1501ed8 r4:c14aaf58
> Mär 12 12:54:55 bpi-r2 kernel:  generic_handle_arch_irq from
> __irq_svc+0x88/0xb0
> Mär 12 12:54:55 bpi-r2 kernel: Exception stack(0xc1501ed8 to 0xc1501f20)
> Mär 12 12:54:55 bpi-r2 kernel: 1ec0:
>                   000862f4 2d8f2000
> Mär 12 12:54:55 bpi-r2 kernel: 1ee0: c1508fc0 00000000 c1699cc0 c1504f10
> c1504f70 00000001 c1698481 c123a9b4
> Mär 12 12:54:55 bpi-r2 kernel: 1f00: 10c5387d c1501f3c 00000001 c1501f28
> c0e36fa0 c0e3767c 600f0013 ffffffff
> Mär 12 12:54:55 bpi-r2 kernel:  r7:c1501f0c r6:ffffffff r5:600f0013
> r4:c0e3767c
> Mär 12 12:54:55 bpi-r2 kernel:  default_idle_call from do_idle+0xc4/0x124
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c1504f10 r4:00000001
> Mär 12 12:54:55 bpi-r2 kernel:  do_idle from cpu_startup_entry+0x28/0x2c
> Mär 12 12:54:55 bpi-r2 kernel:  r9:efffcd40 r8:00000000 r7:00000045
> r6:c1326068 r5:c16fb9b8 r4:000000ec
> Mär 12 12:54:55 bpi-r2 kernel:  cpu_startup_entry from rest_init+0xc0/0xc4
> Mär 12 12:54:55 bpi-r2 kernel:  rest_init from
> arch_post_acpi_subsys_init+0x0/0x30
> Mär 12 12:54:55 bpi-r2 kernel:  r5:c16fb9b8 r4:c16cc038
> Mär 12 12:54:55 bpi-r2 kernel:  arch_call_rest_init from
> start_kernel+0x6c0/0x704
> Mär 12 12:54:55 bpi-r2 kernel:  start_kernel from 0x0
> Mär 12 12:54:55 bpi-r2 kernel: ------------[ cut here ]------------

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced v5.19..v6.0
#regzbot title led: kernel bug when setting trigger to "phy0tpt"
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
