Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBE73B93EE
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 17:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhGAPbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 11:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54043 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232969AbhGAPbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 11:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625153322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DmXj8caY15pwsQgjtiEZnmZUg1bkwyeXw/rOXNl13yM=;
        b=hdAaYu1ItddJGhG8tyWL0+KyGJlU/RA5IxOXyAc2NGmxLWhznoAha6Yi4LJcy9mZek6B1W
        F74XEVMMlUJBaUs26aOG6mOlz77iQfDU7AuS8f3Kb+LrzJLN/DbI37SM3/tJw+mmQ1etYh
        /uybaaUMifn6dmCsxP521o+xvBAtbnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-2j6XOe-zPpK98edlVNmnrw-1; Thu, 01 Jul 2021 11:28:38 -0400
X-MC-Unique: 2j6XOe-zPpK98edlVNmnrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C42B19611AE;
        Thu,  1 Jul 2021 15:28:36 +0000 (UTC)
Received: from fedora.hsd1.ca.comcast.net (ovpn-116-250.rdu2.redhat.com [10.10.116.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 233C85C22B;
        Thu,  1 Jul 2021 15:28:31 +0000 (UTC)
From:   jglisse@redhat.com
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Diego Santa Cruz <Diego.SantaCruz@spinetix.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: [PATCH] misc: eeprom: at24: Always append device id even if label property is set.
Date:   Thu,  1 Jul 2021 08:28:25 -0700
Message-Id: <20210701152825.265729-1-jglisse@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

We need to append device id even if eeprom have a label property set as some
platform can have multiple eeproms with same label and we can not register
each of those with same label. Failing to register those eeproms trigger
cascade failures on such platform (system is no longer working).

This fix regression on such platform introduced with 4e302c3b568e

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Diego Santa Cruz <Diego.SantaCruz@spinetix.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org
Cc: linux-i2c@vger.kernel.org
---
 drivers/misc/eeprom/at24.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 7a6f01ace78a..305ffad131a2 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -714,23 +714,20 @@ static int at24_probe(struct i2c_client *client)
 	}
 
 	/*
-	 * If the 'label' property is not present for the AT24 EEPROM,
-	 * then nvmem_config.id is initialised to NVMEM_DEVID_AUTO,
-	 * and this will append the 'devid' to the name of the NVMEM
-	 * device. This is purely legacy and the AT24 driver has always
-	 * defaulted to this. However, if the 'label' property is
-	 * present then this means that the name is specified by the
-	 * firmware and this name should be used verbatim and so it is
-	 * not necessary to append the 'devid'.
+	 * We initialize nvmem_config.id to NVMEM_DEVID_AUTO even if the
+	 * label property is set as some platform can have multiple eeproms
+	 * with same label and we can not register each of those with same
+	 * label. Failing to register those eeproms trigger cascade failure
+	 * on such platform.
 	 */
+	nvmem_config.id = NVMEM_DEVID_AUTO;
+
 	if (device_property_present(dev, "label")) {
-		nvmem_config.id = NVMEM_DEVID_NONE;
 		err = device_property_read_string(dev, "label",
 						  &nvmem_config.name);
 		if (err)
 			return err;
 	} else {
-		nvmem_config.id = NVMEM_DEVID_AUTO;
 		nvmem_config.name = dev_name(dev);
 	}
 
-- 
2.31.1

