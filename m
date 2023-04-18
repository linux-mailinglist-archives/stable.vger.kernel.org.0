Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8986E6431
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjDRMqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjDRMqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CAD14F59
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53773633B5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61248C433D2;
        Tue, 18 Apr 2023 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822011;
        bh=XAdkwq/v7ensHuK/Jwi7tilFGTqQ2dc2NiexxrLVGSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVIrwKNiY35feX+Wk3v+XV6ShFq2f245ZZJ10O377eGviss0lih2tnH1VBVZxEUu5
         hyO2aE4Jsv/v4sYq/inr/kv+qLg/VA88218VGxMoBPvRNPKd9B2mnTIx4QhLBxIdeD
         N3B8n5GztuyG+qMA9pK9zWRXWpJNGlQYIH7DnVGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gregor Herburger <gregor.herburger@tq-group.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Federico Vaga <federico.vaga@cern.ch>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/134] i2c: ocores: generate stop condition after timeout in polling mode
Date:   Tue, 18 Apr 2023 14:23:00 +0200
Message-Id: <20230418120317.507073991@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregor Herburger <gregor.herburger@tq-group.com>

[ Upstream commit f8160d3b35fc94491bb0cb974dbda310ef96c0e2 ]

In polling mode, no stop condition is generated after a timeout. This
causes SCL to remain low and thereby block the bus. If this happens
during a transfer it can cause slaves to misinterpret the subsequent
transfer and return wrong values.

To solve this, pass the ETIMEDOUT error up from ocores_process_polling()
instead of setting STATE_ERROR directly. The caller is adjusted to call
ocores_process_timeout() on error both in polling and in IRQ mode, which
will set STATE_ERROR and generate a stop condition.

Fixes: 69c8c0c0efa8 ("i2c: ocores: add polling interface")
Signed-off-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Federico Vaga <federico.vaga@cern.ch>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 35 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index a0af027db04c1..2e575856c5cd5 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -342,18 +342,18 @@ static int ocores_poll_wait(struct ocores_i2c *i2c)
  * ocores_isr(), we just add our polling code around it.
  *
  * It can run in atomic context
+ *
+ * Return: 0 on success, -ETIMEDOUT on timeout
  */
-static void ocores_process_polling(struct ocores_i2c *i2c)
+static int ocores_process_polling(struct ocores_i2c *i2c)
 {
-	while (1) {
-		irqreturn_t ret;
-		int err;
+	irqreturn_t ret;
+	int err = 0;
 
+	while (1) {
 		err = ocores_poll_wait(i2c);
-		if (err) {
-			i2c->state = STATE_ERROR;
+		if (err)
 			break; /* timeout */
-		}
 
 		ret = ocores_isr(-1, i2c);
 		if (ret == IRQ_NONE)
@@ -364,13 +364,15 @@ static void ocores_process_polling(struct ocores_i2c *i2c)
 					break;
 		}
 	}
+
+	return err;
 }
 
 static int ocores_xfer_core(struct ocores_i2c *i2c,
 			    struct i2c_msg *msgs, int num,
 			    bool polling)
 {
-	int ret;
+	int ret = 0;
 	u8 ctrl;
 
 	ctrl = oc_getreg(i2c, OCI2C_CONTROL);
@@ -388,15 +390,16 @@ static int ocores_xfer_core(struct ocores_i2c *i2c,
 	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
 
 	if (polling) {
-		ocores_process_polling(i2c);
+		ret = ocores_process_polling(i2c);
 	} else {
-		ret = wait_event_timeout(i2c->wait,
-					 (i2c->state == STATE_ERROR) ||
-					 (i2c->state == STATE_DONE), HZ);
-		if (ret == 0) {
-			ocores_process_timeout(i2c);
-			return -ETIMEDOUT;
-		}
+		if (wait_event_timeout(i2c->wait,
+				       (i2c->state == STATE_ERROR) ||
+				       (i2c->state == STATE_DONE), HZ) == 0)
+			ret = -ETIMEDOUT;
+	}
+	if (ret) {
+		ocores_process_timeout(i2c);
+		return ret;
 	}
 
 	return (i2c->state == STATE_DONE) ? num : -EIO;
-- 
2.39.2



