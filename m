Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16782450FB7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbhKOSgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:36:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242226AbhKOSe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:34:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19506325D;
        Mon, 15 Nov 2021 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999239;
        bh=3ZmUmow9n6IvvIm/pvg4FDRvOyhujVJdd/4RrrZ7Fdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MG+Ml8QCwr/6rGmgNjffbLUftCBvBRqTeQ9GoxP5xo8/Clw/ILk9ymK8OeB/DF/VG
         qy6BeNWQky3Wj7AKTC8tYKj1hLwEC8oBnSU9HJYNZacfJ5z2/e2XfgdfdI1DXZQYrS
         Lhwu6qa6Zu02oizE3gR3yF8Zm1cmNe2jUbyfDkgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 227/849] spi: Check we have a spi_device_id for each DT compatible
Date:   Mon, 15 Nov 2021 17:55:10 +0100
Message-Id: <20211115165427.891717285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



