Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65E43D613E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhGZPaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhGZP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA2260FDA;
        Mon, 26 Jul 2021 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315630;
        bh=t1qrw3qqvDhAbr7/DTs8zeVeYBvUPo8sBxMfTjxJw+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lewoqgrdagzvBYWboaez52XM4fFW8Plp2t/LVoKBVX978QXroRmyxV0r2lZqG0OV2
         Sa7tmkXmOwjMYeFJkDfkq9xao9fiCLqxt9Qqi8o8SXuPnP0GOj5JbnriQXFiT5hP9c
         dKvU+K7nwOz3HKFFtaaWitlR1oWyhAK3a5CEhsSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Fomichev <fomichev.ru@gmail.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 151/167] misc: eeprom: at24: Always append device id even if label property is set.
Date:   Mon, 26 Jul 2021 17:39:44 +0200
Message-Id: <20210726153844.486686562@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

commit c36748ac545421d94a5091c754414c0f3664bf10 upstream.

We need to append device id even if eeprom have a label property set as some
platform can have multiple eeproms with same label and we can not register
each of those with same label. Failing to register those eeproms trigger
cascade failures on such platform (system is no longer working).

This fix regression on such platform introduced with 4e302c3b568e

Reported-by: Alexander Fomichev <fomichev.ru@gmail.com>
Fixes: 4e302c3b568e ("misc: eeprom: at24: fix NVMEM name with custom AT24 device name")
Cc: stable@vger.kernel.org
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/at24.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -714,23 +714,20 @@ static int at24_probe(struct i2c_client
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
 


