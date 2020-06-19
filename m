Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7B3200D24
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbgFSOxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388056AbgFSOxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E4FE2184D;
        Fri, 19 Jun 2020 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578419;
        bh=+/l/HKb94QJ1fLl/aY9Ci1ZVow5m6nAWV0fLci86yno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRmQ3t659e6zXAk0TUYNfrV2O0gdLr1cbZ0glZCaC8pwcjEuy8ogxX1GoOGGXtyP5
         rJ7yq1fJCOawT5pkwZCrLQRX54dWC8FHZW5QWGr4k3WMqOqqLtKI6lWpD4+k6Ba4TN
         4hvIGOmdUBRv4tQZzDVbkCW8OyC1Bcv5rvlXvv2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Shyti <andi@etezian.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/267] Input: mms114 - fix handling of mms345l
Date:   Fri, 19 Jun 2020 16:30:00 +0200
Message-Id: <20200619141649.589413506@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 3f8f770575d911c989043d8f0fb8dec96360c41c ]

MMS345L is another first generation touch screen from Melfas,
which uses the same registers as MMS152.

However, using I2C_M_NOSTART for it causes errors when reading:

	i2c i2c-0: sendbytes: NAK bailout.
	mms114 0-0048: __mms114_read_reg: i2c transfer failed (-5)

The driver works fine as soon as I2C_M_NOSTART is removed.

Reviewed-by: Andi Shyti <andi@etezian.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200405170904.61512-1-stephan@gerhold.net
[dtor: removed separate mms345l handling, made everyone use standard
transfer mode, propagated the 10bit addressing flag to the read part of the
transfer as well.]
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/mms114.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/mms114.c b/drivers/input/touchscreen/mms114.c
index a5ab774da4cc..fca908ba4841 100644
--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -91,15 +91,15 @@ static int __mms114_read_reg(struct mms114_data *data, unsigned int reg,
 	if (reg <= MMS114_MODE_CONTROL && reg + len > MMS114_MODE_CONTROL)
 		BUG();
 
-	/* Write register: use repeated start */
+	/* Write register */
 	xfer[0].addr = client->addr;
-	xfer[0].flags = I2C_M_TEN | I2C_M_NOSTART;
+	xfer[0].flags = client->flags & I2C_M_TEN;
 	xfer[0].len = 1;
 	xfer[0].buf = &buf;
 
 	/* Read data */
 	xfer[1].addr = client->addr;
-	xfer[1].flags = I2C_M_RD;
+	xfer[1].flags = (client->flags & I2C_M_TEN) | I2C_M_RD;
 	xfer[1].len = len;
 	xfer[1].buf = val;
 
@@ -428,10 +428,8 @@ static int mms114_probe(struct i2c_client *client,
 	const void *match_data;
 	int error;
 
-	if (!i2c_check_functionality(client->adapter,
-				I2C_FUNC_PROTOCOL_MANGLING)) {
-		dev_err(&client->dev,
-			"Need i2c bus that supports protocol mangling\n");
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "Not supported I2C adapter\n");
 		return -ENODEV;
 	}
 
-- 
2.25.1



