Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E2D3B0CDA
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 20:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhFVS1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 14:27:53 -0400
Received: from mail.univention.de ([82.198.197.8]:24551 "EHLO
        mail.univention.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhFVS1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 14:27:52 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2021 14:27:52 EDT
Received: from localhost (localhost [127.0.0.1])
        by solig.knut.univention.de (Postfix) with ESMTP id 467141386D6E7;
        Tue, 22 Jun 2021 20:18:56 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.10.1 (20141025) (Debian) at
        knut.univention.de
Received: from mail.univention.de ([127.0.0.1])
        by localhost (solig.knut.univention.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G1Weg74jHaN7; Tue, 22 Jun 2021 20:18:54 +0200 (CEST)
Received: from [192.168.178.43] (p54909576.dip0.t-ipconnect.de [84.144.149.118])
        by solig.knut.univention.de (Postfix) with ESMTPSA id D5C731386D6DE;
        Tue, 22 Jun 2021 20:18:53 +0200 (CEST)
To:     stable@vger.kernel.org, 892105@bugs.debian.org,
        Ben Hutchings <benh@debian.org>
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>, carnil@debian.org
From:   Philipp Hahn <hahn@univention.de>
Organization: Univention GmbH
Subject: Cherry-pick "i40e: Be much more verbose about what we can and cannot
 offload"
Message-ID: <937dd880-f902-aa9c-67d5-2d582a29e122@univention.de>
Date:   Tue, 22 Jun 2021 20:18:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I request the following patch from v4.10-rc1 to get cherry-picked into 
"stable/linux-4.9.y":

> commit f114dca2533ca770aebebffb5ed56e5e7d1fb3fb
> Author: Alexander Duyck <alexander.h.duyck@intel.com>
> Date:   Tue Oct 25 16:08:46 2016 -0700
> 
>     i40e: Be much more verbose about what we can and cannot offload
>     
>     This change makes it so that we are much more robust about defining what we
>     can and cannot offload.  Previously we were just checking for the L4 tunnel
>     header length, however there are other fields we should be verifying as
>     there are multiple scenarios in which we cannot perform hardware offloads.
>     
>     In addition the device only supports GSO as long as the MSS is 64 or
>     greater.  We were not checking this so an MSS less than that was resulting
>     in Tx hangs.
>     
>     Change-ID: I5e2fd5f3075c73601b4b36327b771c64fcb6c31b
>     Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>     Tested-by: Andrew Bowers <andrewx.bowers@intel.com>

Debian had this old Bug 
<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=892105> reported 
against 4.9.82, which still exists in Debians old-stable 9 "Stretch" 
current kernel 4.9.258, but also with latest stable 4.9.273.


Our environment
===============
- KVM server
- dual port i40e
- classic bridge with enp96s0f0
- VM attached to bridge via veth
- no VLANs
- no MacVLan

> # ethtool -i enp96s0f0
> driver: i40e
> version: 1.6.16-k
> firmware-version: 3.33 0x80000e48 1.1876.0
> expansion-rom-version: 
> bus-info: 0000:60:00.0
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: ye

> # lspci -s 0000:60:00.0
> 60:00.0 Ethernet controller: Intel Corporation Ethernet Connection X722 for 10GBASE-T (rev 09)


Analysis
========
As soon as we start one of our "Ubuntu" images the bridge stops 
receiving unicast packages for *all* VMs on that bridge.
- we still see outgoing traffic leaving the host, e.g. ARP requests
- "tcpdump -i enp96s0f0" shows no incoming unicast traffic, e.g. no ARP 
response
- broadcast traffic passes the bridge
- VMs on the same bridge can communicate with each other

Most often I see the following error message after doing `dmesg -n 8`:
> [  +9,376367] i40e 0000:60:00.0: cleared PE_CRITERR
> [  +0,000252] i40e 0000:60:00.0: TX driver issue detected, PF reset issued
> [  +0,859912] i40e 0000:60:00.0: Error I40E_AQ_RC_EINVAL adding RX filters on PF, promiscuous mode forced on

In one case I've seen this also (don't know if it is relevant):
> [  218.921466] i40e 0000:60:00.0 enp96s0f0: VSI_seid 390, Hung TX queue 43, tx_pending_hw: 1, NTC:0xa6, HWB: 0xa6, NTU: 0xa7, TAIL: 0xa7
> [  218.921470] i40e 0000:60:00.0 enp96s0f0: VSI_seid 390, Issuing force_wb for TX queue 43, Interrupt Reg: 0x0

After that error the only way to reset this broken state it to reboot 
the host. I've been unable to tear down the bridge and/or remove the 
`i40e` driver, which most often crashes the Linux kernel (some other bug 
on `ip link set enp96s0f0 nomaster`).

If you need more data I have a PCAP file, but I still don't know which 
packet exactly triggers the bug.


The bugs seems to be fixed with 4.10.0 and I bisected it down to

> git bisect start '--' 'drivers/net/ethernet/intel/i40e'
> # new: [c470abd4fde40ea6a0846a2beab642a578c0b8cd] Linux 4.10
> git bisect new c470abd4fde40ea6a0846a2beab642a578c0b8cd
> # old: [69973b830859bc6529a7a0468ba0d80ee5117826] Linux 4.9
> git bisect old 69973b830859bc6529a7a0468ba0d80ee5117826
> # old: [13fd3f9cc3def8b276c7913ae4acbfa2653cb198] i40e: clear mac filter count on reset
> git bisect old 13fd3f9cc3def8b276c7913ae4acbfa2653cb198
> # new: [7ec9ba11b046b4b7fd768c366870ada60d409295] i40e: Driver prints log message on link speed change
> git bisect new 7ec9ba11b046b4b7fd768c366870ada60d409295
> # new: [0b7c8b5d5436317a5f4509e2a150c6cec017f348] i40e: fix trivial typo in naming of i40e_sync_filters_subtask
> git bisect new 0b7c8b5d5436317a5f4509e2a150c6cec017f348
> # new: [f114dca2533ca770aebebffb5ed56e5e7d1fb3fb] i40e: Be much more verbose about what we can and cannot offload
> git bisect new f114dca2533ca770aebebffb5ed56e5e7d1fb3fb
> # old: [81fa7c97bebd6e1a52c4e059eeffe18df5b3f11f] i40e: Implementation of ERROR state for NVM update state machine
> git bisect old 81fa7c97bebd6e1a52c4e059eeffe18df5b3f11f
> # old: [3aa7b74dbeedfb32406fec70cfd76d797209e8c9] i40e: removed unreachable code
> git bisect old 3aa7b74dbeedfb32406fec70cfd76d797209e8c9
> # first new commit: [f114dca2533ca770aebebffb5ed56e5e7d1fb3fb] i40e: Be much more verbose about what we can and cannot offload

I used v4.10 as the basis and only bisected everything in 
drivers/net/ethernet/intel/i40e/ as vanilla v4.9 and several other 
versions between that and v4.10 crashed my host, so basically
   git checkout v4.10
   git checkout $hash -- drivers/net/ethernet/intel/i40e/
   make all modules_install install
   git checkout v4-10 -- drivers/net/ethernet/intel/i40e/
   git bisect (old|new) $hash

I verified that cherry-picking f114dca2533ca770aebebffb5ed56e5e7d1fb3fb 
on top of v4.9.273 fixes the problem and reverting it again shows the 
problem again.

Philipp
-- 
Philipp Hahn
Open Source Software Engineer

Univention GmbH
be open.
Mary-Somerville-Str. 1
D-28359 Bremen

📞 +49-421-22232-57
🖶 +49-421-22232-99

✉️ hahn@univention.de
🌐 https://www.univention.de/

Geschäftsführer: Peter H. Ganten
HRB 20755 Amtsgericht Bremen
Steuer-Nr.: 71-597-02876
