Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C782C0951
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbgKWNGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbgKWMtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18079208C3;
        Mon, 23 Nov 2020 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135786;
        bh=e5YWtXHMtGAvq2idZ2sIb6ueOCQeBhHS+q8/QzGoEuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLKQIqf4ay9B16HRK364w545YGrw+Xh7STwB2YgRBYFp8KHYeWBW12Udb63GZSHi6
         bhw+GFgvXzueRFdqQCpr4Xly5TWbLB0O7kjCQcmjw+kcwRBZlqOnBcViUrf0hhv4Dl
         49PGiMYuImoRWSmpHRW54YYbYFk80TuuV9b1iUk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Lechner <david@lechnology.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 178/252] counter/ti-eqep: Fix regmap max_register
Date:   Mon, 23 Nov 2020 13:22:08 +0100
Message-Id: <20201123121844.185927139@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Lechner <david@lechnology.com>

[ Upstream commit 271b339236e1c0e6448bc1cafeaedcb529324bf0 ]

The values given were the offset of the register after the last
register instead of the actual last register in each range. Fix
by using the correct last register of each range.

Fixes: f213729f6796 ("counter: new TI eQEP driver")
Signed-off-by: David Lechner <david@lechnology.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Link: https://lore.kernel.org/r/20201025165122.607866-1-david@lechnology.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/ti-eqep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/counter/ti-eqep.c b/drivers/counter/ti-eqep.c
index 1ff07faef27f3..5d6470968d2cd 100644
--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -368,7 +368,7 @@ static const struct regmap_config ti_eqep_regmap32_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-	.max_register = 0x24,
+	.max_register = QUPRD,
 };
 
 static const struct regmap_config ti_eqep_regmap16_config = {
@@ -376,7 +376,7 @@ static const struct regmap_config ti_eqep_regmap16_config = {
 	.reg_bits = 16,
 	.val_bits = 16,
 	.reg_stride = 2,
-	.max_register = 0x1e,
+	.max_register = QCPRDLAT,
 };
 
 static int ti_eqep_probe(struct platform_device *pdev)
-- 
2.27.0



