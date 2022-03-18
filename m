Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A880F4DDBCE
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 15:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiCROkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 10:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiCROkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 10:40:12 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2090ABF022;
        Fri, 18 Mar 2022 07:38:51 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nVDkd-0006nl-RZ; Fri, 18 Mar 2022 15:38:47 +0100
Message-ID: <4fb68d44-0d4f-df16-21b8-3d85ebe0aadc@leemhuis.info>
Date:   Fri, 18 Mar 2022 15:38:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Regression in 5.10.67: "iwlwifi: pcie: free RBs during configure"
 causes rx lockups with BAR_FRAME_RELEASE on AX200/AX201 when using 802.11ax
Content-Language: en-US
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Stephane Poignant <stephane.poignant@proton.ch>
References: <9e4ea11e-7d00-d2c4-7f80-862f0cbe96db@leemhuis.info>
In-Reply-To: <9e4ea11e-7d00-d2c4-7f80-862f0cbe96db@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647614332;166f3a55;
X-HE-SMSGID: 1nVDkd-0006nl-RZ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

FYI: looks like this isn't a regression, as Stephane mentioned in a
comment to the bko report:
https://bugzilla.kernel.org/show_bug.cgi?id=215660#c13

> So today i could reproduce on 5.10.46 after a few days of testing. It does not look like a regression.

Thus removing it from the regression tracking:

#regzbot invalid: After further testing it does not look like a
regression anymore

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.


On 14.03.22 12:44, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
> 
> I noticed a regression report in bugzilla.kernel.org that afaics nobody
> acted upon since it was reported more than ten days ago (it afaifcs only
> later became clear this is a regression), that's why I decided to
> forward it to the lists and a few relevant people to the CC. To quote
> from https://bugzilla.kernel.org/show_bug.cgi?id=215660:
> 
>>  Stephane Poignant 2022-03-04 17:24:49 UTC
>>
>> Created attachment 300529 [details]
>> lspci and ethtool outputs on reproducing systems
>>
>> Context:
>> - dense enterprise deployment, 10 lightweight aps (Aruba) on one office floor, up to 125 concurrent users total, up to 25 user per AP
>> - the wireless network supports 802.11n, 802.11ac and 802.11ax in 5 GHz band
>> - authentication is wpa2-psk
>> - client devices consists in a variety of endpoints (laptops, cell phones, tablets, smart devices), running various versions of Mac OSX, Linux, Windows, Android or IOS.
>> - certain clients supports only 20Mhz, HT protection kicks in and turns off on APs as those clients are moving around. Consequently ht_operation_mode fluctuates between 4 and 6 even when staying on the same AP.
>> - the issue affects various laptops with Intel AX200 or AX201 chipsets, running Debian or Ubuntu with a recent kernel >= 5.10
>> - see attached file devices.txt for detailed information on the different laptops we have reproduced the issue on
>>
>>
>> Steps to reproduce:
>> - appears sometimes, but not always, after the iwlwifi STA roams from one AP to another
>> - seen more often when ht_operation_mode changes between 4 and 6 (but not sufficient to trigger the issue)
>> - STA deassociates from current AP and associates to the new one successfully
>> - connectivity works on the new AP for a short period of time, usually between 30s and 1 minute
>> - then suddenly, the Rx path breaks. No more received frame visible on the STA wireless interface. AP reports that frames are retransmitted and not acknowledged by STA.
>> - the Tx path keeps working. Frames sent by STA to AP are received and visible on the network
>> - in this state each inbound frame appears to trigger iwl_pcie_rx_handle_rb with cmd BAR_FRAME_RELEASE (seqnum is always the same):
>>
>> Mar  4 12:44:32 debian kernel: [15884.715812] iwlwifi 0000:00:14.3: iwl_pcie_rx_handle Q 0: HW = 338, SW = 337
>> Mar  4 12:44:32 debian kernel: [15884.715819] iwlwifi 0000:00:14.3: iwl_pcie_get_rxb Got virtual RB ID 1348
>> Mar  4 12:44:32 debian kernel: [15884.715831] iwlwifi 0000:00:14.3: iwl_pcie_rx_handle_rb Q 0: cmd at offset 0: BAR_FRAME_RELEASE (00.c2, seq 0xbfff)
>> Mar  4 12:44:32 debian kernel: [15884.715838] iwlwifi 0000:00:14.3: iwl_mvm_release_frames_from_notif Frame release notification for BAID 14, NSSN 169
>> Mar  4 12:44:32 debian kernel: [15884.715843] iwlwifi 0000:00:14.3: iwl_pcie_rx_handle_rb Q 0: RB end marker at offset 64
>> Mar  4 12:44:32 debian kernel: [15884.715852] iwlwifi 0000:00:14.3: iwl_pcie_restock_bd Assigned virtual RB ID 1348 to queue 0 index 334
>>
>> - those events do not appear during normal operation (or very rarely)
>>
>>
>> Temporary resolution:
>> - in most cases, the STA remains in this state until Wifi is restarted or until it roams to another AP
>> - while in that state, it may happens (rarely) that a few frame are received with very high latency, then the next ones are lost, for instance:
>>
>> [1646398334.114200] From 10.200.2.67 icmp_seq=148 Destination Host Unreachable
>> [1646398334.114242] From 10.200.2.67 icmp_seq=149 Destination Host Unreachable
>> [1646398334.114251] From 10.200.2.67 icmp_seq=150 Destination Host Unreachable
>> [1646398336.365181] 64 bytes from 10.200.2.1: icmp_seq=151 ttl=64 time=2251 ms
>> [1646398336.365237] 64 bytes from 10.200.2.1: icmp_seq=152 ttl=64 time=1227 ms
>> [1646398336.365250] 64 bytes from 10.200.2.1: icmp_seq=153 ttl=64 time=203 ms
>> [1646398375.042236] From 10.200.2.67 icmp_seq=188 Destination Host Unreachable
>> [1646398375.042291] From 10.200.2.67 icmp_seq=189 Destination Host Unreachable
>> [1646398375.042303] From 10.200.2.67 icmp_seq=190 Destination Host Unreachable
>>
>>
>> Workaround:
>> - disable_11ax=1 prevents the problem from happening
>> [...]
> 
>>  Stephane Poignant 2022-03-10 14:48:39 UTC
>>
>> Did some further testing with vanilla kernel.
>> 5.10.66 and older DO NOT reproduce the issue.
>> 5.10.67 and newer DO reproduce.
>>
>> I see the following changes according to changelog:
>> iwlwifi: mvm: Fix scan channel flags settings
>> iwlwifi: fw: correctly limit to monitor dump
>> iwlwifi: mvm: fix access to BSS elements
>> iwlwifi: mvm: avoid static queue number aliasing
>> iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed
>> iwlwifi: pcie: free RBs during configure
>>
>> Suspecting the one related with queues but no strong opinion atm.
>>
>> [reply] [−] Comment 6 Stephane Poignant 2022-03-11 10:18:29 UTC
>>
>> Ok so after some further testing, turned out that after commenting the following lines in file drivers/net/wireless/intel/iwlwifi/pcie/trans.c:
>>
>> 	/* free all first - we might be reconfigured for a different size */
>> 	iwl_pcie_free_rbs_pool(trans);
>>
>> Which were introduced by the following commit:
>> iwlwifi: pcie: free RBs during configure
>> https://lore.kernel.org/all/iwlwifi.20210802170640.42d7c93279c4.I07f74e65aab0e3d965a81206fcb289dc92d74878@changeid/
>>
>> Then i'm no longer able to reproduce. Tested in vanilla 5.10.67, vanilla 5.10.88 and 5.10.92 with Debian patches.
>>
> 
> Could somebody take a look into this? Or was this discussed somewhere
> else already? Or even fixed?
> 
> Anyway, to get this tracked:
> 
> #regzbot introduced: 608c8359c567b4a04dedbe
> #regzbot from: Stephane Poignant <stephane.poignant@proton.ch>
> #regzbot title: wireless: iwlwifi: regression in 5.10.67 due to
> "iwlwifi: pcie: free RBs during configure"
> #regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215660
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> 
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.
> 
