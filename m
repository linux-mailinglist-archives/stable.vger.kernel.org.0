Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53633B752
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhCOOAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhCON7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31DD864F5D;
        Mon, 15 Mar 2021 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816735;
        bh=2HPj8oLrztMtAUCh9hgAZnZg5TF3uvxDrlotwYjiObQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvrxcZ4eharmiKsFeRIgLJj7cf+bSWLel1ot/uM9FdtSUP2qwEQ6ZfQuB351NNOB2
         GuMrZsBeiGqriA5DqbVFH1zTCtpAga+9cpMWBcMKdX0VDwmlC3ZToU8oIWWanxxgRM
         /hLizkmtdGmuoK+64rovn42sEKZbbYDhW08ooBWo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Johan Hovold <johan@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 083/290] gpio: fix gpio-device list corruption
Date:   Mon, 15 Mar 2021 14:52:56 +0100
Message-Id: <20210315135544.723265412@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Johan Hovold <johan@kernel.org>

commit cf25ef6b631c6fc6c0435fc91eba8734cca20511 upstream.

Make sure to hold the gpio_lock when removing the gpio device from the
gpio_devices list (when dropping the last reference) to avoid corrupting
the list when there are concurrent accesses.

Fixes: ff2b13592299 ("gpio: make the gpiochip a real device")
Cc: stable@vger.kernel.org      # 4.6
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
[ johan: adjust context to 5.11 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -468,8 +468,12 @@ EXPORT_SYMBOL_GPL(gpiochip_line_is_valid
 static void gpiodevice_release(struct device *dev)
 {
 	struct gpio_device *gdev = dev_get_drvdata(dev);
+	unsigned long flags;
 
+	spin_lock_irqsave(&gpio_lock, flags);
 	list_del(&gdev->list);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
 	ida_free(&gpio_ida, gdev->id);
 	kfree_const(gdev->label);
 	kfree(gdev->descs);


