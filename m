Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F1824B37
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 11:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfEUJKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 05:10:36 -0400
Received: from gofer.mess.org ([88.97.38.141]:34641 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfEUJKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 05:10:35 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 53033600F0; Tue, 21 May 2019 10:10:34 +0100 (BST)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     "# 5 . 0" <stable@vger.kernel.org>
Subject: [PATCH v2] media: dvb: warning about dvb frequency limits produces too much noise
Date:   Tue, 21 May 2019 10:10:34 +0100
Message-Id: <20190521091034.26611-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This can be a debug message. Favour dev_dbg() over dprintk() as this is
already used much more than dprintk().

dvb_frontend: dvb_frontend_get_frequency_limits: frequency interval: tuner: 45000000...860000000, frontend: 44250000...867250000

Fixes: 00ecd6bc7128 ("media: dvb_frontend: add debug message for frequency intervals")

Cc: <stable@vger.kernel.org> # 5.0
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index fbdb4ecc7c50..7402c9834189 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -917,7 +917,7 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 			 "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
 			 fe->dvb->num, fe->id);
 
-	dprintk("frequency interval: tuner: %u...%u, frontend: %u...%u",
+	dev_dbg(fe->dvb->device, "frequency interval: tuner: %u...%u, frontend: %u...%u",
 		tuner_min, tuner_max, frontend_min, frontend_max);
 
 	/* If the standard is for satellite, convert frequencies to kHz */
-- 
2.20.1

