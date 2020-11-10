Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0562AD25A
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 10:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKJJWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 04:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJJWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 04:22:49 -0500
X-Greylist: delayed 404 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Nov 2020 01:22:48 PST
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848FC0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 01:22:48 -0800 (PST)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id CEF41C6398; Tue, 10 Nov 2020 09:15:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1604999757; bh=oo1sXhCURed1LSMO71Y9DGDuLwiNpyS266VJLDVsDQE=;
        h=From:To:Cc:Subject:Date:From;
        b=JtLQfxd7ZM7m8KsFeoZm4pVWx6Lvu2SVx4zhfBgWbfMdkv7bWHkj6mzGL8MikR/FB
         4D9/ilCpepHZ7HAcQzZ7o4GlS5p3bFar1N51hqdqjptcSxHS3rTj3+1flBb9IzPXKC
         XeqyRDRJ3472pWBdjkmlBJZ0M0rsj4Ly+dpv5/b+GginUpn3kbabCl3+vtm/4HeV0Z
         9xt3Jeijt54MYPQcqy0H3VVOE9nDeV9Yf0yKhZCk6/skfhKuHB2TlT39SC17mgqDD9
         +2+G9g1f6gx7TrGVyuD8moTv7NthnTyp6I6fWGaDkInQEf92RhJpdSBWFU02/twAT0
         izEbkleRUzUiA==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <mripard@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] media: sunxi-cir: ensure IR is handled when it is continuous
Date:   Tue, 10 Nov 2020 09:15:56 +0000
Message-Id: <20201110091557.25680-1-sean@mess.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a user holds a button down on a remote, then no ir idle interrupt will
be generated until the user releases the button, depending on how quickly
the remote repeats. No IR is processed until that point, which means that
holding down a button may not do anything.

This also resolves an issue on a Cubieboard 1 where the IR receiver is
picking up ambient infrared as IR and spews out endless
"rc rc0: IR event FIFO is full!" messages unless you choose to live in
the dark.

Cc: stable@vger.kernel.org
Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sunxi-cir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index ddee6ee37bab1..4afc5895bee74 100644
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
-- 
2.28.0

