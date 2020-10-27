Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899CF29B575
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794503AbgJ0PMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794499AbgJ0PMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:12:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C403822202;
        Tue, 27 Oct 2020 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811528;
        bh=TKwG8qN6udJoWiQIYQGkalBBVs0PelwEN8M2Z18AFTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyhIUANLjahlMPIWUDqASDRv8lwfpQeUF1d960LV182pRx/uIsf3JVu99lWgP6dg9
         Pp2r1r+FriKoKRa9//WUt+49tMlG9MTZPF4vDDBn3JGDOcaHF7vEmQgY+YymgqIAzz
         9MIrgabGojBnMnLsqOYaUbdwMwJsn8N5lLYM2dFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rainer Finke <rainer@finke.cc>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 526/633] i2c: core: Restore acpi_walk_dep_device_list() getting called after registering the ACPI i2c devs
Date:   Tue, 27 Oct 2020 14:54:29 +0100
Message-Id: <20201027135547.453070770@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8058d69905058ec8f467a120b5ec5bb831ea67f3 ]

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
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209627
Reported-by: Rainer Finke <rainer@finke.cc>
Reported-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Suggested-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 2ade99b105b91..bbf8dd491d245 100644
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
 
 const struct acpi_device_id *
@@ -729,7 +739,6 @@ int i2c_acpi_install_space_handler(struct i2c_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	acpi_walk_dep_device_list(handle);
 	return 0;
 }
 
-- 
2.25.1



