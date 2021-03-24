Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417FA347615
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 11:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhCXK1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 06:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhCXK06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Mar 2021 06:26:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B1B619C0;
        Wed, 24 Mar 2021 10:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616581618;
        bh=ksfa5cPvTDVlPpaq2NhULzmA4i71bnAzJO+7fqYX14A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vdIx86IrhjOymOUhMxWDSZq35+dtUaNHsBQthh2N2r508C0QI/XTuT1MBvwJztTXp
         zsLI77owm28hxrL7P/KDU99WQ+ahtGYko6WSxdm1cTTBu0rhIl+drNZZiO/ibxwLga
         DBcplYHPve2KpdllYgGxe3qhOXuLfwZq1UynulAM=
Date:   Wed, 24 Mar 2021 11:26:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
Message-ID: <YFsT718DwasKg7Qz@kroah.com>
References: <20210310132320.550932445@linuxfoundation.org>
 <29dcd801-7f1e-ae09-9b88-ce17cb096f60@gmail.com>
 <YEoWT85kGVYbBnKY@kroah.com>
 <61cef8f0-c40a-c4e4-5322-9939ed21bff7@gmail.com>
 <YEpV/FZ8mLivt0hy@kroah.com>
 <40f06036-c6de-706b-30a0-e20de0c6ff57@gmail.com>
 <20210312125408.5774-1-alobakin@pm.me>
 <20210315095057.zwqgiwpfyxisrwy3@pali>
 <fd610305-ce68-8ed7-b9b7-8afa1922f9e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fd610305-ce68-8ed7-b9b7-8afa1922f9e9@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 10:20:27AM -0700, Florian Fainelli wrote:
> 
> 
> On 3/15/2021 2:50 AM, Pali Rohár wrote:
> > On Friday 12 March 2021 12:54:18 Alexander Lobakin wrote:
> >> From: Florian Fainelli <f.fainelli@gmail.com>
> >> Date: Thu, 11 Mar 2021 09:41:27 -0800
> >>
> >> Hi Florian,
> >>
> >>> On 3/11/21 9:40 AM, Greg KH wrote:
> >>>> On Thu, Mar 11, 2021 at 09:23:56AM -0800, Florian Fainelli wrote:
> >>>>> On 3/11/21 5:08 AM, Greg KH wrote:
> >>>>>> On Wed, Mar 10, 2021 at 08:19:45PM -0800, Florian Fainelli wrote:
> >>>>>>> +Alex,
> >>>>>>>
> >>>>>>> On 3/10/2021 5:24 AM, gregkh@linuxfoundation.org wrote:
> >>>>>>>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>>>>>
> >>>>>>>> This is the start of the stable review cycle for the 5.4.105 release.
> >>>>>>>> There are 24 patches in this series, all will be posted as a response
> >>>>>>>> to this one.  If anyone has any issues with these being applied, please
> >>>>>>>> let me know.
> >>>>>>>>
> >>>>>>>> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> >>>>>>>> Anything received after that time might be too late.
> >>>>>>>>
> >>>>>>>> The whole patch series can be found in one patch at:
> >>>>>>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.105-rc1.gz
> >>>>>>>> or in the git tree and branch at:
> >>>>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> >>>>>>>> and the diffstat can be found below.
> >>>>>>>>
> >>>>>>>> thanks,
> >>>>>>>>
> >>>>>>>> greg k-h
> >>>>>>>
> >>>>>>> I believe you need to drop "net: dsa: add GRO support via gro_cells" as
> >>>>>>> it causes the following kernel panic on a DSA-enabled platform:
> >>>>>>>
> >>>>>>> Configuring rgmii_2 interface
> >>>>>>> [   10.170527] brcm-sf2 f0b00000.ethernet_switch rgmii_2: configuring
> >>>>>>> for fixed/rgmii-txid link mode
> >>>>>>> [   10.179597] 8021q: adding VLAN 0 to HW filter on device rgmii_2
> >>>>>>> [   10.185608] brcm-sf2 f0b00000.ethernet_switch rgmii_2: Link is Up -
> >>>>>>> 1Gbps/Full - flow control off
> >>>>>>> [   10.198631] IPv6: ADDRCONF(NETDEV_CHANGE): rgmii_2: link becomes ready
> >>>>>>> Configuring sit0 interface
> >>>>>>> [   10.254346] 8<--- cut here ---
> >>>>>>> [   10.257438] Unable to handle kernel paging request at virtual address
> >>>>>>> d6df6190
> >>>>>>> [   10.264685] pgd = (ptrval)
> >>>>>>> [   10.267411] [d6df6190] *pgd=80000000007003, *pmd=00000000
> >>>>>>> [   10.272846] Internal error: Oops: 206 [#1] SMP ARM
> >>>>>>> [   10.277661] Modules linked in:
> >>>>>>> [   10.280739] CPU: 0 PID: 1886 Comm: sed Not tainted
> >>>>>>> 5.4.105-1.0pre-geff642e2af2b #4
> >>>>>>> [   10.288337] Hardware name: Broadcom STB (Flattened Device Tree)
> >>>>>>> [   10.294292] PC is at gro_cells_receive+0x90/0x11c
> >>>>>>> [   10.299020] LR is at dsa_switch_rcv+0x120/0x1d4
> >>>>>>> [   10.303562] pc : [<c0a57a28>]    lr : [<c0b4a65c>]    psr: 600f0113
> >>>>>>> [   10.309841] sp : c1d33cd0  ip : 000003e8  fp : c1d33ce4
> >>>>>>> [   10.315078] r10: c8901000  r9 : c8901000  r8 : c0b4a53c
> >>>>>>> [   10.320314] r7 : c2208920  r6 : 00000000  r5 : 00000000  r4 : 00004000
> >>>>>>> [   10.326855] r3 : d6df6188  r2 : c4927000  r1 : c8adc300  r0 : c22069dc
> >>>>>>> [   10.333398] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> >>>>>>> Segment user
> >>>>>>> [   10.340547] Control: 30c5387d  Table: 04ac4c80  DAC: fffffffd
> >>>>>>> [   10.346307] Process sed (pid: 1886, stack limit = 0x(ptrval))
> >>>>>>> [   10.352066] Stack: (0xc1d33cd0 to 0xc1d34000)
> >>>>>>> [   10.356434] 3cc0:                                     c8adc300
> >>>>>>> c4927000 c1d33d04 c1d33ce8
> >>>>>>> [   10.364631] 3ce0: c0b4a65c c0a579a4 c1d33d24 c2208920 c1d33d24
> >>>>>>> 00000000 c1d33d5c c1d33d08
> >>>>>>> [   10.372827] 3d00: c0a0b38c c0b4a548 c021e070 c2204cc8 00000000
> >>>>>>> c89015c0 04b87700 c89015c0
> >>>>>>> [   10.381023] 3d20: c2208920 c1d33d24 c1d33d24 00976ec2 04b87700
> >>>>>>> c8adc300 c89015c0 00000000
> >>>>>>> [   10.389218] 3d40: c1d33d74 c1d32000 00000000 c230742c c1d33dac
> >>>>>>> c1d33d60 c0a0b5c0 c0a0b180
> >>>>>>> [   10.397414] 3d60: 00000000 c2204cc8 00000000 c1d33d6c c1d33d6c
> >>>>>>> c1d33d80 c029daf8 00976ec2
> >>>>>>> [   10.405610] 3d80: 00000800 c8901540 c89015c0 c8901540 00000000
> >>>>>>> 00000001 0000016c 00000162
> >>>>>>> [   10.413805] 3da0: c1d33dc4 c1d33db0 c0a0b7fc c0a0b3b8 00000000
> >>>>>>> c8adc300 c1d33dfc c1d33dc8
> >>>>>>> [   10.422001] 3dc0: c0a0c660 c0a0b7e4 c8901540 c8adc300 c1d33dfc
> >>>>>>> c1d33de0 c8901540 c8adc300
> >>>>>>> [   10.430196] 3de0: 0000015e c8901000 00000001 0000016c c1d33e74
> >>>>>>> c1d33e00 c083df00 c0a0c4fc
> >>>>>>> [   10.438391] 3e00: 0000012c c22b0f14 c1d33e4c c1d33e18 c0fbd9b8
> >>>>>>> c0fbd9cc c0fbd9e0 c0fbd98c
> >>>>>>> [   10.446586] 3e20: 00000001 00000040 c8901500 00000001 00000000
> >>>>>>> 00000000 00000000 00000000
> >>>>>>> [   10.454780] 3e40: 00000000 00000000 c02f65a0 c8901540 00000001
> >>>>>>> 00000040 c22b07e4 0000012c
> >>>>>>> [   10.462975] 3e60: d1003000 fffb942f c1d33edc c1d33e78 c0a0c94c
> >>>>>>> c083dafc d051ad80 c2204cc8
> >>>>>>> [   10.471170] 3e80: c2204cf0 c1d32000 c22b40b0 0e4a4000 c2076d80
> >>>>>>> c2203d00 c022bc70 c1d33e9c
> >>>>>>> [   10.479365] 3ea0: c1d33e9c c1d33ea4 c1d33ea4 00976ec2 c02f65a0
> >>>>>>> c220308c 00000003 c1d32000
> >>>>>>> [   10.487561] 3ec0: c22b07e4 00000100 d1003000 00000008 c1d33f44
> >>>>>>> c1d33ee0 c020238c c0a0c6cc
> >>>>>>> [   10.495755] 3ee0: c1d33f14 c1d33ef0 00000001 00400000 c2203d00
> >>>>>>> fffb942f c206b2e4 c2076040
> >>>>>>> [   10.503950] 3f00: c2076040 0000000a c2203080 c206b358 c1d33ee0
> >>>>>>> 00000004 c90c9500 ffffe000
> >>>>>>> [   10.512145] 3f20: 00000000 00000000 00000001 c9019000 d1003000
> >>>>>>> 00000000 c1d33f5c c1d33f48
> >>>>>>> [   10.520339] 3f40: c022bc70 c0202264 c2075fbc 00000000 c1d33f84
> >>>>>>> c1d33f60 c027feb4 c022bb88
> >>>>>>> [   10.528535] 3f60: c226d668 c220565c d100200c c1d33fb0 d1002000
> >>>>>>> d1003000 c1d33fac c1d33f88
> >>>>>>> [   10.536730] 3f80: c0202214 c027fe50 b6f1e0b6 000f0030 ffffffff
> >>>>>>> 30c5387d 30c5387d 00000000
> >>>>>>> [   10.544924] 3fa0: 00000000 c1d33fb0 c0201d8c c02021c4 b6ec1778
> >>>>>>> b6f32094 62632e73 62740000
> >>>>>>> [   10.553120] 3fc0: 00172e73 00001700 b6f3293c 00000001 00000001
> >>>>>>> 00000000 00000000 00000006
> >>>>>>> [   10.561316] 3fe0: ffffffff bef37ac8 b6f18151 b6f1e0b6 000f0030
> >>>>>>> ffffffff 00000000 00000000
> >>>>>>> [   10.569508] Backtrace:
> >>>>>>> [   10.571970] [<c0a57998>] (gro_cells_receive) from [<c0b4a65c>]
> >>>>>>> (dsa_switch_rcv+0x120/0x1d4)
> >>>>>>> [   10.580338]  r5:c4927000 r4:c8adc300
> >>>>>>> [   10.583929] [<c0b4a53c>] (dsa_switch_rcv) from [<c0a0b38c>]
> >>>>>>> (__netif_receive_skb_list_core+0x218/0x238)
> >>>>>>> [   10.593343]  r7:00000000 r6:c1d33d24 r5:c2208920 r4:c1d33d24
> >>>>>>> [   10.599017] [<c0a0b174>] (__netif_receive_skb_list_core) from
> >>>>>>> [<c0a0b5c0>] (netif_receive_skb_list_internal+0x214/0x2dc)
> >>>>>>> [   10.609909]  r10:c230742c r9:00000000 r8:c1d32000 r7:c1d33d74
> >>>>>>> r6:00000000 r5:c89015c0
> >>>>>>> [   10.617755]  r4:c8adc300
> >>>>>>> [   10.620300] [<c0a0b3ac>] (netif_receive_skb_list_internal) from
> >>>>>>> [<c0a0b7fc>] (gro_normal_list.part.42+0x24/0x38)
> >>>>>>> [   10.630496]  r10:00000162 r9:0000016c r8:00000001 r7:00000000
> >>>>>>> r6:c8901540 r5:c89015c0
> >>>>>>> [   10.638342]  r4:c8901540
> >>>>>>> [   10.640885] [<c0a0b7d8>] (gro_normal_list.part.42) from [<c0a0c660>]
> >>>>>>> (napi_complete_done+0x170/0x1d0)
> >>>>>>> [   10.650123]  r5:c8adc300 r4:00000000
> >>>>>>> [   10.653712] [<c0a0c4f0>] (napi_complete_done) from [<c083df00>]
> >>>>>>> (bcm_sysport_poll+0x410/0x4b4)
> >>>>>>> [   10.662343]  r9:0000016c r8:00000001 r7:c8901000 r6:0000015e
> >>>>>>> r5:c8adc300 r4:c8901540
> >>>>>>> [   10.670104] [<c083daf0>] (bcm_sysport_poll) from [<c0a0c94c>]
> >>>>>>> (net_rx_action+0x28c/0x44c)
> >>>>>>> [   10.678301]  r10:fffb942f r9:d1003000 r8:0000012c r7:c22b07e4
> >>>>>>> r6:00000040 r5:00000001
> >>>>>>> [   10.686146]  r4:c8901540
> >>>>>>> [   10.688693] [<c0a0c6c0>] (net_rx_action) from [<c020238c>]
> >>>>>>> (__do_softirq+0x134/0x414)
> >>>>>>> [   10.696542]  r10:00000008 r9:d1003000 r8:00000100 r7:c22b07e4
> >>>>>>> r6:c1d32000 r5:00000003
> >>>>>>> [   10.704387]  r4:c220308c
> >>>>>>> [   10.706931] [<c0202258>] (__do_softirq) from [<c022bc70>]
> >>>>>>> (irq_exit+0xf4/0x100)
> >>>>>>> [   10.714257]  r10:00000000 r9:d1003000 r8:c9019000 r7:00000001
> >>>>>>> r6:00000000 r5:00000000
> >>>>>>> [   10.722104]  r4:ffffe000
> >>>>>>> [   10.724650] [<c022bb7c>] (irq_exit) from [<c027feb4>]
> >>>>>>> (__handle_domain_irq+0x70/0xc4)
> >>>>>>> [   10.732497]  r5:00000000 r4:c2075fbc
> >>>>>>> [   10.736083] [<c027fe44>] (__handle_domain_irq) from [<c0202214>]
> >>>>>>> (gic_handle_irq+0x5c/0xa0)
> >>>>>>> [   10.744453]  r9:d1003000 r8:d1002000 r7:c1d33fb0 r6:d100200c
> >>>>>>> r5:c220565c r4:c226d668
> >>>>>>> [   10.752215] [<c02021b8>] (gic_handle_irq) from [<c0201d8c>]
> >>>>>>> (__irq_usr+0x4c/0x60)
> >>>>>>> [   10.759713] Exception stack(0xc1d33fb0 to 0xc1d33ff8)
> >>>>>>> [   10.764776] 3fa0:                                     b6ec1778
> >>>>>>> b6f32094 62632e73 62740000
> >>>>>>> [   10.772973] 3fc0: 00172e73 00001700 b6f3293c 00000001 00000001
> >>>>>>> 00000000 00000000 00000006
> >>>>>>> [   10.781167] 3fe0: ffffffff bef37ac8 b6f18151 b6f1e0b6 000f0030 ffffffff
> >>>>>>> [   10.787797]  r9:00000000 r8:30c5387d r7:30c5387d r6:ffffffff
> >>>>>>> r5:000f0030 r4:b6f1e0b6
> >>>>>>> [   10.795559] Code: e30609dc e34c0220 e083300c e590c000 (e5930008)
> >>>>>>> [   10.801670] ---[ end trace 97c3942fa73eff4c ]---
> >>>>>>> [   10.806300] Kernel panic - not syncing: Fatal exception in interrupt
> >>>>>>> [   10.812678] CPU2: stopping
> >>>>>>> [   10.815403] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D
> >>>>>>>  5.4.105-1.0pre-geff642e2af2b #4
> >>>>>>> [   10.824641] Hardware name: Broadcom STB (Flattened Device Tree)
> >>>>>>> [   10.830573] Backtrace:
> >>>>>>> [   10.833036] [<c020dd30>] (dump_backtrace) from [<c020e04c>]
> >>>>>>> (show_stack+0x20/0x24)
> >>>>>>> [   10.840624]  r7:c22a86d0 r6:00000000 r5:600c0193 r4:c22a86d0
> >>>>>>> [   10.846302] [<c020e02c>] (show_stack) from [<c0c09924>]
> >>>>>>> (dump_stack+0xb8/0xe4)
> >>>>>>> [   10.853546] [<c0c0986c>] (dump_stack) from [<c0212160>]
> >>>>>>> (handle_IPI+0x344/0x3cc)
> >>>>>>> [   10.860960]  r10:00000000 r9:c2205400 r8:00000000 r7:00000002
> >>>>>>> r6:c22b0744 r5:00000004
> >>>>>>> [   10.868807]  r4:c22ce308 r3:00976ec2
> >>>>>>> [   10.872395] [<c0211e1c>] (handle_IPI) from [<c0202254>]
> >>>>>>> (gic_handle_irq+0x9c/0xa0)
> >>>>>>> [   10.879983]  r10:00000000 r9:d1003000 r8:d1002000 r7:c9131f18
> >>>>>>> r6:d100200c r5:c220565c
> >>>>>>> [   10.887829]  r4:c226d668
> >>>>>>> [   10.890373] [<c02021b8>] (gic_handle_irq) from [<c0201a3c>]
> >>>>>>> (__irq_svc+0x5c/0x7c)
> >>>>>>> [   10.897871] Exception stack(0xc9131f18 to 0xc9131f60)
> >>>>>>> [   10.902934] 1f00:
> >>>>>>>    c020a47c 00000000
> >>>>>>> [   10.911131] 1f20: 0e4ca000 600c0093 c9130000 c2204cf0 c2204d34
> >>>>>>> 00000004 00000000 c20757b0
> >>>>>>> [   10.919327] 1f40: 00000000 c9131f74 c9130000 c9131f68 00000000
> >>>>>>> c020a480 600c0013 ffffffff
> >>>>>>> [   10.927523]  r9:c9130000 r8:00000000 r7:c9131f4c r6:ffffffff
> >>>>>>> r5:600c0013 r4:c020a480
> >>>>>>> [   10.935291] [<c020a44c>] (arch_cpu_idle) from [<c0c1316c>]
> >>>>>>> (default_idle_call+0x34/0x48)
> >>>>>>> [   10.943403] [<c0c13138>] (default_idle_call) from [<c02580c0>]
> >>>>>>> (do_idle+0x1d4/0x2c0)
> >>>>>>> [   10.951164] [<c0257eec>] (do_idle) from [<c0258494>]
> >>>>>>> (cpu_startup_entry+0x28/0x2c)
> >>>>>>> [   10.958752]  r10:00000000 r9:420f00f3 r8:00007000 r7:c22ce318
> >>>>>>> r6:30c0387d r5:00000002
> >>>>>>> [   10.966598]  r4:0000008a
> >>>>>>> [   10.969142] [<c025846c>] (cpu_startup_entry) from [<c0211644>]
> >>>>>>> (secondary_start_kernel+0x17c/0x1a0)
> >>>>>>> [   10.978210] [<c02114c8>] (secondary_start_kernel) from [<0020270c>]
> >>>>>>> (0x20270c)
> >>>>>>> [   10.985447]  r5:00000000 r4:090eaa40
> >>>>>>> [   10.989032] CPU3: stopping
> >>>>>>> [   10.991754] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D
> >>>>>>>  5.4.105-1.0pre-geff642e2af2b #4
> >>>>>>> [   11.000992] Hardware name: Broadcom STB (Flattened Device Tree)
> >>>>>>> [   11.006924] Backtrace:
> >>>>>>> [   11.009384] [<c020dd30>] (dump_backtrace) from [<c020e04c>]
> >>>>>>> (show_stack+0x20/0x24)
> >>>>>>> [   11.016972]  r7:c22a86d0 r6:00000000 r5:600f0193 r4:c22a86d0
> >>>>>>> [   11.022649] [<c020e02c>] (show_stack) from [<c0c09924>]
> >>>>>>> (dump_stack+0xb8/0xe4)
> >>>>>>> [   11.029892] [<c0c0986c>] (dump_stack) from [<c0212160>]
> >>>>>>> (handle_IPI+0x344/0x3cc)
> >>>>>>> [   11.037307]  r10:00000000 r9:c2205400 r8:00000000 r7:00000003
> >>>>>>> r6:c22b0744 r5:00000004
> >>>>>>> [   11.045154]  r4:c22ce308 r3:00976ec2
> >>>>>>> [   11.048741] [<c0211e1c>] (handle_IPI) from [<c0202254>]
> >>>>>>> (gic_handle_irq+0x9c/0xa0)
> >>>>>>> [   11.056329]  r10:00000000 r9:d1003000 r8:d1002000 r7:c9133f18
> >>>>>>> r6:d100200c r5:c220565c
> >>>>>>> [   11.064176]  r4:c226d668
> >>>>>>> [   11.066719] [<c02021b8>] (gic_handle_irq) from [<c0201a3c>]
> >>>>>>> (__irq_svc+0x5c/0x7c)
> >>>>>>> [   11.074216] Exception stack(0xc9133f18 to 0xc9133f60)
> >>>>>>> [   11.079280] 3f00:
> >>>>>>>    c020a47c 00000000
> >>>>>>> [   11.087476] 3f20: 0e4dd000 600f0093 c9132000 c2204cf0 c2204d34
> >>>>>>> 00000008 00000000 c20757b0
> >>>>>>> [   11.095671] 3f40: 00000000 c9133f74 c9132000 c9133f68 00000000
> >>>>>>> c020a480 600f0013 ffffffff
> >>>>>>> [   11.103867]  r9:c9132000 r8:00000000 r7:c9133f4c r6:ffffffff
> >>>>>>> r5:600f0013 r4:c020a480
> >>>>>>> [   11.111633] [<c020a44c>] (arch_cpu_idle) from [<c0c1316c>]
> >>>>>>> (default_idle_call+0x34/0x48)
> >>>>>>> [   11.119744] [<c0c13138>] (default_idle_call) from [<c02580c0>]
> >>>>>>> (do_idle+0x1d4/0x2c0)
> >>>>>>> [   11.127506] [<c0257eec>] (do_idle) from [<c0258494>]
> >>>>>>> (cpu_startup_entry+0x28/0x2c)
> >>>>>>> [   11.135093]  r10:00000000 r9:420f00f3 r8:00007000 r7:c22ce318
> >>>>>>> r6:30c0387d r5:00000003
> >>>>>>> [   11.142939]  r4:0000008a
> >>>>>>> [   11.145484] [<c025846c>] (cpu_startup_entry) from [<c0211644>]
> >>>>>>> (secondary_start_kernel+0x17c/0x1a0)
> >>>>>>> [   11.154550] [<c02114c8>] (secondary_start_kernel) from [<0020270c>]
> >>>>>>> (0x20270c)
> >>>>>>> [   11.161788]  r5:00000000 r4:090eaa40
> >>>>>>> [   11.165372] CPU1: stopping
> >>>>>>> [   11.168094] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D
> >>>>>>>  5.4.105-1.0pre-geff642e2af2b #4
> >>>>>>> [   11.177332] Hardware name: Broadcom STB (Flattened Device Tree)
> >>>>>>> [   11.183264] Backtrace:
> >>>>>>> [   11.185723] [<c020dd30>] (dump_backtrace) from [<c020e04c>]
> >>>>>>> (show_stack+0x20/0x24)
> >>>>>>> [   11.193311]  r7:c22a86d0 r6:00000000 r5:600c0193 r4:c22a86d0
> >>>>>>> [   11.198988] [<c020e02c>] (show_stack) from [<c0c09924>]
> >>>>>>> (dump_stack+0xb8/0xe4)
> >>>>>>> [   11.206230] [<c0c0986c>] (dump_stack) from [<c0212160>]
> >>>>>>> (handle_IPI+0x344/0x3cc)
> >>>>>>> [   11.213644]  r10:00000000 r9:c2205400 r8:00000000 r7:00000001
> >>>>>>> r6:c22b0744 r5:00000004
> >>>>>>> [   11.221491]  r4:c22ce308 r3:00976ec2
> >>>>>>> [   11.225078] [<c0211e1c>] (handle_IPI) from [<c0202254>]
> >>>>>>> (gic_handle_irq+0x9c/0xa0)
> >>>>>>> [   11.232666]  r10:00000000 r9:d1003000 r8:d1002000 r7:c912ff18
> >>>>>>> r6:d100200c r5:c220565c
> >>>>>>> [   11.240512]  r4:c226d668
> >>>>>>> [   11.243054] [<c02021b8>] (gic_handle_irq) from [<c0201a3c>]
> >>>>>>> (__irq_svc+0x5c/0x7c)
> >>>>>>> [   11.250553] Exception stack(0xc912ff18 to 0xc912ff60)
> >>>>>>> [   11.255617] ff00:
> >>>>>>>    c020a47c 00000000
> >>>>>>> [   11.263814] ff20: 0e4b7000 600c0093 c912e000 c2204cf0 c2204d34
> >>>>>>> 00000002 00000000 c20757b0
> >>>>>>> [   11.272010] ff40: 00000000 c912ff74 c912e000 c912ff68 00000000
> >>>>>>> c020a480 600c0013 ffffffff
> >>>>>>> [   11.280206]  r9:c912e000 r8:00000000 r7:c912ff4c r6:ffffffff
> >>>>>>> r5:600c0013 r4:c020a480
> >>>>>>> [   11.287970] [<c020a44c>] (arch_cpu_idle) from [<c0c1316c>]
> >>>>>>> (default_idle_call+0x34/0x48)
> >>>>>>> [   11.296081] [<c0c13138>] (default_idle_call) from [<c02580c0>]
> >>>>>>> (do_idle+0x1d4/0x2c0)
> >>>>>>> [   11.303842] [<c0257eec>] (do_idle) from [<c0258494>]
> >>>>>>> (cpu_startup_entry+0x28/0x2c)
> >>>>>>> [   11.311430]  r10:00000000 r9:420f00f3 r8:00007000 r7:c22ce318
> >>>>>>> r6:30c0387d r5:00000001
> >>>>>>> [   11.319275]  r4:0000008a
> >>>>>>> [   11.321819] [<c025846c>] (cpu_startup_entry) from [<c0211644>]
> >>>>>>> (secondary_start_kernel+0x17c/0x1a0)
> >>>>>>> [   11.330886] [<c02114c8>] (secondary_start_kernel) from [<0020270c>]
> >>>>>>> (0x20270c)
> >>>>>>> [   11.338124]  r5:00000000 r4:090eaa40
> >>>>>>> [   11.341729] ---[ end Kernel panic - not syncing: Fatal exception in
> >>>>>>> interrupt ]---
> >>>>>>>
> >>>>>>> it is not marked as fixing anything so I wonder how it landed in stable?
> >>>>>>
> >>>>>> It was requested to be merged.
> >>>>>
> >>>>> OK.
> >>>>>
> >>>>>> Do you have the same crash on newer kernels with this commit in it (like Linus's tree?)
> >>>>>
> >>>>> There are no crashes with 5.10 or upstream otherwise it would have been
> >>>>> noticed earlier, I have not kept track of which additional changes/fixes
> >>>>> we may need but I would suggest we drop this one for now.
> >>>>>
> >>>>> Alexander, do you want me to test additional patches if your change
> >>>>> somehow must be included in an upcoming 5.4? I thought the platform you
> >>>>> are working is still not upstream, so who is going to benefit from this
> >>>>> performance improvement?
> > 
> > Hello Florian!
> > 
> > I have heavily tested this change backported to 4.19 and 5.4 kernels and
> > it radically increased network performance on DSA setup with mv88e6xxx
> > switch. I have not seen any stability issues. So based on tests I have
> > sent backport request as patch is relatively small, is already in
> > mainline kernel and can be cleanly applied to 4.19 and 5.4 kernel.
> > 
> > But if this patch really cause issues, I think based on 'no regression'
> > rule we have no other options, just to drop this patch from stable
> > queue.
> > 
> > Greg, please drop this patch (for now).
> > 
> > But I would be really interested why this patch does not cause any
> > regression with mainline kernel and cause with 5.4...
> > 
> > Florian, which DSA driver and hardware is causing this issue?
> 
> This is using drivers/net/dsa/bcm_sf2.c for the switch driver (which
> uses b53 as the library for switch operations) and
> drivers/net/ethernet/broadcom/bcmsysport.c for the DSA "master".
> 
> > 
> > Could you checkout kernel at e131a5634830047923c694b4ce0c3b31745ff01b
> > commit and test if this issue happen too?
> > 
> >> This patch was added to stable trees by Pali, not me (link: [0]).
> >> I added him to Ccs, so you can ask him. As you noted correctly,
> >> I don't work on/with stable releases.
> >>
> >>>> Is 4.19 also failing for you now?
> >>>
> >>> I cannot easily test 4.19 without applying some additional patches
> >>> bringing in various ARM SCMI changes, I would suspect the same to
> >>> happen. Give me a few hours and I will see if I can give you a better
> >>> answer with an actual test.
> > 
> > Ok, if you have some results let me know.
> 
> I did test 4.19 eventually and was not able to reproduce the problem,
> and have not been able to reproduce the problem on 5.4 a second time
> around and ever since merging v5.4.105 in the past couple weeks.
> 
> I would consider this a non-issue and just a fluke. The board that
> exposed the problem is known for having power distribution issues when
> an aggressive CPU frequency scaling governor like schedutil is used. And
> it makes sense that the CPU frequency would be changed when traffic
> picks up. The boards have since been hard coded to the "performance"
> governor, that is the problematic ones at least.

THanks for tracking this down and letting us know.

greg k-h
