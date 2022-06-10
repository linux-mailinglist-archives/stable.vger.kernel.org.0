Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34782545C57
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 08:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiFJGg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 02:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235797AbiFJGg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 02:36:28 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8963B3ED23;
        Thu,  9 Jun 2022 23:36:27 -0700 (PDT)
X-UUID: 3f9cb46d5c784297a34e686183a61f57-20220610
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:3e581a6c-a06b-402a-afc6-2f198b03e587,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:2a19b09,CLOUDID:d3635de5-2ba2-4dc1-b6c5-11feb6c769e0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:-5,EDM:-3,IP:nil,URL:0,File:ni
        l,QS:0,BEC:nil
X-UUID: 3f9cb46d5c784297a34e686183a61f57-20220610
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <mark-pk.tsai@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 515166308; Fri, 10 Jun 2022 14:36:23 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Fri, 10 Jun 2022 14:36:22 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Fri, 10 Jun 2022 14:36:22 +0800
From:   Mark-PK Tsai <mark-pk.tsai@mediatek.com>
To:     <will@kernel.org>, <stable@vger.kernel.org>
CC:     <alexandru.elisei@arm.com>, <catalin.marinas@arm.com>,
        <jean-philippe.brucker@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <mark-pk.tsai@mediatek.com>,
        <matthias.bgg@gmail.com>, <maz@kernel.org>,
        <yj.chiang@mediatek.com>
Subject: Re: [PATCH] arm64: Clear OS lock in enable_debug_monitors
Date:   Fri, 10 Jun 2022 14:36:19 +0800
Message-ID: <20220610063619.7921-1-mark-pk.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220609115716.GA2427@willie-the-truck>
References: <20220609115716.GA2427@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Thu, Jun 09, 2022 at 11:33:18AM +0800, Mark-PK Tsai wrote:
> > Always clear OS lock before enable debug event.
> > 
> > The OS lock is clear in cpuhp ops in recent kernel,
> > but when the debug exception happened before it
> > kernel might crash because debug event enable didn't
> > take effect when OS lock is hold.
> > 
> > Below is the use case that having this problem:
> > 
> > Register kprobe in console_unlock and kernel will
> > panic at secondary_start_kernel on secondary core.
> > 
> > CPU: 1 PID: 0 Comm: swapper/1 Tainted: P
> > ...
> > pstate: 004001c5 (nzcv dAIF +PAN -UAO)
> > pc : do_undefinstr+0x5c/0x60
> > lr : do_undefinstr+0x2c/0x60
> > sp : ffffffc01338bc50
> > pmr_save: 000000f0
> > x29: ffffffc01338bc50 x28: ffffff8115e95a00 T
> > x27: ffffffc01258e000 x26: ffffff8115e95a00
> > x25: 00000000ffffffff x24: 0000000000000000
> > x23: 00000000604001c5 x22: ffffffc014015008
> > x21: 000000002232f000 x20: 00000000000000f0 j
> > x19: ffffffc01338bc70 x18: ffffffc0132ed040
> > x17: ffffffc01258eb48 x16: 0000000000000403 L&
> > x15: 0000000000016480 x14: ffffffc01258e000 i/
> > x13: 0000000000000006 x12: 0000000000006985
> > x11: 00000000d5300000 x10: 0000000000000000
> > x9 : 9f6c79217a8a0400 x8 : 00000000000000c5
> > x7 : 0000000000000000 x6 : ffffffc01338bc08 2T
> > x5 : ffffffc01338bc08 x4 : 0000000000000002
> > x3 : 0000000000000000 x2 : 0000000000000004
> > x1 : 0000000000000000 x0 : 0000000000000001 *q
> > Call trace:
> >  do_undefinstr+0x5c/0x60
> >  el1_undef+0x10/0xb4
> >  0xffffffc014015008
> >  vprintk_func+0x210/0x290
> >  printk+0x64/0x90
> >  cpuinfo_detect_icache_policy+0x80/0xe0
> >  __cpuinfo_store_cpu+0x150/0x160
> >  secondary_start_kernel+0x154/0x440
> > 
> > The root cause is that OS_LSR_EL1.OSLK is reset
> > to 1 on a cold reset[1] and the firmware didn't
> > unlock it by default.
> > So the core didn't go to el1_dbg as expected after
> > kernel_enable_single_step and eret.
> 
> Hmm, I thought we didn't use hardware single-step for kprobes after
> 7ee31a3aa8f4 ("arm64: kprobes: Use BRK instead of single-step when executing
> instructions out-of-line"). What is triggering this exception?
> 
> Will

You're right.
Actually this issue happend in 5.4 LTS, and the commit you mentioned
can avoid the kernel panic by not using hardware single-step.

I think 5.4 LTS should apply this commit.

7ee31a3aa8f4 ("arm64: kprobes: Use BRK instead of single-step when executing instructions out-of-line")

Cc: stable@vger.kernel.org



And I'm not sure if there is other use case may have problem if the
kernel don't clear OS lock in enable_debug_monitors everytime.
So should we do this to prevent someone face the similar issue?

