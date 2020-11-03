Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAA52A5510
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbgKCVLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:11:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388832AbgKCVLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:11:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAFB207BC;
        Tue,  3 Nov 2020 21:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437870;
        bh=nzp28d2X08fYjfIAM5S0jS5CbBVb1+KgCSY2J8t2AOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkcOlbL1O/E3IpLksiuoLiMfK9jCPVj7n3IvFFzft02ZMC2WS1EP2yjh3SeA5U67R
         N63PnLAfMbg0IMyR7P2SnVNyS0MUe4UTYMB9ksLoS+Bot8T8ffft33hL5OwuF0dZ9m
         p5ZSodFXlSNRBA9XXEa+Sr3WRUOHoZyTsHaBgVgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/125] drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly
Date:   Tue,  3 Nov 2020 21:36:45 +0100
Message-Id: <20201103203200.790358467@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit f688a345f0d7a6df4dd2aeca8e4f3c05e123a0ee ]

If ge_b850v3_lvds_init() does not allocate memory for ge_b850v3_lvds_ptr,
then a null pointer dereference is accessed.

The patch adds checking of the return value of ge_b850v3_lvds_init().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200819143756.30626-1-lutovinova@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 7ccadba7c98cd..9f522372a4884 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -306,8 +306,12 @@ static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,
 				       const struct i2c_device_id *id)
 {
 	struct device *dev = &stdp4028_i2c->dev;
+	int ret;
+
+	ret = ge_b850v3_lvds_init(dev);
 
-	ge_b850v3_lvds_init(dev);
+	if (ret)
+		return ret;
 
 	ge_b850v3_lvds_ptr->stdp4028_i2c = stdp4028_i2c;
 	i2c_set_clientdata(stdp4028_i2c, ge_b850v3_lvds_ptr);
@@ -365,8 +369,12 @@ static int stdp2690_ge_b850v3_fw_probe(struct i2c_client *stdp2690_i2c,
 				       const struct i2c_device_id *id)
 {
 	struct device *dev = &stdp2690_i2c->dev;
+	int ret;
+
+	ret = ge_b850v3_lvds_init(dev);
 
-	ge_b850v3_lvds_init(dev);
+	if (ret)
+		return ret;
 
 	ge_b850v3_lvds_ptr->stdp2690_i2c = stdp2690_i2c;
 	i2c_set_clientdata(stdp2690_i2c, ge_b850v3_lvds_ptr);
-- 
2.27.0



