Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB822593CA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgIAPbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgIAPbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB46A207D3;
        Tue,  1 Sep 2020 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974265;
        bh=cfgD2IK8xu8zcj5eIPs7iYsC+AdHZyjrZ8eBDn+eJPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkxKEYAyHjlG8JKr5KXzN6HXzjTHSTj3ds8NLsGcYXOnUl1YHwFWrorx3z91L2gla
         YK+9NwjXq2tntbA0oeRbMomVz4CCBBurowRCPTFrNriprAdQ/+Lx2RU2jFuU6mOyUd
         kWspHj7coMFAORecFI2zFT60uf3k8JH5qqQltWVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/214] i2c: core: Dont fail PRP0001 enumeration when no ID table exist
Date:   Tue,  1 Sep 2020 17:09:50 +0200
Message-Id: <20200901150958.256116243@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e3cb82c6d6f6c27ab754e13ae29bdd6b949982e2 ]

When commit c64ffff7a9d1 ("i2c: core: Allow empty id_table in ACPI case
as well") fixed the enumeration of I²C devices on ACPI enabled platforms
when driver has no ID table, it missed the PRP0001 support.

i2c_device_match() and i2c_acpi_match_device() differently match
driver against given device. Use acpi_driver_match_device(), that is used
in the former, in i2c_device_probe() and don't fail PRP0001 enumeration
when no ID table exist.

Fixes: c64ffff7a9d1 ("i2c: core: Allow empty id_table in ACPI case as well")
BugLink: https://stackoverflow.com/q/63519678/2511795
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
index cc193f2ba5d37..def62d5b42ca7 100644
--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -354,7 +354,7 @@ static int i2c_device_probe(struct device *dev)
 	 * or ACPI ID table is supplied for the probing device.
 	 */
 	if (!driver->id_table &&
-	    !i2c_acpi_match_device(dev->driver->acpi_match_table, client) &&
+	    !acpi_driver_match_device(dev, dev->driver) &&
 	    !i2c_of_match_device(dev->driver->of_match_table, client)) {
 		status = -ENODEV;
 		goto put_sync_adapter;
-- 
2.25.1



