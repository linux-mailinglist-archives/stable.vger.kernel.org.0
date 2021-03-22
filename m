Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18953441BA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhCVMfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhCVMeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89428619A5;
        Mon, 22 Mar 2021 12:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416448;
        bh=QlAqA5k91zoYH+LE31PUEaD1an22jTY0F+53Wi1uTe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxUAjdga64P3W8n/Y4XhtBQCx7yCxBhrADPJGbMZcvo7V5FA6LWKi/2PcgoUaZBr4
         IS5QO4SU8gVA8pKVbHczsS2zA0OFwWpsKlVvkeRfHr4bfTLQf9OExjyWltGegg3HjJ
         ytPIQdAn4wbOkpzbojN7ouX6p53qjrk0pscYXjlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 075/120] gpiolib: Assign fwnode to parents if no primary one provided
Date:   Mon, 22 Mar 2021 13:27:38 +0100
Message-Id: <20210322121932.178565570@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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
index e4cfa27f6893..a4a47305574c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -573,6 +573,7 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			       struct lock_class_key *lock_key,
 			       struct lock_class_key *request_key)
 {
+	struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
 	unsigned long	flags;
 	int		ret = 0;
 	unsigned	i;
@@ -602,6 +603,12 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
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



