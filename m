Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6138759D8BF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbiHWJsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242048AbiHWJr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649949C516;
        Tue, 23 Aug 2022 01:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78D9F61485;
        Tue, 23 Aug 2022 08:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67834C433C1;
        Tue, 23 Aug 2022 08:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244236;
        bh=I1xhZSiC9DRvT8rxyQAW4Nh+0v4H2XNl/oVbjpuEVrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV1UvYXKp10vNAvd7/GpGgs1u0E7KB1bcMJnaHLrbx+CGyYPZOSn90NGD6zqovcS6
         Ums0NHLyhF8THObVitq06rO45CxVb5jZyo9Kjp9XsE1qAP6oe01h9/CCTHJHSj8TVk
         NooynKjcpFs7TStotwysD4j1y6hvwfNOOnaV1Uhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandor Bodo-Merle <sbodomerle@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 060/244] net: bgmac: Fix a BUG triggered by wrong bytes_compl
Date:   Tue, 23 Aug 2022 10:23:39 +0200
Message-Id: <20220823080101.078862285@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandor Bodo-Merle <sbodomerle@gmail.com>

commit 1b7680c6c1f6de9904f1d9b05c952f0c64a03350 upstream.

On one of our machines we got:

kernel BUG at lib/dynamic_queue_limits.c:27!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
CPU: 0 PID: 1166 Comm: irq/41-bgmac Tainted: G        W  O    4.14.275-rt132 #1
Hardware name: BRCM XGS iProc
task: ee3415c0 task.stack: ee32a000
PC is at dql_completed+0x168/0x178
LR is at bgmac_poll+0x18c/0x6d8
pc : [<c03b9430>]    lr : [<c04b5a18>]    psr: 800a0313
sp : ee32be14  ip : 000005ea  fp : 00000bd4
r10: ee558500  r9 : c0116298  r8 : 00000002
r7 : 00000000  r6 : ef128810  r5 : 01993267  r4 : 01993851
r3 : ee558000  r2 : 000070e1  r1 : 00000bd4  r0 : ee52c180
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 12c5387d  Table: 8e88c04a  DAC: 00000051
Process irq/41-bgmac (pid: 1166, stack limit = 0xee32a210)
Stack: (0xee32be14 to 0xee32c000)
be00:                                              ee558520 ee52c100 ef128810
be20: 00000000 00000002 c0116298 c04b5a18 00000000 c0a0c8c4 c0951780 00000040
be40: c0701780 ee558500 ee55d520 ef05b340 ef6f9780 ee558520 00000001 00000040
be60: ffffe000 c0a56878 ef6fa040 c0952040 0000012c c0528744 ef6f97b0 fffcfb6a
be80: c0a04104 2eda8000 c0a0c4ec c0a0d368 ee32bf44 c0153534 ee32be98 ee32be98
bea0: ee32bea0 ee32bea0 ee32bea8 ee32bea8 00000000 c01462e4 ffffe000 ef6f22a8
bec0: ffffe000 00000008 ee32bee4 c0147430 ffffe000 c094a2a8 00000003 ffffe000
bee0: c0a54528 00208040 0000000c c0a0c8c4 c0a65980 c0124d3c 00000008 ee558520
bf00: c094a23c c0a02080 00000000 c07a9910 ef136970 ef136970 ee30a440 ef136900
bf20: ee30a440 00000001 ef136900 ee30a440 c016d990 00000000 c0108db0 c012500c
bf40: ef136900 c016da14 ee30a464 ffffe000 00000001 c016dd14 00000000 c016db28
bf60: ffffe000 ee21a080 ee30a400 00000000 ee32a000 ee30a440 c016dbfc ee25fd70
bf80: ee21a09c c013edcc ee32a000 ee30a400 c013ec7c 00000000 00000000 00000000
bfa0: 00000000 00000000 00000000 c0108470 00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c03b9430>] (dql_completed) from [<c04b5a18>] (bgmac_poll+0x18c/0x6d8)
[<c04b5a18>] (bgmac_poll) from [<c0528744>] (net_rx_action+0x1c4/0x494)
[<c0528744>] (net_rx_action) from [<c0124d3c>] (do_current_softirqs+0x1ec/0x43c)
[<c0124d3c>] (do_current_softirqs) from [<c012500c>] (__local_bh_enable+0x80/0x98)
[<c012500c>] (__local_bh_enable) from [<c016da14>] (irq_forced_thread_fn+0x84/0x98)
[<c016da14>] (irq_forced_thread_fn) from [<c016dd14>] (irq_thread+0x118/0x1c0)
[<c016dd14>] (irq_thread) from [<c013edcc>] (kthread+0x150/0x158)
[<c013edcc>] (kthread) from [<c0108470>] (ret_from_fork+0x14/0x24)
Code: a83f15e0 0200001a 0630a0e1 c3ffffea (f201f0e7)

The issue seems similar to commit 90b3b339364c ("net: hisilicon: Fix a BUG
trigered by wrong bytes_compl") and potentially introduced by commit
b38c83dd0866 ("bgmac: simplify tx ring index handling").

If there is an RX interrupt between setting ring->end
and netdev_sent_queue() we can hit the BUG_ON as bgmac_dma_tx_free()
can miscalculate the queue size while called from bgmac_poll().

The machine which triggered the BUG runs a v4.14 RT kernel - but the issue
seems present in mainline too.

Fixes: b38c83dd0866 ("bgmac: simplify tx ring index handling")
Signed-off-by: Sandor Bodo-Merle <sbodomerle@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220808173939.193804-1-sbodomerle@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bgmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -189,8 +189,8 @@ static netdev_tx_t bgmac_dma_tx_add(stru
 	}
 
 	slot->skb = skb;
-	ring->end += nr_frags + 1;
 	netdev_sent_queue(net_dev, skb->len);
+	ring->end += nr_frags + 1;
 
 	wmb();
 


