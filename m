Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6266F657D22
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiL1Pjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiL1Pjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:39:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA54167C4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB6526154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4D8C433D2;
        Wed, 28 Dec 2022 15:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241985;
        bh=6mjoa0UUO+VjLIgUKRi7R2TLiowgOOeAG487pIy3nus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMPNPaTWIizXHMQHYvtzjFGZSIwoC7nW80BIvxO0jO0xvqBqv3nEtrbNMYXXwPEFk
         mYYzQxmwIzTLI6o1L0hktXhp62wmedxPY8WZv1LTa9EcghRpqstBDAlOCKWJ/lDto8
         Zpz/qZi7vVXdgJ91L7xULr/Q2Hy67a8ELldmqg/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Walle <michael@walle.cc>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0351/1073] mtd: spi-nor: hide jedec_id sysfs attribute if not present
Date:   Wed, 28 Dec 2022 15:32:19 +0100
Message-Id: <20221228144337.539595045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 7d388551b6888f3725e6c957f472526b35161a5b ]

Some non-jedec compliant flashes (like the Everspin flashes) don't have
an ID at all. Hide the attribute in this case.

Fixes: 36ac02286265 ("mtd: spi-nor: add initial sysfs support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Link: https://lore.kernel.org/r/20220810220654.1297699-2-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-bus-spi-devices-spi-nor      |  3 +++
 drivers/mtd/spi-nor/sysfs.c                        | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor b/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor
index d76cd3946434..e9ef69aef20b 100644
--- a/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor
+++ b/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor
@@ -5,6 +5,9 @@ Contact:	linux-mtd@lists.infradead.org
 Description:	(RO) The JEDEC ID of the SPI NOR flash as reported by the
 		flash device.
 
+		The attribute is not present if the flash doesn't support
+		the "Read JEDEC ID" command (9Fh). This is the case for
+		non-JEDEC compliant flashes.
 
 What:		/sys/bus/spi/devices/.../spi-nor/manufacturer
 Date:		April 2021
diff --git a/drivers/mtd/spi-nor/sysfs.c b/drivers/mtd/spi-nor/sysfs.c
index 9aec9d8a98ad..4c3b351aef24 100644
--- a/drivers/mtd/spi-nor/sysfs.c
+++ b/drivers/mtd/spi-nor/sysfs.c
@@ -67,6 +67,19 @@ static struct bin_attribute *spi_nor_sysfs_bin_entries[] = {
 	NULL
 };
 
+static umode_t spi_nor_sysfs_is_visible(struct kobject *kobj,
+					struct attribute *attr, int n)
+{
+	struct spi_device *spi = to_spi_device(kobj_to_dev(kobj));
+	struct spi_mem *spimem = spi_get_drvdata(spi);
+	struct spi_nor *nor = spi_mem_get_drvdata(spimem);
+
+	if (attr == &dev_attr_jedec_id.attr && !nor->info->id_len)
+		return 0;
+
+	return 0444;
+}
+
 static umode_t spi_nor_sysfs_is_bin_visible(struct kobject *kobj,
 					    struct bin_attribute *attr, int n)
 {
@@ -82,6 +95,7 @@ static umode_t spi_nor_sysfs_is_bin_visible(struct kobject *kobj,
 
 static const struct attribute_group spi_nor_sysfs_group = {
 	.name		= "spi-nor",
+	.is_visible	= spi_nor_sysfs_is_visible,
 	.is_bin_visible	= spi_nor_sysfs_is_bin_visible,
 	.attrs		= spi_nor_sysfs_entries,
 	.bin_attrs	= spi_nor_sysfs_bin_entries,
-- 
2.35.1



