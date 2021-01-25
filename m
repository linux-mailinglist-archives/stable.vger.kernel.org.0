Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA41A3033AE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbhAZFCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbhAYSvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A938224BE;
        Mon, 25 Jan 2021 18:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600695;
        bh=kIRdwGo8LZL+TXwsq1jvgKyldgBXSyokFzLQcQrFZxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wjf4rT+5P72w7NHhxk72bNvFaRsOGd1vND2uLPuBjFL1MlIrwd42LPC+nDoYxglk1
         vTD6ncv0Lb7opIvOS3a53FlIkUxmYug6FAP1TbBDwhWwSK0gqNGQE4Ek61tzZbTbc9
         b8dQL3Zo8KWDjNSLZ43K6d7TA7zw5wEX6GnqGZBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Lechner <david@lechnology.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 115/199] counter:ti-eqep: remove floor
Date:   Mon, 25 Jan 2021 19:38:57 +0100
Message-Id: <20210125183221.089361525@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Lechner <david@lechnology.com>

commit 49a9565a7a7ce168e3e6482fb24e62d12f72ab81 upstream.

The hardware doesn't support this. QPOSINIT is an initialization value
that is triggered by other things. When the counter overflows, it
always wraps around to zero.

Fixes: f213729f6796 "counter: new TI eQEP driver"
Signed-off-by: David Lechner <david@lechnology.com>
Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Link: https://lore.kernel.org/r/20201214000927.1793062-1-david@lechnology.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/counter/ti-eqep.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

--- a/drivers/counter/ti-eqep.c
+++ b/drivers/counter/ti-eqep.c
@@ -235,36 +235,6 @@ static ssize_t ti_eqep_position_ceiling_
 	return len;
 }
 
-static ssize_t ti_eqep_position_floor_read(struct counter_device *counter,
-					   struct counter_count *count,
-					   void *ext_priv, char *buf)
-{
-	struct ti_eqep_cnt *priv = counter->priv;
-	u32 qposinit;
-
-	regmap_read(priv->regmap32, QPOSINIT, &qposinit);
-
-	return sprintf(buf, "%u\n", qposinit);
-}
-
-static ssize_t ti_eqep_position_floor_write(struct counter_device *counter,
-					    struct counter_count *count,
-					    void *ext_priv, const char *buf,
-					    size_t len)
-{
-	struct ti_eqep_cnt *priv = counter->priv;
-	int err;
-	u32 res;
-
-	err = kstrtouint(buf, 0, &res);
-	if (err < 0)
-		return err;
-
-	regmap_write(priv->regmap32, QPOSINIT, res);
-
-	return len;
-}
-
 static ssize_t ti_eqep_position_enable_read(struct counter_device *counter,
 					    struct counter_count *count,
 					    void *ext_priv, char *buf)
@@ -302,11 +272,6 @@ static struct counter_count_ext ti_eqep_
 		.write	= ti_eqep_position_ceiling_write,
 	},
 	{
-		.name	= "floor",
-		.read	= ti_eqep_position_floor_read,
-		.write	= ti_eqep_position_floor_write,
-	},
-	{
 		.name	= "enable",
 		.read	= ti_eqep_position_enable_read,
 		.write	= ti_eqep_position_enable_write,


