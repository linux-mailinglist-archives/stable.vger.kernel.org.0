Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A24BE3DC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350395AbiBUJkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:40:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350058AbiBUJi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:38:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BEF30F55;
        Mon, 21 Feb 2022 01:17:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C5ABCE0E66;
        Mon, 21 Feb 2022 09:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DACFC340E9;
        Mon, 21 Feb 2022 09:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435018;
        bh=tP5CUsGrhz28rz/+xDcgKWdz9OnlZ9AuyjX1ULukau8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/WhBFkzEz5F6En2Y+RRz0b1shXsKO7RM6lDApS+ffTZ21andI+kywysU2eY0yfoM
         WRAf0jDq9hcrD3wP4rKVC6ztFWB+DzwY5/SCWJuErNEXKqMY33X3Aj6MzwWB/m70Ro
         14XbEvz5XsYsw4VUORUAVyTKgBDKqPQI8cDuQxmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.16 016/227] parisc: Fix data TLB miss in sba_unmap_sg
Date:   Mon, 21 Feb 2022 09:47:15 +0100
Message-Id: <20220221084935.384299824@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: John David Anglin <dave.anglin@bell.net>

commit b7d6f44a0fa716a82969725516dc0b16bc7cd514 upstream.

Rolf Eike Beer reported the following bug:

[1274934.746891] Bad Address (null pointer deref?): Code=15 (Data TLB miss fault) at addr 0000004140000018
[1274934.746891] CPU: 3 PID: 5549 Comm: cmake Not tainted 5.15.4-gentoo-parisc64 #4
[1274934.746891] Hardware name: 9000/785/C8000
[1274934.746891]
[1274934.746891]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
[1274934.746891] PSW: 00001000000001001111111000001110 Not tainted
[1274934.746891] r00-03  000000ff0804fe0e 0000000040bc9bc0 00000000406760e4 0000004140000000
[1274934.746891] r04-07  0000000040b693c0 0000004140000000 000000004a2b08b0 0000000000000001
[1274934.746891] r08-11  0000000041f98810 0000000000000000 000000004a0a7000 0000000000000001
[1274934.746891] r12-15  0000000040bddbc0 0000000040c0cbc0 0000000040bddbc0 0000000040bddbc0
[1274934.746891] r16-19  0000000040bde3c0 0000000040bddbc0 0000000040bde3c0 0000000000000007
[1274934.746891] r20-23  0000000000000006 000000004a368950 0000000000000000 0000000000000001
[1274934.746891] r24-27  0000000000001fff 000000000800000e 000000004a1710f0 0000000040b693c0
[1274934.746891] r28-31  0000000000000001 0000000041f988b0 0000000041f98840 000000004a171118
[1274934.746891] sr00-03  00000000066e5800 0000000000000000 0000000000000000 00000000066e5800
[1274934.746891] sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[1274934.746891]
[1274934.746891] IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000406760e8 00000000406760ec
[1274934.746891]  IIR: 48780030    ISR: 0000000000000000  IOR: 0000004140000018
[1274934.746891]  CPU:        3   CR30: 00000040e3a9c000 CR31: ffffffffffffffff
[1274934.746891]  ORIG_R28: 0000000040acdd58
[1274934.746891]  IAOQ[0]: sba_unmap_sg+0xb0/0x118
[1274934.746891]  IAOQ[1]: sba_unmap_sg+0xb4/0x118
[1274934.746891]  RP(r2): sba_unmap_sg+0xac/0x118
[1274934.746891] Backtrace:
[1274934.746891]  [<00000000402740cc>] dma_unmap_sg_attrs+0x6c/0x70
[1274934.746891]  [<000000004074d6bc>] scsi_dma_unmap+0x54/0x60
[1274934.746891]  [<00000000407a3488>] mptscsih_io_done+0x150/0xd70
[1274934.746891]  [<0000000040798600>] mpt_interrupt+0x168/0xa68
[1274934.746891]  [<0000000040255a48>] __handle_irq_event_percpu+0xc8/0x278
[1274934.746891]  [<0000000040255c34>] handle_irq_event_percpu+0x3c/0xd8
[1274934.746891]  [<000000004025ecb4>] handle_percpu_irq+0xb4/0xf0
[1274934.746891]  [<00000000402548e0>] generic_handle_irq+0x50/0x70
[1274934.746891]  [<000000004019a254>] call_on_stack+0x18/0x24
[1274934.746891]
[1274934.746891] Kernel panic - not syncing: Bad Address (null pointer deref?)

The bug is caused by overrunning the sglist and incorrectly testing
sg_dma_len(sglist) before nents. Normally this doesn't cause a crash,
but in this case sglist crossed a page boundary. This occurs in the
following code:

	while (sg_dma_len(sglist) && nents--) {

The fix is simply to test nents first and move the decrement of nents
into the loop.

Reported-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/sba_iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1047,7 +1047,7 @@ sba_unmap_sg(struct device *dev, struct
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 #endif
 
-	while (sg_dma_len(sglist) && nents--) {
+	while (nents && sg_dma_len(sglist)) {
 
 		sba_unmap_page(dev, sg_dma_address(sglist), sg_dma_len(sglist),
 				direction, 0);
@@ -1056,6 +1056,7 @@ sba_unmap_sg(struct device *dev, struct
 		ioc->usingle_calls--;	/* kluge since call is unmap_sg() */
 #endif
 		++sglist;
+		nents--;
 	}
 
 	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__,  nents);


