Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5674C344237
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhCVMjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhCVMiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECC666191A;
        Mon, 22 Mar 2021 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416636;
        bh=dTCL/+dN70IZPzkAaRmRsrOUjpj3Q/I6EmMdO62ctio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+0Ynnv3LwYkKXtzq/24Y5501AFSEzrN8PgTKbmlKSI/N9zXSCFPABJ3IkLkldMgb
         aL1VcGYTQcAEJ45IYrHjaKZkh1fAHpe1XtlqHLDxDclVFTF6gOLBvZXAYC9Q2CO3GE
         Cqq49Y2x5AQPYHrJmFtF5xUAHZlMQa/Xsk0MuC5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/157] gpiolib: Assign fwnode to parents if no primary one provided
Date:   Mon, 22 Mar 2021 13:26:58 +0100
Message-Id: <20210322121935.692206059@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6cb59afe9e5b45a035bd6b97da6593743feefc72 ]

In case when the properties are supplied in the secondary fwnode
(for example, built-in device properties) the fwnode pointer left
unassigned. This makes unable to retrieve them.

Assign fwnode to parent's if no primary one provided.

Fixes: 7cba1a4d5e16 ("gpiolib: generalize devprop_gpiochip_set_names() for device properties")
Fixes: 2afa97e9868f ("gpiolib: Read "gpio-line-names" from a firmware node")
Reported-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Tested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7f557ea90542..0a2c4adcd833 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -572,6 +572,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			       struct lock_class_key *lock_key,
 			       struct lock_class_key *request_key)
 {
+	struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
 	unsigned long	flags;
 	int		ret = 0;
 	unsigned	i;
@@ -601,6 +602,12 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 		gc->of_node = gdev->dev.of_node;
 #endif
 
+	/*
+	 * Assign fwnode depending on the result of the previous calls,
+	 * if none of them succeed, assign it to the parent's one.
+	 */
+	gdev->dev.fwnode = dev_fwnode(&gdev->dev) ?: fwnode;
+
 	gdev->id = ida_alloc(&gpio_ida, GFP_KERNEL);
 	if (gdev->id < 0) {
 		ret = gdev->id;
-- 
2.30.1



