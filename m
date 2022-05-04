Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD951A7A7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355057AbiEDRGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356356AbiEDRFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:05:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C41E506F1;
        Wed,  4 May 2022 09:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B252FB827A3;
        Wed,  4 May 2022 16:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69528C385A4;
        Wed,  4 May 2022 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683239;
        bh=lVaJWtKW0Ijh2nupS9UWR8XJmZlkiWdqTf0rNGERKtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5+3I308TF4hpyqb1Agx5KBCl43aw1YbIbv1DyurOwBVnmCqgYvm7lIsBX2qkZVzP
         HW8MCeAMXYF/srzhx9k/JmycyMVfzgqBo0bee3vNO8YaqeZjyZqTR1PgAZ1H5wM6pJ
         jA8jYZtsKdvtdtYNpg2dnsy5e/ZvoOsQbN4bJ/3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eyal Birger <eyal.birger@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/177] bpf, lwt: Fix crash when using bpf_skb_set_tunnel_key() from bpf_xmit lwt hook
Date:   Wed,  4 May 2022 18:44:35 +0200
Message-Id: <20220504153100.395919305@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

[ Upstream commit b02d196c44ead1a5949729be9ff08fe781c3e48a ]

xmit_check_hhlen() observes the dst for getting the device hard header
length to make sure a modified packet can fit. When a helper which changes
the dst - such as bpf_skb_set_tunnel_key() - is called as part of the
xmit program the accessed dst is no longer valid.

This leads to the following splat:

 BUG: kernel NULL pointer dereference, address: 00000000000000de
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP PTI
 CPU: 0 PID: 798 Comm: ping Not tainted 5.18.0-rc2+ #103
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 RIP: 0010:bpf_xmit+0xfb/0x17f
 Code: c6 c0 4d cd 8e 48 c7 c7 7d 33 f0 8e e8 42 09 fb ff 48 8b 45 58 48 8b 95 c8 00 00 00 48 2b 95 c0 00 00 00 48 83 e0 fe 48 8b 00 <0f> b7 80 de 00 00 00 39 c2 73 22 29 d0 b9 20 0a 00 00 31 d2 48 89
 RSP: 0018:ffffb148c0bc7b98 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: 0000000000240008 RCX: 0000000000000000
 RDX: 0000000000000010 RSI: 00000000ffffffea RDI: 00000000ffffffff
 RBP: ffff922a828a4e00 R08: ffffffff8f1350e8 R09: 00000000ffffdfff
 R10: ffffffff8f055100 R11: ffffffff8f105100 R12: 0000000000000000
 R13: ffff922a828a4e00 R14: 0000000000000040 R15: 0000000000000000
 FS:  00007f414e8f0080(0000) GS:ffff922afdc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000000000de CR3: 0000000002d80006 CR4: 0000000000370ef0
 Call Trace:
  <TASK>
  lwtunnel_xmit.cold+0x71/0xc8
  ip_finish_output2+0x279/0x520
  ? __ip_finish_output.part.0+0x21/0x130

Fix by fetching the device hard header length before running the BPF code.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220420165219.1755407-1-eyal.birger@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 2f7940bcf715..3fd207fe1284 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -158,10 +158,8 @@ static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	return dst->lwtstate->orig_output(net, sk, skb);
 }
 
-static int xmit_check_hhlen(struct sk_buff *skb)
+static int xmit_check_hhlen(struct sk_buff *skb, int hh_len)
 {
-	int hh_len = skb_dst(skb)->dev->hard_header_len;
-
 	if (skb_headroom(skb) < hh_len) {
 		int nhead = HH_DATA_ALIGN(hh_len - skb_headroom(skb));
 
@@ -273,6 +271,7 @@ static int bpf_xmit(struct sk_buff *skb)
 
 	bpf = bpf_lwt_lwtunnel(dst->lwtstate);
 	if (bpf->xmit.prog) {
+		int hh_len = dst->dev->hard_header_len;
 		__be16 proto = skb->protocol;
 		int ret;
 
@@ -290,7 +289,7 @@ static int bpf_xmit(struct sk_buff *skb)
 			/* If the header was expanded, headroom might be too
 			 * small for L2 header to come, expand as needed.
 			 */
-			ret = xmit_check_hhlen(skb);
+			ret = xmit_check_hhlen(skb, hh_len);
 			if (unlikely(ret))
 				return ret;
 
-- 
2.35.1



