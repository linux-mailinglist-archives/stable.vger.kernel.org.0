Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAA114C62
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfEFOjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727911AbfEFOjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D19020449;
        Mon,  6 May 2019 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153594;
        bh=WUgK1XaP9CKxLVpil8QiQgTYWULgkduitlNHJqWTq7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdkijRLpNdfRRdXftbLVYf0VulmVJzzuy2OYVRhZMb1KZJ4eJ45W3KXfmPcI8L/03
         2xosVCFzAbjhaQHWalZ8QCSIHyeJRBiXjWFWNKQPqg5qToPu7veKHl1JpDIT2V2cxV
         o7eBgapDaGGDBsu6WZso+cw9tUcq4BLj4gAkFv1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 07/99] i2c: Clear client->irq in i2c_device_remove
Date:   Mon,  6 May 2019 16:31:40 +0200
Message-Id: <20190506143054.531634333@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

commit 6f108dd70d3010c391c1e9f56f3f20d1f9e75450 upstream.

The IRQ will be mapped in i2c_device_probe only if client->irq is zero and
i2c_device_remove does not clear this. When rebinding an I2C device,
whos IRQ provider has also been rebound this means that an IRQ mapping
will never be created, causing the I2C device to fail to acquire its
IRQ. Fix this issue by clearing client->irq in i2c_device_remove,
forcing i2c_device_probe to lookup the mapping again.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-base.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -430,6 +430,8 @@ static int i2c_device_remove(struct devi
 	dev_pm_clear_wake_irq(&client->dev);
 	device_init_wakeup(&client->dev, false);
 
+	client->irq = 0;
+
 	return status;
 }
 


