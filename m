Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA331881E0
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgCQLUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727160AbgCQK7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B3020714;
        Tue, 17 Mar 2020 10:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442792;
        bh=V4xWq3JFZKaFnCaWtFMsf0H1tB3lHuRr4tXUOBArnFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikmgOROJixUkpObLPbxSW4XD7Gkn8hGALBKWuTkmcBLUTbPwg2jbuGU0strCzLGUz
         sK22COktQTrOf8/gXcrmcMc4RVIRPQtSfPuNC+D+33PmtryDwr7XvzX8G6KC1KtndU
         oMOQPDXg9bwtg5kCsnqYWeWc64/mLm+tW0QkWM80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 84/89] i2c: acpi: put device when verifying client fails
Date:   Tue, 17 Mar 2020 11:55:33 +0100
Message-Id: <20200317103309.750851422@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
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
@@ -352,10 +352,18 @@ static struct i2c_adapter *i2c_acpi_find
 static struct i2c_client *i2c_acpi_find_client_by_adev(struct acpi_device *adev)
 {
 	struct device *dev;
+	struct i2c_client *client;
 
 	dev = bus_find_device(&i2c_bus_type, NULL, adev,
 			      i2c_acpi_find_match_device);
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


