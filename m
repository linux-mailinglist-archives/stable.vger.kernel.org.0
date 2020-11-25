Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAF32C416D
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 14:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgKYNwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 08:52:54 -0500
Received: from www.linuxtv.org ([130.149.80.248]:48184 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgKYNwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 08:52:53 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1khvE4-009b3t-24; Wed, 25 Nov 2020 13:52:52 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 25 Nov 2020 13:50:49 +0000
Subject: [git:media_tree/master] media: sunxi-cir: ensure IR is handled when it is continuous
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <mripard@kernel.org>, Sean Young <sean@mess.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1khvE4-009b3t-24@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: sunxi-cir: ensure IR is handled when it is continuous
Author:  Sean Young <sean@mess.org>
Date:    Mon Nov 9 23:16:52 2020 +0100

If a user holds a button down on a remote, then no ir idle interrupt will
be generated until the user releases the button, depending on how quickly
the remote repeats. No IR is processed until that point, which means that
holding down a button may not do anything.

This also resolves an issue on a Cubieboard 1 where the IR receiver is
picking up ambient infrared as IR and spews out endless
"rc rc0: IR event FIFO is full!" messages unless you choose to live in
the dark.

Cc: stable@vger.kernel.org
Tested-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Maxime Ripard <mripard@kernel.org>
Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/sunxi-cir.c | 2 ++
 1 file changed, 2 insertions(+)

---

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index ddee6ee37bab..4afc5895bee7 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -137,6 +137,8 @@ static irqreturn_t sunxi_ir_irq(int irqno, void *dev_id)
 	} else if (status & REG_RXSTA_RPE) {
 		ir_raw_event_set_idle(ir->rc, true);
 		ir_raw_event_handle(ir->rc);
+	} else {
+		ir_raw_event_handle(ir->rc);
 	}
 
 	spin_unlock(&ir->ir_lock);
