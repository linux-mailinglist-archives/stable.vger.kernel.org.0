Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BBF2E41A6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440652AbgL1PKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438458AbgL1OHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37DA6207BC;
        Mon, 28 Dec 2020 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164435;
        bh=vTFfNL77Rq31JNEYvSOY56B3lMMKjcYx11cGGL6awqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXZacnVAVK5ChQdXl4n3uGHqNRIGoSYdwTubBCh549HeBkkptHvAXLc3lrDIHtfSn
         c1jgxEf4nsSybZ2heeCQBDW5HKzJD6Gnu2YWsvGONXrzknM5QuyhZ6kSWR8g+G4oSP
         RfVghG2j4JXH/2dsy0a/FygWdEidgk7WW3tjDins=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/717] Input: ads7846 - fix unaligned access on 7845
Date:   Mon, 28 Dec 2020 13:42:27 +0100
Message-Id: <20201228125028.102332804@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 03e2c9c782f721b661a0e42b1b58f394b5298544 ]

req->sample[1] is not naturally aligned at word boundary, and therefore we
should use get_unaligned_be16() when accessing it.

Fixes: 3eac5c7e44f3 ("Input: ads7846 - extend the driver for ads7845 controller support")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 78ed285c27ae3..ff97897feaf2a 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -33,6 +33,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 #include <asm/irq.h>
+#include <asm/unaligned.h>
 
 /*
  * This code has been heavily tested on a Nokia 770, and lightly
@@ -435,7 +436,7 @@ static int ads7845_read12_ser(struct device *dev, unsigned command)
 
 	if (status == 0) {
 		/* BE12 value, then padding */
-		status = be16_to_cpu(*((u16 *)&req->sample[1]));
+		status = get_unaligned_be16(&req->sample[1]);
 		status = status >> 3;
 		status &= 0x0fff;
 	}
-- 
2.27.0



