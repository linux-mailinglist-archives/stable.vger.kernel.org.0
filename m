Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE9015DD94
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388951AbgBNP7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388947AbgBNP7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B5D222C4;
        Fri, 14 Feb 2020 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695974;
        bh=H3BVbcXuReFlU6I0tNUk4CBvia1+b5+4dg/4OFjB0UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv2y+kdkaYdZORo93IUDPbFIQLe7hX8LWIYGiUDV26/41pmGeuCA2snnY7eR09gEQ
         DG66+AQiz0T6f5+DwCmnhOVtArsN7KzyV98n6bIAG6LzfB8JYWEVvIYnIHknV13Dx5
         uS+KYYsxEvEXDzxin/0d6GcfsZuV21AZTs4hCEVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akshu Agrawal <akshu.agrawal@amd.com>,
        Raul E Rangel <rrangel@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 500/542] i2c: cros-ec-tunnel: Fix slave device enumeration
Date:   Fri, 14 Feb 2020 10:48:12 -0500
Message-Id: <20200214154854.6746-500-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akshu Agrawal <akshu.agrawal@amd.com>

[ Upstream commit 8ff2d7ca4a55dfabf12e876369835bd024eb4621 ]

During adding of the adapter the slave device registration
use to fail as the acpi companion field was not populated.

Fixes: 9af1563a5486 ("i2c: cros-ec-tunnel: Make the device acpi compatible")
Signed-off-by: Akshu Agrawal <akshu.agrawal@amd.com>
Acked-by: Raul E Rangel <rrangel@chromium.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cros-ec-tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
index 958161c71985d..8a2db3ac3b3c7 100644
--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -273,6 +273,7 @@ static int ec_i2c_probe(struct platform_device *pdev)
 	bus->adap.dev.parent = &pdev->dev;
 	bus->adap.dev.of_node = pdev->dev.of_node;
 	bus->adap.retries = I2C_MAX_RETRIES;
+	ACPI_COMPANION_SET(&bus->adap.dev, ACPI_COMPANION(&pdev->dev));
 
 	err = i2c_add_adapter(&bus->adap);
 	if (err)
-- 
2.20.1

