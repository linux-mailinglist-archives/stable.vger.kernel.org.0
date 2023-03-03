Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B106A9174
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 08:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCCHKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 02:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCCHKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 02:10:55 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A3F18B23;
        Thu,  2 Mar 2023 23:10:53 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pXzZ5-0006KW-PD; Fri, 03 Mar 2023 08:10:51 +0100
Message-ID: <ad02467d-d623-5933-67e0-09925c185568@leemhuis.info>
Date:   Fri, 3 Mar 2023 08:10:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     Simon Gaiser <simon@invisiblethingslab.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        emmi@emmixis.net, schwagsucks@gmail.com,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: [regression] Bug 217114 - Tiger Lake SATA Controller not operating
 correctly [bisected]
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677827454;ec66d175;
X-HE-SMSGID: 1pXzZ5-0006KW-PD
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org that apparently
affects 6.2 and later as well as 6.1.13 and later, as it was already
backported there.

As many (most?) kernel developer don't keep an eye on bugzilla, I
decided to forward the report by mail. Quoting from
https://bugzilla.kernel.org/show_bug.cgi?id=217114 :

>  emmi@emmixis.net 2023-03-02 11:25:00 UTC
> 
> As per kernel problem found in https://bbs.archlinux.org/viewtopic.php?id=283906 ,
> 
> Commit 104ff59af73aba524e57ae0fef70121643ff270e

[FWIW: That's "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller" from
Simon Gaiser]

> seems to have broken Intel Tiger Lake SATA controllers in a way that prevents boot, as the sysroot partition will not be found. 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=104ff59af73aba524e57ae0fef70121643ff270e
> 
> [tag] [reply] [−]
> Private
> Comment 1 schwagsucks@gmail.com 2023-03-02 17:31:53 UTC
> 
> As some people in the reference arch forum post reported this seems to have started in 6.1.13.  6.1.12 loads as expected.  
> 
> The problem is the sata disks can not be recognized any longer which is why the reported sysroot partition can't be found.  
> 
> My primary disk is nvme and as long as I remove all sata references from my fstab I can boot but then can't mount the device partitions because the devices are not present in /dev.  
> 
> Any attempts to boot with a sata disk in fstab results in a boot failure with emergency shell.
> 
> [tag] [reply] [−]
> Private
> Comment 2 schwagsucks@gmail.com 2023-03-02 19:31:28 UTC
> 
> I can provide any details required
> 
> My sata controller:
> 10000:e0:17.0 SATA controller: Intel Corporation Tiger Lake-LP SATA Controller (rev 20) (prog-if 01 [AHCI 1.0])
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 146
> 	Region 0: Memory at 50100000 (32-bit, non-prefetchable) [size=8K]
> 	Region 1: Memory at 50102800 (32-bit, non-prefetchable) [size=256]
> 	Region 5: Memory at 50102000 (32-bit, non-prefetchable) [size=2K]
> 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
> 		Address: fee01000  Data: 0000
> 	Capabilities: [70] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> 	Kernel driver in use: ahci
> 


See the ticket for more details.


[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: 104ff59af73a
https://bugzilla.kernel.org/show_bug.cgi?id=217114
#regzbot title: ata: ahci: Tiger Lake SATA Controller not operating
correctly
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
