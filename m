Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913F6410B2D
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 12:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhISKnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 06:43:10 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54746 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhISKnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Sep 2021 06:43:10 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mRuGV-00Gg01-Uh; Sun, 19 Sep 2021 10:41:43 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Sun, 19 Sep 2021 10:35:57 +0000
Subject: [git:media_stage/master] media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mRuGV-00Gg01-Uh@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ir-kbd-i2c: improve responsiveness of hauppauge zilog receivers
Author:  Sean Young <sean@mess.org>
Date:    Wed Sep 15 18:14:07 2021 +0200

The IR receiver has two issues:

 - Sometimes there is no response to a button press
 - Sometimes a button press is repeated when it should not have been

Hanging the polling interval fixes this behaviour.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=994050

Cc: stable@vger.kernel.org
Suggested-by: Joaquín Alberto Calderón Pozo <kini_calderon@hotmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/i2c/ir-kbd-i2c.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 92376592455e..56674173524f 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -791,6 +791,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		rc_proto    = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
 							RC_PROTO_BIT_RC6_6A_32;
 		ir_codes    = RC_MAP_HAUPPAUGE;
+		ir->polling_interval = 125;
 		probe_tx = true;
 		break;
 	}
