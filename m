Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749B728E268
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgJNOmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 10:42:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728010AbgJNOmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 10:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602686528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PlJoLtIpkVOz1qyb1zjr6+0JD61+zNOgWz6cLK2byzI=;
        b=C4AjXVjdVGUKCu5oNCj9/TDbYMSbriuAdgzvCQEUImzrRWIM1gE6B7PLDUkGkd3cTvqMlT
        DP9g+JU8kE6dYHrKCxrodkcfAA0AmoPGSjhuwZ6Ao8YJ37KKI4SYyADgpu93TW6gsLLLsx
        fA9kg/VB8anBv5GUvm7YCxkocWqPL/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-X78Fyf9RO3q9XwTFpdIA2w-1; Wed, 14 Oct 2020 10:42:06 -0400
X-MC-Unique: X78Fyf9RO3q9XwTFpdIA2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F5421021213;
        Wed, 14 Oct 2020 14:42:04 +0000 (UTC)
Received: from x1.localdomain (ovpn-112-126.ams2.redhat.com [10.36.112.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90CFC6EF7B;
        Wed, 14 Oct 2020 14:42:02 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 5.8+ regression fix] i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs
Date:   Wed, 14 Oct 2020 16:41:58 +0200
Message-Id: <20201014144158.18036-2-hdegoede@redhat.com>
In-Reply-To: <20201014144158.18036-1-hdegoede@redhat.com>
References: <20201014144158.18036-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 21653a4181ff ("i2c: core: Call i2c_acpi_install_space_handler()
before i2c_acpi_register_devices()")'s intention was to only move the
acpi_install_address_space_handler() call to the point before where
the ACPI declared i2c-children of the adapter where instantiated by
i2c_acpi_register_devices().

But i2c_acpi_install_space_handler() had a call to
acpi_walk_dep_device_list() hidden (that is I missed it) at the end
of it, so as an unwanted side-effect now acpi_walk_dep_device_list()
was also being called before i2c_acpi_register_devices().

Move the acpi_walk_dep_device_list() call to the end of
i2c_acpi_register_devices(), so that it is once again called *after*
the i2c_client-s hanging of the adapter have been created.

This fixes the Microsoft Surface Go 2 hanging at boot.

Fixes: 21653a4181ff ("i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()")
Suggested-by: Maximilian Luz <luzmaximilian@gmail.com>
Reported-and-tested-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/i2c/i2c-core-acpi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index e627d7b2790f..37c510d9347a 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -264,6 +264,7 @@ static acpi_status i2c_acpi_add_device(acpi_handle handle, u32 level,
 void i2c_acpi_register_devices(struct i2c_adapter *adap)
 {
 	acpi_status status;
+	acpi_handle handle;
 
 	if (!has_acpi_companion(&adap->dev))
 		return;
@@ -274,6 +275,15 @@ void i2c_acpi_register_devices(struct i2c_adapter *adap)
 				     adap, NULL);
 	if (ACPI_FAILURE(status))
 		dev_warn(&adap->dev, "failed to enumerate I2C slaves\n");
+
+	if (!adap->dev.parent)
+		return;
+
+	handle = ACPI_HANDLE(adap->dev.parent);
+	if (!handle)
+		return;
+
+	acpi_walk_dep_device_list(handle);
 }
 
 static const struct acpi_device_id i2c_acpi_force_400khz_device_ids[] = {
@@ -719,7 +729,6 @@ int i2c_acpi_install_space_handler(struct i2c_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	acpi_walk_dep_device_list(handle);
 	return 0;
 }
 
-- 
2.28.0

