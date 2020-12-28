Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008F32E3818
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbgL1NFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbgL1NFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B9B22AAD;
        Mon, 28 Dec 2020 13:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160673;
        bh=LzODAm2jd7+cJ0Nb28iwyizDMXqK1TTzgakTksqgk5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ui7ojaJmivBuJ0kJL/f376sCP8mt90DVEupCihyrauF/Nd++PDABNQcPZ3xliYiyx
         Pz2tkpGYUFJ3QyoauDEMpWypL36dCgqoGBzWyb9+zyjcn1CXiZMftCx2lzuUkJbswc
         Kxh+teewMkcVjxxyPVHteUug4lAbKucGFCMT5RYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <mripard@kernel.org>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.9 132/175] media: sunxi-cir: ensure IR is handled when it is continuous
Date:   Mon, 28 Dec 2020 13:49:45 +0100
Message-Id: <20201228124859.644741059@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 3f56df4c8ffeb120ed41906d3aae71799b7e726a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/sunxi-cir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -132,6 +132,8 @@ static irqreturn_t sunxi_ir_irq(int irqn
 	} else if (status & REG_RXINT_RPEI_EN) {
 		ir_raw_event_set_idle(ir->rc, true);
 		ir_raw_event_handle(ir->rc);
+	} else {
+		ir_raw_event_handle(ir->rc);
 	}
 
 	spin_unlock(&ir->ir_lock);


