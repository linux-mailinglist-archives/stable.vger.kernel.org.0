Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67EE51881A0
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgCQLGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbgCQLGh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:06:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C201C20658;
        Tue, 17 Mar 2020 11:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443197;
        bh=b+dT2WJfsjgAtzNNSBjjsrruhNxhdxhBaqv0UWRxRRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYyjoSpGI/Vonaxr8DxZ+VV3mOKFdm90/FqX46oRqY3Wka/M7FKb/Cr5Ry7z2vjS6
         ZVE6J9Lxsg4XJ6g7dy+gLtj0XW4z7jsM1Hz8ZWX+Eojzxos2oqRc+yjjlAIQRhkSjD
         Cn/RUGe2+zKmG7OaFzZylpI311x0xnnTQ2ylUrI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 119/123] i2c: acpi: put device when verifying client fails
Date:   Tue, 17 Mar 2020 11:55:46 +0100
Message-Id: <20200317103319.462938562@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 8daee952b4389729358665fb91949460641659d4 upstream.

i2c_verify_client() can fail, so we need to put the device when that
happens.

Fixes: 525e6fabeae2 ("i2c / ACPI: add support for ACPI reconfigure notifications")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-acpi.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -394,9 +394,17 @@ EXPORT_SYMBOL_GPL(i2c_acpi_find_adapter_
 static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
 {
 	struct device *dev;
+	struct i2c_client *client;
 
 	dev = bus_find_device_by_acpi_dev(&i2c_bus_type, adev);
-	return dev ? i2c_verify_client(dev) : NULL;
+	if (!dev)
+		return NULL;
+
+	client = i2c_verify_client(dev);
+	if (!client)
+		put_device(dev);
+
+	return client;
 }
 
 static int i2c_acpi_notify(struct notifier_block *nb, unsigned long value,


