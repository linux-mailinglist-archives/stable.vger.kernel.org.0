Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5D44A121
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhKIBHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237289AbhKIBFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C62306120D;
        Tue,  9 Nov 2021 01:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419745;
        bh=3ZmUmow9n6IvvIm/pvg4FDRvOyhujVJdd/4RrrZ7Fdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+tgqfbCtZLndQV6jLxJHO721thtxBUAwLo/duak3hxtjaesMf86R9WR9OHnEO8Gg
         jaOVmv4XrIws/+jAO7i/DPxx0BFxhRm/oaDChHEYTnVj2szXKv713KIpEmSbGARDtw
         Z6xK9yGoP+FL+whNB9zp+lzJFKl4lvbQJx+fWaK4THaqN7foYENxXpn77yJTNnKp1N
         IEXKNXb9f6eHpAOAvswUEHtEonJQSgzFvm4brJLFkgDD0srocydZO+/JcyTtOLknmE
         Z4Dy+Co+Xv+m6QWYIHU1LvpBQEu1ccVMUaMkD7SE5fXcIT2xNA4SdsfgAGq7Ruz8BV
         pSeeudXXASBLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 024/138] spi: Check we have a spi_device_id for each DT compatible
Date:   Mon,  8 Nov 2021 12:44:50 -0500
Message-Id: <20211108174644.1187889-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 5fa6863ba69265cb7e45567d12614790ff26bd56 ]

Currently for SPI devices we use the spi_device_id for module autoloading
even on systems using device tree, meaning that listing a compatible string
in the of_match_table isn't enough to have the module for a SPI driver
autoloaded.

We attempted to fix this by generating OF based modaliases for devices
instantiated from DT in 3ce6c9e2617e ("spi: add of_device_uevent_modalias
support") but this meant we no longer reported spi_device_id based aliases
which broke drivers such as spi-nor which don't list all the compatible
strings they support directly for DT, and in at least that case it's not
super practical to do so given the very large number of compatibles
needed, much larger than the number spi_device_ids due to vendor strings.
As a result fell back to using spi_device_id based modalises.

Try to close the gap by printing a warning when a SPI driver has a DT
compatible that won't be matched as a SPI device ID with the goal of having
drivers provide both. Given fallback compatibles this check is going to be
excessive but it should be robust which is probably more important here.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210921192149.50740-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3093e0041158c..f6c8565d9300a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -453,6 +453,47 @@ int __spi_register_driver(struct module *owner, struct spi_driver *sdrv)
 {
 	sdrv->driver.owner = owner;
 	sdrv->driver.bus = &spi_bus_type;
+
+	/*
+	 * For Really Good Reasons we use spi: modaliases not of:
+	 * modaliases for DT so module autoloading won't work if we
+	 * don't have a spi_device_id as well as a compatible string.
+	 */
+	if (sdrv->driver.of_match_table) {
+		const struct of_device_id *of_id;
+
+		for (of_id = sdrv->driver.of_match_table; of_id->compatible[0];
+		     of_id++) {
+			const char *of_name;
+
+			/* Strip off any vendor prefix */
+			of_name = strnchr(of_id->compatible,
+					  sizeof(of_id->compatible), ',');
+			if (of_name)
+				of_name++;
+			else
+				of_name = of_id->compatible;
+
+			if (sdrv->id_table) {
+				const struct spi_device_id *spi_id;
+
+				for (spi_id = sdrv->id_table; spi_id->name[0];
+				     spi_id++)
+					if (strcmp(spi_id->name, of_name) == 0)
+						break;
+
+				if (spi_id->name[0])
+					continue;
+			} else {
+				if (strcmp(sdrv->driver.name, of_name) == 0)
+					continue;
+			}
+
+			pr_warn("SPI driver %s has no spi_device_id for %s\n",
+				sdrv->driver.name, of_id->compatible);
+		}
+	}
+
 	return driver_register(&sdrv->driver);
 }
 EXPORT_SYMBOL_GPL(__spi_register_driver);
-- 
2.33.0

