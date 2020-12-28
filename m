Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9A32E65C5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389590AbgL1N1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389587AbgL1N1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:27:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 768C7229EF;
        Mon, 28 Dec 2020 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161989;
        bh=WF8aRP6p1aUlzCdp0ecf9XIz/Sv0Ovile1e3WDDEPS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIXLvZf4hybVHQ5zxqIWa/o2YHMoQl8XChig9p8UA8p/AQi3qMeL54/TD8g0JXo0u
         9vl54KipkWDW8KYizts0vOPfKhNO41cVCmW03ruHOl9X6FycRMiW3ZjAYSJd+iR10l
         D7iwJg3ZbjlueNxSgixyR0qptOJxlumVI8CPpgMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/346] Input: ads7846 - fix unaligned access on 7845
Date:   Mon, 28 Dec 2020 13:47:48 +0100
Message-Id: <20201228124926.992222302@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 7ce0eedaa0e5e..b536768234b7c 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -35,6 +35,7 @@
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



