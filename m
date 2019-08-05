Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2A813F3
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 10:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfHEIIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 04:08:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46006 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfHEIIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 04:08:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so4482283wre.12
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 01:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgLjv1nCww8791VcRdUZize4N+pz9H+H0mFxYoQg1Bs=;
        b=fCibp5QhZzCJUJb6fpPrgbUGadeUS7m+LHz63o1X7WuWDv3vjictaNE+XNX8PGuzm3
         jM7kbRtvbyk0uLiS+AFw5GvV6FLuU0gP+KpEvBowcXqPZH4zZU6oZrIqL9CHNeYAAH/7
         jU8F2kGEeAGMbGkif9Bk5FZ94gG1j0XzSSdE2T7/Tdoa+xpJkRxTEYWVF02eqfgxGgbO
         htWbVKZumSlZKVO93aQAlvnRCETMORxtzirbDK6KdyLLtOfnoRqS3ZMf2KDVzeaw16CN
         2dI7DhR5r0ZaZOOHQHah4g2r8GpEyvVqC6i9FzYSBFhK2B1KJv2XkJPAUYE4DvcsunTP
         afAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vgLjv1nCww8791VcRdUZize4N+pz9H+H0mFxYoQg1Bs=;
        b=pLKRAwoE5gXGxTZT6elW67Hr4QWT2nO1EgqOnBSh4MT/37qUtVgMBazPOQMtzEOl7Y
         qodJExFTqK0PfYPVSpjRihb36WQTDnj4rinlY02d/dgfEkHef5VXtfp1fbxT3dslquhB
         KK8KmGJQhZZcphzI3kVcq6DOmxtu9UcFZ3UYIWIZiDzbco6FkKO0YrP/5GdzYJKxtM8k
         0cDzb07EdoVk/axOTFqedS/Swz5ZDtwCHq26WsX3IPZ31kKdmjFIser6et68gUkMtezx
         QWXPXKeKGBamcQWNBzKzmxmnAqqmZMXMXznytrenQA6XsJiewqILmhadHFFynRgSRlL9
         +PUw==
X-Gm-Message-State: APjAAAVsqtfGsvChWF/jWRg6N7jLwlXUEuRQIarPQg/QPkS5Dp8USR1F
        wgcMwMq75RNmK6P80IHDMWA=
X-Google-Smtp-Source: APXvYqxUQs2hbc6aZY7Cb1LTbwB3p6UHrIH5yJbtzj7wJhAIEjGCLhjS5+skKnteeEnuArgN5ppDgw==
X-Received: by 2002:adf:df8b:: with SMTP id z11mr103437181wrl.62.1564992515157;
        Mon, 05 Aug 2019 01:08:35 -0700 (PDT)
Received: from localhost.localdomain (amontpellier-652-1-281-69.w109-210.abo.wanadoo.fr. [109.210.96.69])
        by smtp.gmail.com with ESMTPSA id y12sm57598408wru.30.2019.08.05.01.08.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 01:08:34 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH][v4.19.y] eeprom: at24: make spd world-readable again
Date:   Mon,  5 Aug 2019 10:08:31 +0200
Message-Id: <20190805080831.23092-1-brgl@bgdev.pl>
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
[Bartosz: backported to v4.19.y]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/misc/eeprom/at24.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index ddfcf4ade7bf..dc3537651b80 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -724,7 +724,7 @@ static int at24_probe(struct i2c_client *client)
 	nvmem_config.name = dev_name(dev);
 	nvmem_config.dev = dev;
 	nvmem_config.read_only = !writable;
-	nvmem_config.root_only = true;
+	nvmem_config.root_only = !(pdata.flags & AT24_FLAG_IRUGO);
 	nvmem_config.owner = THIS_MODULE;
 	nvmem_config.compat = true;
 	nvmem_config.base_dev = dev;
-- 
2.21.0

