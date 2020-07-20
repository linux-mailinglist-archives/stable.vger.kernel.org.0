Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A8F2265F7
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgGTP7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732115AbgGTP7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8059322BEF;
        Mon, 20 Jul 2020 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260745;
        bh=eWR97KZdZqdhZuunMtUlHVwl+sGP4UI1lXvOCitD8/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7mLKtSLb2eft6e+PNsoQ9dfAFKZlZdzVmiRwUQVOFbAm9C2tqaCc77Vljw0VEzAw
         CzShwgwCRdqmtMvkLPW1UTeI1rwFcxXWyVuR67Ha2Ba+i2mkCPP69z/wyKawASRZKW
         IYoZPzp0qHmWtKIgPkN8lOe/YxKzfPZUcB+A+90o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Sergei A. Trusov" <sergei.a.trusov@ya.ru>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, Arkadiy <arkan49@yandex.ru>
Subject: [PATCH 5.4 081/215] Input: goodix - fix touch coordinates on Cube I15-TC
Date:   Mon, 20 Jul 2020 17:36:03 +0200
Message-Id: <20200720152824.065026716@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei A. Trusov <sergei.a.trusov@ya.ru>

[ Upstream commit 1dd5ddc125b4625c3beb8e644ae872445d739bbc ]

The touchscreen on the Cube I15-TC don't match the default display,
with 0,0 touches being reported when touching at the top-right of
the screen.

Add a quirk to invert the x coordinate.

Reported-and-tested-by: Arkadiy <arkan49@yandex.ru>
Signed-off-by: Sergei A. Trusov <sergei.a.trusov@ya.ru>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 0403102e807e1..37b35ab97beb2 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -168,6 +168,22 @@ static const struct dmi_system_id nine_bytes_report[] = {
 	{}
 };
 
+/*
+ * Those tablets have their x coordinate inverted
+ */
+static const struct dmi_system_id inverted_x_screen[] = {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		.ident = "Cube I15-TC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Cube"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "I15-TC")
+		},
+	},
+#endif
+	{}
+};
+
 /**
  * goodix_i2c_read - read data from a register of the i2c slave device.
  *
@@ -780,6 +796,12 @@ static int goodix_configure_dev(struct goodix_ts_data *ts)
 			"Non-standard 9-bytes report format quirk\n");
 	}
 
+	if (dmi_check_system(inverted_x_screen)) {
+		ts->prop.invert_x = true;
+		dev_dbg(&ts->client->dev,
+			"Applying 'inverted x screen' quirk\n");
+	}
+
 	error = input_mt_init_slots(ts->input_dev, ts->max_touch_num,
 				    INPUT_MT_DIRECT | INPUT_MT_DROP_UNUSED);
 	if (error) {
-- 
2.25.1



