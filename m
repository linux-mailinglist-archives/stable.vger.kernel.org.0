Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0768C1570
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfI2OEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbfI2OEM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:04:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D7E2082F;
        Sun, 29 Sep 2019 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765851;
        bh=ycVtQSzkyz8L8hAEyRtDzR1Rj+c+zpn/rD+u8cVqfuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dNcP0nrqCqRJwgshrC3PgQRU7rDKaDmvGobGsoipJohxpGVY8LvuYUrh6kVGzOtK
         2lFy4vLqUFlkDRa2jGRnW7m+aJ3LvjfGJ8DmED88rpuv5a4jVKF9rKNETWmv52DmnB
         rKwLrzAsbmrUxhD6C/WnrrvO+HzRJqQDEJOVb5U0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.3 24/25] platform/x86: i2c-multi-instantiate: Derive the device name from parent
Date:   Sun, 29 Sep 2019 15:56:27 +0200
Message-Id: <20190929135018.079215925@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 24a8d78a9affb63e5ced313ccde6888fe96edc6e upstream.

When naming the new devices, instead of using the ACPI ID in
the name as base, using the parent device's name. That makes
it possible to support multiple multi-instance i2c devices
of the same type in the same system.

This fixes an issue seen on some Intel Kaby Lake based
boards:

sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-INT3515-tps6598x.0'

Fixes: 2336dfadfb1e ("platform/x86: i2c-multi-instantiate: Allow to have same slaves")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/i2c-multi-instantiate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -92,7 +92,7 @@ static int i2c_multi_inst_probe(struct p
 	for (i = 0; i < multi->num_clients && inst_data[i].type; i++) {
 		memset(&board_info, 0, sizeof(board_info));
 		strlcpy(board_info.type, inst_data[i].type, I2C_NAME_SIZE);
-		snprintf(name, sizeof(name), "%s-%s.%d", match->id,
+		snprintf(name, sizeof(name), "%s-%s.%d", dev_name(dev),
 			 inst_data[i].type, i);
 		board_info.dev_name = name;
 		switch (inst_data[i].flags & IRQ_RESOURCE_TYPE) {


