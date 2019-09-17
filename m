Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB61B505D
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 16:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfIQO3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 10:29:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:56078 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727898AbfIQO3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 10:29:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0EAABB035;
        Tue, 17 Sep 2019 14:29:51 +0000 (UTC)
Date:   Tue, 17 Sep 2019 16:30:01 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [BACKPORT] nvmem: Use the same permissions for eeprom as for nvmem
Message-ID: <20190917163001.5c775b61@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e70d8b287301eb6d7c7761c6171c56af62110ea3 ]

The compatibility "eeprom" attribute is currently root-only no
matter what the configuration says. The "nvmem" attribute does
respect the setting of the root_only configuration bit, so do the
same for "eeprom".

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: b6c217ab9be6 ("nvmem: Add backwards compatibility support for older EEPROM drivers.")
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20190728184255.563332e6@endymion
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
This is the backport of commit e70d8b287301 "nvmem: Use the same
permissions for eeprom as for nvmem" for stable kernel branches 4.19,
4.14 and 4.9. Thanks.

 drivers/nvmem/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- linux-4.19.orig/drivers/nvmem/core.c	2019-09-17 11:34:16.250719885 +0200
+++ linux-4.19/drivers/nvmem/core.c	2019-09-17 16:09:45.146604199 +0200
@@ -415,10 +415,17 @@ static int nvmem_setup_compat(struct nvm
 	if (!config->base_dev)
 		return -EINVAL;
 
-	if (nvmem->read_only)
-		nvmem->eeprom = bin_attr_ro_root_nvmem;
-	else
-		nvmem->eeprom = bin_attr_rw_root_nvmem;
+	if (nvmem->read_only) {
+		if (config->root_only)
+			nvmem->eeprom = bin_attr_ro_root_nvmem;
+		else
+			nvmem->eeprom = bin_attr_ro_nvmem;
+	} else {
+		if (config->root_only)
+			nvmem->eeprom = bin_attr_rw_root_nvmem;
+		else
+			nvmem->eeprom = bin_attr_rw_nvmem;
+	}
 	nvmem->eeprom.attr.name = "eeprom";
 	nvmem->eeprom.size = nvmem->size;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC


-- 
Jean Delvare
SUSE L3 Support
