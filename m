Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22222419E
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 22:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfETUBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 16:01:46 -0400
Received: from gofer.mess.org ([88.97.38.141]:59071 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfETUBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 16:01:46 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id F421E60A6E; Mon, 20 May 2019 21:01:44 +0100 (BST)
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     "# 5 . 0" <stable@vger.kernel.org>
Subject: [PATCH 1/2] media: dvb: warning about dvb frequency limits produces too much noise
Date:   Mon, 20 May 2019 21:01:43 +0100
Message-Id: <20190520200144.16713-1-sean@mess.org>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This can be a debug message.

dvb_frontend: dvb_frontend_get_frequency_limits: frequency interval: tuner: 45000000...860000000, frontend: 44250000...867250000

Fixes: 00ecd6bc7128 ("media: dvb_frontend: add debug message for frequency intervals")

Cc: <stable@vger.kernel.org> # 5.0
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index fbdb4ecc7c50..d3c0f6267bf8 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -917,8 +917,9 @@ static void dvb_frontend_get_frequency_limits(struct dvb_frontend *fe,
 			 "DVB: adapter %i frontend %u frequency limits undefined - fix the driver\n",
 			 fe->dvb->num, fe->id);
 
-	dprintk("frequency interval: tuner: %u...%u, frontend: %u...%u",
-		tuner_min, tuner_max, frontend_min, frontend_max);
+	if (dvb_frontend_debug)
+		dprintk("frequency interval: tuner: %u...%u, frontend: %u...%u",
+			tuner_min, tuner_max, frontend_min, frontend_max);
 
 	/* If the standard is for satellite, convert frequencies to kHz */
 	switch (c->delivery_system) {
-- 
2.20.1

