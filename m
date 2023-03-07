Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0656AF09A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjCGSc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCGScA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:32:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B303B3725
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 132D2B819D1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448CCC4339C;
        Tue,  7 Mar 2023 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213478;
        bh=15sDA5DKukliQb3d+h19ZtlO5w0AT0Qz8DpjVraT9rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wqt+0/MAujyI0YVLNrnpdIz1NGsehUVKYhU2prHMgcIkaoj1MqqOtDwm4MuUrUyNS
         P+2NG6GatlxEhyAsImXqRaf/GVMAd3vJ6zt9EHClPw0YMYseKdWSS2LPPmDE+q2rQ6
         GpD1P16hi8c4uFrUy/S90JwsyNumLY5jToFo/hPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Duoming Zhou <duoming@zju.edu.cn>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 520/885] media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()
Date:   Tue,  7 Mar 2023 17:57:34 +0100
Message-Id: <20230307170025.065911136@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 29b0589a865b6f66d141d79b2dd1373e4e50fe17 ]

When the ene device is detaching, function ene_remove() will
be called. But there is no function to cancel tx_sim_timer
in ene_remove(), the timer handler ene_tx_irqsim() could race
with ene_remove(). As a result, the UAF bugs could happen,
the process is shown below.

    (cleanup routine)          |        (timer routine)
                               | mod_timer(&dev->tx_sim_timer, ..)
ene_remove()                   | (wait a time)
                               | ene_tx_irqsim()
                               |   dev->hw_lock //USE
                               |   ene_tx_sample(dev) //USE

Fix by adding del_timer_sync(&dev->tx_sim_timer) in ene_remove(),
The tx_sim_timer could stop before ene device is deallocated.

What's more, The rc_unregister_device() and del_timer_sync()
should be called first in ene_remove() and the deallocated
functions such as free_irq(), release_region() and so on
should be called behind them. Because the rc_unregister_device()
is well synchronized. Otherwise, race conditions may happen. The
situations that may lead to race conditions are shown below.

Firstly, the rx receiver is disabled with ene_rx_disable()
before rc_unregister_device() in ene_remove(), which means it
can be enabled again if a process opens /dev/lirc0 between
ene_rx_disable() and rc_unregister_device().

Secondly, the irqaction descriptor is freed by free_irq()
before the rc device is unregistered, which means irqaction
descriptor may be accessed again after it is deallocated.

Thirdly, the timer can call ene_tx_sample() that can write
to the io ports, which means the io ports could be accessed
again after they are deallocated by release_region().

Therefore, the rc_unregister_device() and del_timer_sync()
should be called first in ene_remove().

Suggested by: Sean Young <sean@mess.org>

Fixes: 9ea53b74df9c ("V4L/DVB: STAGING: remove lirc_ene0100 driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ene_ir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index e09270916fbca..11ee21a7db8f0 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1106,6 +1106,8 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
 	unsigned long flags;
 
+	rc_unregister_device(dev->rdev);
+	del_timer_sync(&dev->tx_sim_timer);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
 	ene_rx_restore_hw_buffer(dev);
@@ -1113,7 +1115,6 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_IO_SIZE);
-	rc_unregister_device(dev->rdev);
 	kfree(dev);
 }
 
-- 
2.39.2



