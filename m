Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1710DFA58D
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfKMBwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbfKMBwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C28222CA;
        Wed, 13 Nov 2019 01:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609954;
        bh=0Sjkf189679x4uXqj5BLH1BM4wR2jv51XnrwoMD8oH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNgJMfd2b8JwA1KlXQAZv6VJLbOQfrXwR2k5dGamy+1HnPq5UKxSqFm9ZGkrYqSmA
         uLTlEGhol1XBr44KY6B2mxCbrnk+ROeWj7g3cyOhPQxQwBEgpd5GF0rFVLmta8R0K+
         UDrXHdNA8YQ0AZOoxZIBUHznarajPVjE2w3Jxa+c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Reichl <hias@horus.com>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 089/209] media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 remote
Date:   Tue, 12 Nov 2019 20:48:25 -0500
Message-Id: <20191113015025.9685-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

[ Upstream commit 85e4af0a7ae2f146769b7475ae531bf8a3f3afb4 ]

The Kathrein RCU-676 remote uses the 32-bit rc6 protocol and toggles
bit 15 (0x8000) on repeated button presses, like MCE remotes.

Add it's customer code 0x80460000 to the 32-bit rc6 toggle
handling code to get proper scancodes and toggle reports.

Signed-off-by: Matthias Reichl <hias@horus.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir-rc6-decoder.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 68487ce9f79b6..d96aed1343e42 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -40,6 +40,7 @@
 #define RC6_6A_MCE_TOGGLE_MASK	0x8000	/* for the body bits */
 #define RC6_6A_LCC_MASK		0xffff0000 /* RC6-6A-32 long customer code mask */
 #define RC6_6A_MCE_CC		0x800f0000 /* MCE customer code */
+#define RC6_6A_KATHREIN_CC	0x80460000 /* Kathrein RCU-676 customer code */
 #ifndef CHAR_BIT
 #define CHAR_BIT 8	/* Normally in <limits.h> */
 #endif
@@ -242,13 +243,17 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 				toggle = 0;
 				break;
 			case 32:
-				if ((scancode & RC6_6A_LCC_MASK) == RC6_6A_MCE_CC) {
+				switch (scancode & RC6_6A_LCC_MASK) {
+				case RC6_6A_MCE_CC:
+				case RC6_6A_KATHREIN_CC:
 					protocol = RC_PROTO_RC6_MCE;
 					toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);
 					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
-				} else {
+					break;
+				default:
 					protocol = RC_PROTO_RC6_6A_32;
 					toggle = 0;
+					break;
 				}
 				break;
 			default:
-- 
2.20.1

