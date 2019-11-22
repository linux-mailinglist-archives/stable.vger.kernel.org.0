Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96475106C76
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfKVKwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbfKVKwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:52:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92FF20637;
        Fri, 22 Nov 2019 10:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419936;
        bh=1CoKczlBB1iIl9HG7yyi/uWIsWV4eb00AiNisJOIj7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1m95bzQW7KllZtFai7yxPsRwT34RzRfW+2BcDNTh73hTxZmJO9hRglTBZhugBBwJ
         nddwjFpgpm1NAiBVql+1rnjalWWzHEYdfIdsunQ5cqNQnXvbMZu/sCxILSitotSQLf
         nbpg8p1BN6OSXqVEkhGatuGvJqEx420C0FGBNwSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 058/122] media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 remote
Date:   Fri, 22 Nov 2019 11:28:31 +0100
Message-Id: <20191122100802.876156487@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5d0d2fe3b7a7f..90f7930444a1a 100644
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
@@ -252,13 +253,17 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
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



