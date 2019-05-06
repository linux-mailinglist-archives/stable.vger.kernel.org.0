Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8379F14EAE
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfEFOj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727465AbfEFOj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC70214AE;
        Mon,  6 May 2019 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153597;
        bh=zxlYefP47DFqSGibVPrbuROJZDuq76+KTbQaLHVeOiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbl1vEb0bPdaLmgc2jbr0KjpDlZYeJQu58yMOW3V8XtLvjlrTDOIogCg2UNKBTNDE
         7IMBiNPVzdA1L89j9lolJKl6Bc/IYh0UfaJWP95sUP0dl8qoLVPj4rBBHb4tMiHUdY
         tPdu24gSBdBoSEQLiUmpX6qBYOwkRVf9WmFs7W3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Broadus <jbroadus@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 08/99] i2c: Allow recovery of the initial IRQ by an I2C client device.
Date:   Mon,  6 May 2019 16:31:41 +0200
Message-Id: <20190506143054.617663858@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Broadus <jbroadus@gmail.com>

commit 93b6604c5a669d84e45fe5129294875bf82eb1ff upstream.

A previous change allowed I2C client devices to discover new IRQs upon
reprobe by clearing the IRQ in i2c_device_remove. However, if an IRQ was
assigned in i2c_new_device, that information is lost.

For example, the touchscreen and trackpad devices on a Dell Inspiron laptop
are I2C devices whose IRQs are defined by ACPI extended IRQ types. The
client device structures are initialized during an ACPI walk. After
removing the i2c_hid device, modprobe fails.

This change caches the initial IRQ value in i2c_new_device and then resets
the client device IRQ to the initial value in i2c_device_remove.

Fixes: 6f108dd70d30 ("i2c: Clear client->irq in i2c_device_remove")
Signed-off-by: Jim Broadus <jbroadus@gmail.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
[wsa: this is an easy to backport fix for the regression. We will
refactor the code to handle irq assignments better in general.]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-base.c |    9 +++++----
 include/linux/i2c.h         |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -430,7 +430,7 @@ static int i2c_device_remove(struct devi
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
 
-	client->irq = 0;
+	client->irq = client->init_irq;
 
 	return status;
 }
@@ -741,10 +741,11 @@ i2c_new_device(struct i2c_adapter *adap,
 	client->flags = info->flags;
 	client->addr = info->addr;
 
-	client->irq = info->irq;
-	if (!client->irq)
-		client->irq = i2c_dev_irq_from_resources(info->resources,
+	client->init_irq = info->irq;
+	if (!client->init_irq)
+		client->init_irq = i2c_dev_irq_from_resources(info->resources,
 							 info->num_resources);
+	client->irq = client->init_irq;
 
 	strlcpy(client->name, info->type, sizeof(client->name));
 
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -333,6 +333,7 @@ struct i2c_client {
 	char name[I2C_NAME_SIZE];
 	struct i2c_adapter *adapter;	/* the adapter we sit on	*/
 	struct device dev;		/* the device structure		*/
+	int init_irq;			/* irq set at initialization	*/
 	int irq;			/* irq issued by device		*/
 	struct list_head detected;
 #if IS_ENABLED(CONFIG_I2C_SLAVE)


