Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7866CB8E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbjAPROr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbjAPRNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:13:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2474B758
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:53:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2F060F61
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC2EC433D2;
        Mon, 16 Jan 2023 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888024;
        bh=anJBOgthcO90W+a3IhkS9w2Kfos0vFd6Fpt1aKZn/sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VUbqDXcBDCxKqDojiD+rMGcU03Xf++oJbg5fZeA3Gyu8ZWY6lBpRpEgzuTjREt56
         x+LbvdDC+Don8nNWyM/1O6xtE2Ot4j5pxQlDceHBs6lBe1Rp9kBQEPvyxqdYGT2sRe
         W+0yAVwUBc+eua/K+NhXUGEdu1P3K46dwnC1uDz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Deren Wu <deren.wu@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 372/521] mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING
Date:   Mon, 16 Jan 2023 16:50:34 +0100
Message-Id: <20230116154903.724368183@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

commit 4a44cd249604e29e7b90ae796d7692f5773dd348 upstream.

vub300_enable_sdio_irq() works with mutex and need TASK_RUNNING here.
Ensure that we mark current as TASK_RUNNING for sleepable context.

[   77.554641] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff92a72c1d>] sdio_irq_thread+0x17d/0x5b0
[   77.554652] WARNING: CPU: 2 PID: 1983 at kernel/sched/core.c:9813 __might_sleep+0x116/0x160
[   77.554905] CPU: 2 PID: 1983 Comm: ksdioirqd/mmc1 Tainted: G           OE      6.1.0-rc5 #1
[   77.554910] Hardware name: Intel(R) Client Systems NUC8i7BEH/NUC8BEB, BIOS BECFL357.86A.0081.2020.0504.1834 05/04/2020
[   77.554912] RIP: 0010:__might_sleep+0x116/0x160
[   77.554920] RSP: 0018:ffff888107b7fdb8 EFLAGS: 00010282
[   77.554923] RAX: 0000000000000000 RBX: ffff888118c1b740 RCX: 0000000000000000
[   77.554926] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffed1020f6ffa9
[   77.554928] RBP: ffff888107b7fde0 R08: 0000000000000001 R09: ffffed1043ea60ba
[   77.554930] R10: ffff88821f5305cb R11: ffffed1043ea60b9 R12: ffffffff93aa3a60
[   77.554932] R13: 000000000000011b R14: 7fffffffffffffff R15: ffffffffc0558660
[   77.554934] FS:  0000000000000000(0000) GS:ffff88821f500000(0000) knlGS:0000000000000000
[   77.554937] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   77.554939] CR2: 00007f8a44010d68 CR3: 000000024421a003 CR4: 00000000003706e0
[   77.554942] Call Trace:
[   77.554944]  <TASK>
[   77.554952]  mutex_lock+0x78/0xf0
[   77.554973]  vub300_enable_sdio_irq+0x103/0x3c0 [vub300]
[   77.554981]  sdio_irq_thread+0x25c/0x5b0
[   77.555006]  kthread+0x2b8/0x370
[   77.555017]  ret_from_fork+0x1f/0x30
[   77.555023]  </TASK>
[   77.555025] ---[ end trace 0000000000000000 ]---

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87dc45b122d26d63c80532976813c9365d7160b3.1670140888.git.deren.wu@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2052,6 +2052,7 @@ static void vub300_enable_sdio_irq(struc
 		return;
 	kref_get(&vub300->kref);
 	if (enable) {
+		set_current_state(TASK_RUNNING);
 		mutex_lock(&vub300->irq_mutex);
 		if (vub300->irqs_queued) {
 			vub300->irqs_queued -= 1;
@@ -2067,6 +2068,7 @@ static void vub300_enable_sdio_irq(struc
 			vub300_queue_poll_work(vub300, 0);
 		}
 		mutex_unlock(&vub300->irq_mutex);
+		set_current_state(TASK_INTERRUPTIBLE);
 	} else {
 		vub300->irq_enabled = 0;
 	}


