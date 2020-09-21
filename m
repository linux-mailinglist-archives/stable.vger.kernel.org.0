Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE50F272858
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgIUOmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbgIUOlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDA5923718;
        Mon, 21 Sep 2020 14:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699272;
        bh=lvWXTjqEtX4tVeRkz5R6kR7ZQS2JVMCI3uTA9lD3JE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVw1jjbW7eC5Kjd5q7MNtCKuISK55net5bEOlpyOfZL5w0eJFgh0aaY9mqa6Plzj4
         jHpLhyS5AZ3YgQ3fW3edmDslsmx9DsFZFXLc2QLJm69Nxx2/73MxEhJ69tBgOD2Tam
         T6MeKAwtIvADkV1ZS1Exd/L5ycn9Bu3Omn1dZ4m4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/15] i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()
Date:   Mon, 21 Sep 2020 10:40:53 -0400
Message-Id: <20200921144054.2135602-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144054.2135602-1-sashal@kernel.org>
References: <20200921144054.2135602-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

