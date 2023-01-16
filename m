Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C626166C7A9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjAPQdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjAPQcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:32:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F76B301B1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A097E61041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F4BC433D2;
        Mon, 16 Jan 2023 16:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886046;
        bh=VpRW9W6a4wMLusArKPS02U5BPSTQJ/JfPW5mGwHuY/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaIuETMJ8XcWkJ2pzuWd0DuK62UhsPvg1wdBVde11FXW8vQUVNpxiKukHXn2dpbqX
         o2dZLy7S8JxDWt+/ZyMNwVFumVS9201dMj+S10tIbrAb3SWCsMoQH2pOqEQbeiRIKp
         cQZC0OcNbAof7RJXEYQdllbwlwCjde9PEdco8jWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/658] uio: uio_dmem_genirq: Fix deadlock between irq config and handling
Date:   Mon, 16 Jan 2023 16:46:08 +0100
Message-Id: <20230116154922.400334839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 588b88fdb0c4..39dbd8c56249 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -110,8 +110,10 @@ static irqreturn_t uio_dmem_genirq_handler(int irq, struct uio_info *dev_info)
 	 * remember the state so we can allow user space to enable it later.
 	 */
 
+	spin_lock(&priv->lock);
 	if (!test_and_set_bit(0, &priv->flags))
 		disable_irq_nosync(irq);
+	spin_unlock(&priv->lock);
 
 	return IRQ_HANDLED;
 }
@@ -125,7 +127,8 @@ static int uio_dmem_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
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



