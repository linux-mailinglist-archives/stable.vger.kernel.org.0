Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B6B2E3B21
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405406AbgL1Nqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404979AbgL1Np7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74ACB2064B;
        Mon, 28 Dec 2020 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163119;
        bh=+i5W4b2EOugmy/0x7yCwUYxqEYLj6+9BCue1sUi+R14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAh+RAxazjMur91qedBWA1CtGe16vB0eAf1Wsnwd7/BVEtkp5E7Xbk/vDRkHL6Rem
         T6LV6o5CTMWhJmDSCFrP6MHcvYzXvKrgYqrObqek6mbkhC3o1U8j+NKakwiAaeiQIw
         OFswh8hDRMUk2rGSsUGomRnsK3lrT3zROWaYxkjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/453] Input: ads7846 - fix unaligned access on 7845
Date:   Mon, 28 Dec 2020 13:46:20 +0100
Message-Id: <20201228124944.131724365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index a5b1b41464f99..d247d0ae82d26 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -33,6 +33,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 #include <asm/irq.h>
+#include <asm/unaligned.h>
 
 /*
  * This code has been heavily tested on a Nokia 770, and lightly
@@ -434,7 +435,7 @@ static int ads7845_read12_ser(struct device *dev, unsigned command)
 
 	if (status == 0) {
 		/* BE12 value, then padding */
-		status = be16_to_cpu(*((u16 *)&req->sample[1]));
+		status = get_unaligned_be16(&req->sample[1]);
 		status = status >> 3;
 		status &= 0x0fff;
 	}
-- 
2.27.0



