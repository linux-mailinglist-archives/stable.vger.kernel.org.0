Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EDE6D45F3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjDCNip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjDCNio (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:38:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5D026A9;
        Mon,  3 Apr 2023 06:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ACBAB81ABA;
        Mon,  3 Apr 2023 13:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6558EC433EF;
        Mon,  3 Apr 2023 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680529120;
        bh=LdzwidCT34O3NI7jBdSQTLk8K7aEAiaTOpmhSvtAetY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AoPgwUOemDe1SWR2Nt7gR4sTJkGkP4LGHxzR+NeXUUh5L3Zw6ZKJjwp6sTqbNDOfv
         WAPTlEYxhRgX4BXUJUsIN3AcjyNvUolicKGBMAp/xlS24UqZEZvi0qoPWx+TjzVuw2
         Zg6q/EkMSVrgAQt61jc8IvxOyMJnT1DbpjpFN0M9EmZbnOgf243zutEekacoM9h87f
         aCi5DacYOwBE2SGbdDmrLcGmPVWLxqCaour9Hb1eCJcAZem+S/kb1eS8IXZt7+ZOs4
         HSkbGaWkonaBWBPLKiUHeDRhNitqIB8mydVlw1TRtvGvtrd4+OZoVe0ieoc0MIkVDp
         yfys5V3uquyvg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: fix potential race condition between
 napi_init
 and napi_enable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230323082839.20474-1-pkshih@realtek.com>
References: <20230323082839.20474-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <stable@vger.kernel.org>, <42.hyeyoo@gmail.com>,
        <Larry.Finger@lwfinger.net>, <jonas.gorski@gmail.com>,
        <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168052911737.11825.17051716482828638727.kvalo@kernel.org>
Date:   Mon,  3 Apr 2023 13:38:39 +0000 (UTC)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> A race condition can happen if netdev is registered, but NAPI isn't
> initialized yet, and meanwhile user space starts the netdev that will
> enable NAPI. Then, it hits BUG_ON():
> 
>  kernel BUG at net/core/dev.c:6423!
>  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>  CPU: 0 PID: 417 Comm: iwd Not tainted 6.2.7-slab-dirty #3 eb0f5a8a9d91
>  Hardware name: LENOVO 21DL/LNVNB161216, BIOS JPCN20WW(V1.06) 09/20/2022
>  RIP: 0010:napi_enable+0x3f/0x50
>  Code: 48 89 c2 48 83 e2 f6 f6 81 89 08 00 00 02 74 0d 48 83 ...
>  RSP: 0018:ffffada1414f3548 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffffa01425802080 RCX: 0000000000000000
>  RDX: 00000000000002ff RSI: ffffada14e50c614 RDI: ffffa01425808dc0
>  RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>  R10: 0000000000000001 R11: 0000000000000100 R12: ffffa01425808f58
>  R13: 0000000000000000 R14: ffffa01423498940 R15: 0000000000000001
>  FS:  00007f5577c0a740(0000) GS:ffffa0169fc00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f5577a19972 CR3: 0000000125a7a000 CR4: 0000000000750ef0
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   rtw89_pci_ops_start+0x1c/0x70 [rtw89_pci 6cbc75429515c181cbc386478d5cfb32ffc5a0f8]
>   rtw89_core_start+0xbe/0x160 [rtw89_core fe07ecb874820b6d778370d4acb6ef8a37847f22]
>   rtw89_ops_start+0x26/0x40 [rtw89_core fe07ecb874820b6d778370d4acb6ef8a37847f22]
>   drv_start+0x42/0x100 [mac80211 c07fa22af8c3cf3f7d7ab3884ca990784d72e2d2]
>   ieee80211_do_open+0x311/0x7d0 [mac80211 c07fa22af8c3cf3f7d7ab3884ca990784d72e2d2]
>   ieee80211_open+0x6a/0x90 [mac80211 c07fa22af8c3cf3f7d7ab3884ca990784d72e2d2]
>   __dev_open+0xe0/0x180
>   __dev_change_flags+0x1da/0x250
>   dev_change_flags+0x26/0x70
>   do_setlink+0x37c/0x12c0
>   ? ep_poll_callback+0x246/0x290
>   ? __nla_validate_parse+0x61/0xd00
>   ? __wake_up_common_lock+0x8f/0xd0
> 
> To fix this, follow Jonas' suggestion to switch the order of these
> functions and move register netdev to be the last step of PCI probe.
> Also, correct the error handling of rtw89_core_register_hw().
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Cc: stable@vger.kernel.org
> Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Link: https://lore.kernel.org/linux-wireless/CAOiHx=n7EwK2B9CnBR07FVA=sEzFagb8TkS4XC_qBNq8OwcYUg@mail.gmail.com/T/#t
> Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
> Tested-by: Larry Finger<Larry.Finger@lwfinger.net>
> Reviewed-by: Larry Finger<Larry.Finger@lwfinger.net>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

47515664ecfb wifi: rtw89: fix potential race condition between napi_init and napi_enable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230323082839.20474-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

