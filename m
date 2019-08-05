Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81CE813CA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfHEIBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 04:01:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55002 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfHEIBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 04:01:40 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so73723513wme.4
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 01:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tLTq55G+8HM5id3F6PTEq7vm1jOe6eDLF+mAtsGbVn8=;
        b=jUah69i7szH9MKt+wlpPATO2iSXZ8TY9Lni/PdErU9oRBj16CWbb2Hcc8dFA+lsVnm
         0vPAzyA+Be5IGDrm4OpHBclDlR63C7kCBHTbJKTRIyczD/fCy6dFghz0Mpy+AWtyqCea
         NuC2WPuSpWdKr5kBVrhMjaiC2GdIquMK80fTt9RsyFClJKRnMVlW5Ip5u2v6ja+Zr8QA
         RO1yt4R83HSadVKjgugvYk2ekup3v4AQE8zhYrwZKtLIlFsopzm1BSUXhSek/Njz2Q25
         9JkydhRqiXn1bMRwtjwvDZF/f4dBRq7PkzstRsmDoQs9hxENbdJl8sfTq9tNs6kGF3JH
         AbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tLTq55G+8HM5id3F6PTEq7vm1jOe6eDLF+mAtsGbVn8=;
        b=FyL3yMb7dqJlAxP+TAqAjqfqC3ndUnNzkgig0kKIbjwveBC26nJtxaVDChm5g2QvQc
         BQj8DyiiP/6xI+a9d1TqYu654+sJb/hGCquQ2Z5ptbzPyFi8UImtm9oApiz2ItqlFPjU
         afpCbd/fsWyIxjanEHQFbEniHHJQM9+acOCcGgg2zi0LKLLHUkFXJ/PCr8IHVEIOHLHO
         Oc1C5P6jpCpGMnQPdcyqI9elGEsQ+c9QDVaSlraXWy/s7CJyPo2v1+MPSeuXiQyCFeD1
         073LVLrZ0Aqk9wkOUPvtM/pv98BKvooJX+0sImW5+jO8pvv1MUpjzVu8LZL45Oygbh/e
         H+Ew==
X-Gm-Message-State: APjAAAVpa8rgvec1g+T0mzu7snAz7KbksADpmSWm+aujXBwiBR5kBf7M
        TrtFfiY8PZPyp7OrUToOIaayyw==
X-Google-Smtp-Source: APXvYqw4mn9gu4bHlXL9JlRLmR/VRheqqFndxlo7p//U5SPq5PS12svDIp3Sp3aF3WqL0pRMF7kSaQ==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr17726531wme.177.1564992098303;
        Mon, 05 Aug 2019 01:01:38 -0700 (PDT)
Received: from localhost.localdomain (amontpellier-652-1-281-69.w109-210.abo.wanadoo.fr. [109.210.96.69])
        by smtp.gmail.com with ESMTPSA id o26sm177570979wro.53.2019.08.05.01.01.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 01:01:37 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH][v4.9.y, v4.14.y] eeprom: at24: make spd world-readable again
Date:   Mon,  5 Aug 2019 10:01:25 +0200
Message-Id: <20190805080125.20943-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

The integration of the at24 driver into the nvmem framework broke the
world-readability of spd EEPROMs. Fix it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org
Fixes: 57d155506dd5 ("eeprom: at24: extend driver to plug into the NVMEM framework")
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
[Bartosz: backported the patch to older branches]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/misc/eeprom/at24.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index a37b9b6a315a..2eef811764ad 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -777,7 +777,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	at24->nvmem_config.name = dev_name(&client->dev);
 	at24->nvmem_config.dev = &client->dev;
 	at24->nvmem_config.read_only = !writable;
-	at24->nvmem_config.root_only = true;
+	at24->nvmem_config.root_only = !(chip.flags & AT24_FLAG_IRUGO);
 	at24->nvmem_config.owner = THIS_MODULE;
 	at24->nvmem_config.compat = true;
 	at24->nvmem_config.base_dev = &client->dev;
-- 
2.21.0

