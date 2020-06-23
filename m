Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9C420647C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389720AbgFWVWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390075AbgFWUV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:21:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46F9E2070E;
        Tue, 23 Jun 2020 20:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943716;
        bh=s5Av0cn0lWy/ni/ou5/q32AMdK9Y8C+rQFikprJ8gjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sb//rq9W8mSn5MpzAcjI1wKwex/SAuq2+GjZcgnUVbjTCbFqxkos63N8UX+YsP86f
         JhfB5FHkraUIGIqIwW4V+QVh3fPSQB5EZ7gIfFKlXOkRxH5nw2hVXBkIUVx6gLGH46
         04mmOc0zAxshy7/P5ug9D5hOBn14QWrESC9EqxaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/314] Input: edt-ft5x06 - fix get_default register write access
Date:   Tue, 23 Jun 2020 21:53:37 +0200
Message-Id: <20200623195339.843876682@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 255cdaf73412de13608fb776101402dca68bed2b ]

Since commit b6eba86030bf ("Input: edt-ft5x06 - add offset support for
ev-ft5726") offset-x and offset-y is supported. Devices using those
offset parameters don't support the offset parameter so we need to add
the NO_REGISTER check for edt_ft5x06_ts_get_defaults().

Fixes: b6eba86030bf ("Input: edt-ft5x06 - add offset support for ev-ft5726")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20200227112819.16754-2-m.felsch@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/edt-ft5x06.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 240e8de24cd24..b41b97c962edc 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -935,19 +935,25 @@ static void edt_ft5x06_ts_get_defaults(struct device *dev,
 
 	error = device_property_read_u32(dev, "offset", &val);
 	if (!error) {
-		edt_ft5x06_register_write(tsdata, reg_addr->reg_offset, val);
+		if (reg_addr->reg_offset != NO_REGISTER)
+			edt_ft5x06_register_write(tsdata,
+						  reg_addr->reg_offset, val);
 		tsdata->offset = val;
 	}
 
 	error = device_property_read_u32(dev, "offset-x", &val);
 	if (!error) {
-		edt_ft5x06_register_write(tsdata, reg_addr->reg_offset_x, val);
+		if (reg_addr->reg_offset_x != NO_REGISTER)
+			edt_ft5x06_register_write(tsdata,
+						  reg_addr->reg_offset_x, val);
 		tsdata->offset_x = val;
 	}
 
 	error = device_property_read_u32(dev, "offset-y", &val);
 	if (!error) {
-		edt_ft5x06_register_write(tsdata, reg_addr->reg_offset_y, val);
+		if (reg_addr->reg_offset_y != NO_REGISTER)
+			edt_ft5x06_register_write(tsdata,
+						  reg_addr->reg_offset_y, val);
 		tsdata->offset_y = val;
 	}
 }
-- 
2.25.1



