Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543DA542F47
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbiFHLeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbiFHLeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:34:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05CC1952DE
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 04:34:08 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CE1FD21C10;
        Wed,  8 Jun 2022 11:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654688046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0bI6NQkdcqzfmd5MbWk7xWbVVFWqAvkxvx/OvzUMfFs=;
        b=3XYjeeU7D/gDqc1Vr+evYKk/KOHYqrkIfxtS/ClZJRjgzhFYvp8+Bzx+swZe68NtceRpOo
        c+kM6vEhf59Te4tqo2bjGKMSK1WKKB5P2+yO0glDsDqP39IsuDigZbG3eCeb1GUnfxXqP1
        e3CPYWBKPT1QToWiLHuVPBJD8hV0xHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654688046;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0bI6NQkdcqzfmd5MbWk7xWbVVFWqAvkxvx/OvzUMfFs=;
        b=/wHRFX9VJklcvmg5zXX4xqhRH6Ty+0fEuzDr9BMSSSiC7oB2waJo88KJRxBAn2LweE3CAm
        dA5owGN1BinABwCQ==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 335872C141;
        Wed,  8 Jun 2022 11:34:06 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E35D9A06E2; Wed,  8 Jun 2022 13:34:04 +0200 (CEST)
Date:   Wed, 8 Jun 2022 13:34:04 +0200
From:   Jan Kara <jack@suse.cz>
To:     =?utf-8?B?0KHRgtCw0YEg0J3QuNGH0LjQv9C+0YDQvtCy0LjRhw==?= 
        <stasn77@gmail.com>
Cc:     jack@suse.cz, yukuai3@huawei.com, stable@vger.kernel.org
Subject: Re: bfq patches kernel panic
Message-ID: <20220608113404.hso3pvmavku2mcvb@quack3.lan>
References: <CAH37n11siy2LoVODrGvkZ=J7-V3dXXFnbw=J2MJ59idCmZc2VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH37n11siy2LoVODrGvkZ=J7-V3dXXFnbw=J2MJ59idCmZc2VA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Wed 08-06-22 14:13:07, Стас Ничипорович wrote:
> After applying 5.15.46-rc1 series including your BFQ patches I've got
> kernel panics

Thanks for report! So apparently you are missing commit
22b106e535 ("block: fix bio_clone_blkg_association() to associate with
proper blkcg_gq") from upstream. Now I can see it didn't get included into
5.15-stable tree and I didn't notice. I'll send it for inclusion. Thanks
for testing!

								Honza

> 
> <1>[ 1318.650124][T12771] BUG: kernel NULL pointer dereference, address:
> 0000000000000094
> <1>[ 1318.661974][T12771] #PF: supervisor read access in kernel mode
> <1>[ 1318.673527][T12771] #PF: error_code(0x0000) - not-present page
> <6>[ 1318.684968][T12771] PGD 0 P4D 0
> <4>[ 1318.696208][T12771] Oops: 0000 [#1] PREEMPT SMP
> <4>[ 1318.707450][T12771] CPU: 3 PID: 12771 Comm: worker Not tainted
> 5.15.46++ #14
> <4>[ 1318.719193][T12771] Hardware name: To Be Filled By O.E.M. To Be
> Filled By O.E.M./H77 Pro4-M, BIOS P2.00 08/06/2013
> <4>[ 1318.731709][T12771] RIP: 0010:bfq_bic_update_cgroup+0x40/0x230
> <4>[ 1318.744261][T12771] Code: 84 ff ff 48 89 c5 49 8b 45 48 48 85 c0 74
> 3c 48 63 15 84 af f3 00 48 83 c2 16 eb 09 48 8b 40 30 48 85 c0 74 26 48 8b
> 5c d0 08 <80> bb 94 00 00 00 0
> 0 74 e9 48 8b 70 28 4c 89 ef 49 89 de e8 18 53
> <4>[ 1318.771464][T12771] RSP: 0018:ffff8881bca9fa08 EFLAGS: 00010002
> <4>[ 1318.785406][T12771] RAX: ffff8881001e9200 RBX: 0000000000000000 RCX:
> 0000000000000000
> <4>[ 1318.799732][T12771] RDX: 000000000000001a RSI: ffff8881173e20c0 RDI:
> ffff8883c08242b8
> <4>[ 1318.814204][T12771] RBP: ffff8881033a7000 R08: 0000000000000040 R09:
> ffff888102720880
> <4>[ 1318.828954][T12771] R10: ffff8881173e26c0 R11: ffff8881009b4000 R12:
> ffff8883c08242b8
> <4>[ 1318.843786][T12771] R13: ffff8881173e20c0 R14: 0000000000000001 R15:
> ffff8881033a7000
> <4>[ 1318.858607][T12771] FS:  00007f0d48248640(0000)
> GS:ffff88840f780000(0000) knlGS:0000000000000000
> <4>[ 1318.873792][T12771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[ 1318.889046][T12771] CR2: 0000000000000094 CR3: 00000001051d8004 CR4:
> 00000000001726e0
> <4>[ 1318.904570][T12771] Call Trace:
> <4>[ 1318.919982][T12771]  <TASK>
> <4>[ 1318.935283][T12771]  bfq_bio_merge+0x95/0x110
> <4>[ 1318.950664][T12771]  blk_mq_submit_bio+0xc1/0x5d0
> <4>[ 1318.966075][T12771]  submit_bio_noacct+0x97/0x280
> <4>[ 1318.981419][T12771]  submit_bio_wait+0x3e/0x60
> <4>[ 1318.996660][T12771]  blkdev_issue_discard+0x69/0xa0
> <4>[ 1319.011918][T12771]  ? ext4_get_group_desc+0x55/0xe0
> <4>[ 1319.027159][T12771]  ext4_free_blocks+0xa7e/0xc60
> <4>[ 1319.042363][T12771]  ext4_ext_remove_space+0xbb5/0x17a0
> <4>[ 1319.057612][T12771]  ext4_punch_hole+0x2bd/0x5c0
> <4>[ 1319.072893][T12771]  ext4_fallocate+0x58d/0x1210
> <4>[ 1319.088175][T12771]  ? __wake_up_locked_key+0x3d/0x70
> <4>[ 1319.103635][T12771]  ? eventfd_write+0xc6/0x230
> <4>[ 1319.119143][T12771]  ? __rseq_handle_notify_resume+0x2e9/0x410
> <4>[ 1319.134801][T12771]  vfs_fallocate+0x143/0x320
> <4>[ 1319.150477][T12771]  __x64_sys_fallocate+0x37/0x60
> <4>[ 1319.166390][T12771]  do_syscall_64+0x35/0xb0
> <4>[ 1319.182223][T12771]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> <4>[ 1319.198228][T12771] RIP: 0033:0x7f0f63dbd5e7
> <4>[ 1319.214202][T12771] Code: 89 7c 24 08 48 89 4c 24 18 e8 45 35 f9 ff
> 4c 8b 54 24 18 41 89 c0 48 8b 54 24 10 b8 1d 01 00 00 8b 74 24 0c 8b 7c 24
> 08 0f 05 <48> 3d 00 f0 ff ff 7
> 7 31 44 89 c7 89 44 24 08 e8 95 35 f9 ff 8b 44
> <4>[ 1319.248261][T12771] RSP: 002b:00007f0d48245fb0 EFLAGS: 00000293
> ORIG_RAX: 000000000000011d
> <4>[ 1319.265896][T12771] RAX: ffffffffffffffda RBX: 0000000000410000 RCX:
> 00007f0f63dbd5e7
> <4>[ 1319.283735][T12771] RDX: 0000000ceb0e0000 RSI: 0000000000000003 RDI:
> 000000000000000f
> <4>[ 1319.301507][T12771] RBP: 00007f0d404f0bb0 R08: 0000000000000000 R09:
> 0000000000000000
> <4>[ 1319.319443][T12771] R10: 0000000000410000 R11: 0000000000000293 R12:
> 000000000000000f
> <4>[ 1319.337141][T12771] R13: 00007f0f62ffa180 R14: 0000000ceb0e0000 R15:
> 00007f0d47a48000
> <4>[ 1319.354677][T12771]  </TASK>
> <4>[ 1319.371656][T12771] Modules linked in: ramoops pstore reed_solomon
> msr nf_nat_irc nf_nat_amanda nf_nat_ftp nf_nat_sip nf_nat_tftp nf_nat_h323
> nf_nat_pptp nf_nat_snmp_basic n
> f_conntrack_tftp nf_conntrack_irc xt_conntrack nf_conntrack_sane
> nf_conntrack_netlink nfnetlink nf_conntrack_netbios_ns nf_conntrack_pptp
> nf_conntrack_sip nf_conntrack_ftp ts_kmp
> nf_conntrack_amanda nf_conntrack_h323 nf_conntrack_snmp
> nf_conntrack_broadcast nf_conntrack_bridge xt_CHECKSUM xt_tcpudp xt_LOG
> nf_log_syslog bpfilter iptable_mangle iptable_raw i
> ptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter
> ip6_tables ip_tables x_tables bridge hmac ipv6 fuse vsock vhost_net vhost
> vhost_iotlb e1000e ptp x86_pk
> g_temp_thermal intel_powerclamp pps_core kvm_intel dm_multipath dm_mod kvm
> iTCO_wdt dax irqbypass ifb i2c_i801 crct10dif_pclmul iTCO_vendor_support
> ghash_clmulni_intel nct6775 i2c
> _smbus rapl i2c_core intel_cstate hwmon_vid button edac_core lpc_ich
> mfd_core coretemp hwmon
> <4>[ 1319.371693][T12771]  crc32_pclmul xhci_pci xhci_hcd ehci_pci ehci_hcd
> usbcore usb_common
> <4>[ 1319.546474][T12771] CR2: 0000000000000094
> <4>[ 1319.566281][T12771] ---[ end trace c195da15021620fa ]---
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
