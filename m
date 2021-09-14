Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6520E40B2D6
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhINPTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbhINPTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:19:31 -0400
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685FBC0613CF;
        Tue, 14 Sep 2021 08:18:12 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 654D4C6355; Tue, 14 Sep 2021 16:18:09 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1631632689; bh=/IhPmIr9/LHDBv8I1A2poHCsQ9nOxmqZ/x5osrJSJAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDiLzAMPXiYDuvfH6vtr9I65enS3LtscCNuUkisqFNv2FXKReQgFn+Eh+yZCGONT9
         E8yg2mv83s23k45nzOEXJwxWjALbUXl7iyh98c8S8lGEfRWakfHS3Dbfzd+0u5TZzH
         rBORpK2YG1MSh2kVGjtWhtKj6BXRndQK1kSd0FVzg3t6GuZ4r6XZLFz7NR+sEMIqMs
         Xt0bp01VbBFxlpvXpOCKXSLRP1HlkY09Pnhn6OmAEBXBRjKvjMShz7gQpIqinrSXBB
         LSJrwJyKywsncjGl0OtLNVf+tmdNwmTJBhnEPLUrFKmd+7YZd/GvZZsNzaRKldv2yD
         ktuXrGtBQpn6Q==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     Georgi Bakalski <georgi.bakalski@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] media: ir_toy: deal with residual irdata before expected response
Date:   Tue, 14 Sep 2021 16:18:07 +0100
Message-Id: <2b28f45034d54371fe420f3a54c7eb93034024e1.1631632442.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <22eeae667aac9d5eaaae2f21904f238ebef0c05b.1631632442.git.sean@mess.org>
References: <22eeae667aac9d5eaaae2f21904f238ebef0c05b.1631632442.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After sending the start transmit command, the device is supposed to
respond with the length of the buffer which can be sent. There might
be some residual ir data there.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir_toy.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index 45d39b6e49c0..2b7c8bba4d6a 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -122,6 +122,7 @@ static void irtoy_response(struct irtoy *irtoy, u32 len)
 				len, irtoy->in);
 		}
 		break;
+	case STATE_COMMAND_NO_RESP:
 	case STATE_IRDATA: {
 		struct ir_raw_event rawir = { .pulse = irtoy->pulse };
 		__be16 *in = (__be16 *)irtoy->in;
@@ -167,10 +168,8 @@ static void irtoy_response(struct irtoy *irtoy, u32 len)
 			int err;
 
 			if (len != 1 || space > MAX_PACKET || space == 0) {
-				dev_err(irtoy->dev, "packet length expected: %*phN\n",
+				dev_dbg(irtoy->dev, "packet length expected: %*phN\n",
 					len, irtoy->in);
-				irtoy->state = STATE_IRDATA;
-				complete(&irtoy->command_done);
 				break;
 			}
 
@@ -194,9 +193,6 @@ static void irtoy_response(struct irtoy *irtoy, u32 len)
 			irtoy->tx_len -= buf_len;
 		}
 		break;
-	case STATE_COMMAND_NO_RESP:
-		dev_err(irtoy->dev, "unexpected response to reset: %*phN\n",
-			len, irtoy->in);
 	}
 }
 
-- 
2.31.1

