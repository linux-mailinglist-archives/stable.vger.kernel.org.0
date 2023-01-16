Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFDC66CAB0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjAPRGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjAPRFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:05:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F8242BC6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:47:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB8D661037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2474C433D2;
        Mon, 16 Jan 2023 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887629;
        bh=z3ZCtXUpciX2ZVdgUt2vhDPs4ZMsOvQLQuxD575qTbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4BEKM6/7iijlNPJYFs97+7+4v0xRzdxvlL0eRVlkpxQsW7kil4Tx91Ei9IU0cBYu
         dlYtb89SBT3Sr6m7ssDfGPcUSHAEt8Jps9SYAdTl+6jraSBc/P2GpN6oXIgN2qeRij
         fI67IOeIgfIAPWbfQl9haQ8IoAqWXGwpAeFbHdAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 221/521] uio: uio_dmem_genirq: Fix deadlock between irq config and handling
Date:   Mon, 16 Jan 2023 16:48:03 +0100
Message-Id: <20230116154857.059107727@linuxfoundation.org>
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 118b918018175d9fcd8db667f905012e986cc2c9 ]

This fixes a concurrency issue addressed in commit 34cb27528398 ("UIO: Fix
concurrency issue"):

  "In a SMP case there was a race condition issue between
  Uio_pdrv_genirq_irqcontrol() running on one CPU and irq handler on
  another CPU. Fix it by spin_locking shared resources access inside irq
  handler."

The implementation of "uio_dmem_genirq" was based on "uio_pdrv_genirq" and
it is used in a similar manner to the "uio_pdrv_genirq" driver with respect
to interrupt configuration and handling. At the time "uio_dmem_genirq" was
merged, both had the same implementation of the 'uio_info' handlers
irqcontrol() and handler(), thus, both had the same concurrency issue
mentioned by the above commit. However, the above patch was only applied to
the "uio_pdrv_genirq" driver.

Split out from commit 34cb27528398 ("UIO: Fix concurrency issue").

Fixes: 0a0c3b5a24bd ("Add new uio device for dynamic memory allocation")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Link: https://lore.kernel.org/r/20220930224100.816175-3-rafaelmendsr@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio_dmem_genirq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index c25a6bcb2d21..b4b7fa05b29b 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -113,8 +113,10 @@ static irqreturn_t uio_dmem_genirq_handler(int irq, struct uio_info *dev_info)
 	 * remember the state so we can allow user space to enable it later.
 	 */
 
+	spin_lock(&priv->lock);
 	if (!test_and_set_bit(0, &priv->flags))
 		disable_irq_nosync(irq);
+	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
 }
@@ -128,7 +130,8 @@ static int uio_dmem_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 	 * in the interrupt controller, but keep track of the
 	 * state to prevent per-irq depth damage.
 	 *
-	 * Serialize this operation to support multiple tasks.
+	 * Serialize this operation to support multiple tasks and concurrency
+	 * with irq handler on SMP systems.
 	 */
 
 	spin_lock_irqsave(&priv->lock, flags);
-- 
2.35.1



