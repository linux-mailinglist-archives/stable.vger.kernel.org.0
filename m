Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64227C650
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgI2Lnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730564AbgI2Lns (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A413A206E5;
        Tue, 29 Sep 2020 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379828;
        bh=lvWXTjqEtX4tVeRkz5R6kR7ZQS2JVMCI3uTA9lD3JE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOLeaWgZrBCcHmHYqZxM5UBTKvIRkuoVsFDe64s339O278ElxXPktRlPcu8HvZDUZ
         70V+XiWPKNnjWJ2YbspeABpAgUSZDA0UE9n6qm2rG1hEzypXjwBA5AHy9fYdKR0ijz
         8hWjX4WbDld4poEcF5SJ0EVBSW//mfJPSMOwWmv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 335/388] i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()
Date:   Tue, 29 Sep 2020 13:01:06 +0200
Message-Id: <20200929110026.677383985@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 21653a4181ff292480599dad996a2b759ccf050f ]

Some ACPI i2c-devices _STA method (which is used to detect if the device
is present) use autodetection code which probes which device is present
over i2c. This requires the I2C ACPI OpRegion handler to be registered
before we enumerate i2c-clients under the i2c-adapter.

This fixes the i2c touchpad on the Lenovo ThinkBook 14-IIL and
ThinkBook 15 IIL not getting an i2c-client instantiated and thus not
working.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1842039
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index def62d5b42ca7..2dfe2ffcf8825 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -1385,8 +1385,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 
 	/* create pre-declared device nodes */
 	of_i2c_register_devices(adap);
-	i2c_acpi_register_devices(adap);
 	i2c_acpi_install_space_handler(adap);
+	i2c_acpi_register_devices(adap);
 
 	if (adap->nr < __i2c_first_dynamic_bus_num)
 		i2c_scan_static_board_info(adap);
-- 
2.25.1



