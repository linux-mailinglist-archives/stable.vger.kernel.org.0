Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40EB3C4BE1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbhGLHAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239690AbhGLG6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A9C0613E6;
        Mon, 12 Jul 2021 06:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072959;
        bh=3Ias84A1L0Hif1Cme659SldcyuX/j2nCQoKvazpJGcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WA35ZXKhmhE5uXqb/T2epy7QZ72XqUjprUi79mxha7M2jvgsMt9feQcZf+Azwa9EM
         4epHtCbzdKxfnUL2Kwg/QMD+dhgl/synFNOGgCTATmmSw5fdsEYVw4ZmyNN9dC1Jis
         mweVJV0UdBC/Ng99GbyjjDYpw6upifLtaKbTZp/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.12 036/700] Input: elants_i2c - fix NULL dereference at probing
Date:   Mon, 12 Jul 2021 08:01:59 +0200
Message-Id: <20210712060929.717179516@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit b9c0ebb867d67cc4e9e1a7a2abf0ac9a2cc02051 upstream.

The recent change in elants_i2c driver to support more chips
introduced a regression leading to Oops at probing.  The driver reads
id->driver_data, but the id may be NULL depending on the device type
the driver gets bound.

Replace the driver data extraction with the device_get_match_data()
helper, and define the driver data in OF table, too.

Fixes: 9517b95bdc46 ("Input: elants_i2c - add support for eKTF3624")
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1186454
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210528071024.26450-1-tiwai@suse.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/elants_i2c.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -1396,7 +1396,7 @@ static int elants_i2c_probe(struct i2c_c
 	init_completion(&ts->cmd_done);
 
 	ts->client = client;
-	ts->chip_id = (enum elants_chip_id)id->driver_data;
+	ts->chip_id = (enum elants_chip_id)(uintptr_t)device_get_match_data(&client->dev);
 	i2c_set_clientdata(client, ts);
 
 	ts->vcc33 = devm_regulator_get(&client->dev, "vcc33");
@@ -1636,8 +1636,8 @@ MODULE_DEVICE_TABLE(acpi, elants_acpi_id
 
 #ifdef CONFIG_OF
 static const struct of_device_id elants_of_match[] = {
-	{ .compatible = "elan,ekth3500" },
-	{ .compatible = "elan,ektf3624" },
+	{ .compatible = "elan,ekth3500", .data = (void *)EKTH3500 },
+	{ .compatible = "elan,ektf3624", .data = (void *)EKTF3624 },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, elants_of_match);


