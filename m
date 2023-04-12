Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72FC6E0147
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 23:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjDLV6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 17:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDLV6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 17:58:21 -0400
X-Greylist: delayed 368 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 14:58:15 PDT
Received: from schatzi.steelbluetech.co.uk (james.steelbluetech.co.uk [92.63.139.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE2661B4;
        Wed, 12 Apr 2023 14:58:15 -0700 (PDT)
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id 9DD81BFC4A;
        Wed, 12 Apr 2023 22:47:13 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk 9DD81BFC4A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1681336033; bh=3rmhInVAvvyPwrcsW8+rzkPVPy+Taf2HisgIN8AheJE=;
        h=Date:From:Subject:Reply-To:To:Cc:References:In-Reply-To:From;
        b=Bfsrem+b9xRGfO9yWhWPXCmIfQSo6sYRaGnT2s77k6NzLogslJGoVlPMLuOZBcyTm
         Wr4m8ihUfGYvJKpAP05J2OnmukYp371PHXbGGosaJUPg23SAv4WvTLPf3GNEFK7Fuk
         xHWKPHehxamQqY0zVxc/+1Wevg/sCqhOqNExC+68=
Message-ID: <97c9d345-b57c-8024-be35-357c8842115a@ehuk.net>
Date:   Wed, 12 Apr 2023 22:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Eddie Chapman <eddie@ehuk.net>
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review (possible amdgpu
 regression)
Reply-To: eddie@ehuk.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230412082823.045155996@linuxfoundation.org>
Content-Language: en-GB
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please let
> me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 

I think I'm seeing a regression here in the amdgpu driver, though not 
being a kernel dev I could be wrong.

I built and booted this today on an x86_64 machine (AMD Ryzen 7 3700X, 
Gigabyte X570 UD motherboard) with 3 x AMD graphics cards (using names 
from lspci output):
- Cape Verde GL [FirePro W4100]
- Oland XT [Radeon HD 8670 / R5 340X OEM / R7 250/350/350X OEM] (rev 83)
- Bonaire [Radeon R7 200 Series]

All three using the amdgpu driver (radeon module blacklisted).

This machine has been running vanilla 5.15 stable releases for a good 
while, with the kernel updated with whatever the latest 5.15 release is 
every 6 weeks or so. Never had any amdgpu problems.

To build 5.15.107-rc1 I applied the contents of the queue-5.15 directory 
on top of 5.15.106, having synced the stable queue git repo up until 
commit 344d8ad1b5dde387d1ce4d1be2641753b89dd10d (still the latest commit 
as a type). This is what I have done for years running vanilla stable 
kernels.

There was nothing out of the ordinary in the build output, but on 
rebooting into 5.15.107-rc1 I had the following error in dmesg from 1 
card only:

amdgpu 0000:0d:00.0: [drm:amdgpu_ib_ring_tests [amdgpu]] *ERROR* IB test 
failed on vce0 (-110).
[drm:process_one_work] *ERROR* ib ring test failed (-110).

This was during bootup immediately after driver loading. X is not 
running. 0000:0d:00.0 is the Bonaire card.

I then shutdown and fully powered off for a few minutes, booted 
5.15.107-rc1 again, but the error on that card persisted exactly the same.

This was a regression for me as I've never had that error before on any 
kernel release (I grepped through old kernel logs to check).

I then rebuilt 5.15.107-rc1 but without applying the following 4 patches:

drm-panfrost-fix-the-panfrost_mmu_map_fault_addr-error-path.patch
drm-amdgpu-fix-amdgpu_job_free_resources-v2.patch
drm-amdgpu-prevent-race-between-late-signaled-fences.patch
drm-bridge-lt9611-fix-pll-being-unable-to-lock.patch

On booting into the newly built kernel there was no error anymore, 
amdgpu dmesg output was as normal, and the machine is running fine now 
on that.

So I'm quite confident one of those patches introduced the error for me. 
Having now looked at the contents of them I see the lt9611 is entirely 
different hardware and I'm guessing the panfrost one probably is as 
well, so most likely I didn't need to remove those 2.

This is not a great report and maybe not helpful (sorry) as 
unfortunately I cannot try and narrow it down further to a single patch 
as this machine has to stay running now for a while. I just crudely 
tried yanking those 4 to hopefully get rid of the error and get the 
machine running again. Also I didn't go on to test whether the card 
actually worked as expected, maybe the error is harmless after all, 
though it doesn't look insignificant.

As the error was only output for the Bonaire card (the other two were 
fine), below is lspci -vvv output for that card only in case it helps. 
If anyone would like further info just let me know.

Eddie

0d:00.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] Bonaire [Radeon R7 200 Series] (prog-if 00 [VGA controller])
         Subsystem: Micro-Star International Co., Ltd. [MSI] Bonaire 
[Radeon R7 200 Series]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 135
         IOMMU group: 29
         Region 0: Memory at 880000000 (64-bit, prefetchable) [size=1G]
         Region 2: Memory at 860000000 (64-bit, prefetchable) [size=8M]
         Region 4: I/O ports at f000 [size=256]
         Region 5: Memory at fce00000 (32-bit, non-prefetchable) [size=256K]
         Expansion ROM at fce40000 [disabled] [size=128K]
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ NonFatalErr- FatalErr- UnsupReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16
                         TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, TimeoutDis- 
NROPrPrP- LTR-
                          10BitTagComp- 10BitTagReq- OBFF Not Supported, 
ExtFmt+ EETLPPrefix+, MaxEETLPPrefixes 1
                          EmergencyPowerReduction Not Supported, 
EmergencyPowerReductionInit-
                          FRS-
                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
LTR- 10BitTagReq- OBFF Disabled,
                          AtomicOpsCtl: ReqEn-
                 LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- 
Retimer- 2Retimers- DRS-
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance Preset/De-emphasis: -6dB 
de-emphasis, 0dB preshoot
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+ EqualizationPhase1+
                          EqualizationPhase2+ EqualizationPhase3+ 
LinkEqualizationRequest-
                          Retimer- 2Retimers- CrosslinkRes: unsupported
         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 0000
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [150 v2] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
AdvNonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
AdvNonFatalErr+
                 AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- 
ECRCChkCap+ ECRCChkEn-
                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
                 HeaderLog: 00000000 00000000 00000000 00000000
         Capabilities: [200 v1] Physical Resizable BAR
                 BAR 0: current size: 1GB, supported: 256MB 512MB 1GB
         Capabilities: [270 v1] Secondary PCI Express
                 LnkCtl3: LnkEquIntrruptEn- PerformEqu-
                 LaneErrStat: 0
         Capabilities: [2b0 v1] Address Translation Service (ATS)
                 ATSCap: Invalidate Queue Depth: 00
                 ATSCtl: Enable+, Smallest Translation Unit: 00
         Capabilities: [2c0 v1] Page Request Interface (PRI)
                 PRICtl: Enable- Reset-
                 PRISta: RF- UPRGI- Stopped+
                 Page Request Capacity: 00000020, Page Request 
Allocation: 00000000
         Capabilities: [2d0 v1] Process Address Space ID (PASID)
                 PASIDCap: Exec+ Priv+, Max PASID Width: 10
                 PASIDCtl: Enable- Exec- Priv-
         Kernel driver in use: amdgpu
         Kernel modules: radeon, amdgpu


