Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5D881D3F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfHENT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbfHENT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 041A7216F4;
        Mon,  5 Aug 2019 13:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011168;
        bh=j0pWjmnA3CobvqjjJAyJKBfNQ9eDlv+rmkaQtp2r6gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsJeaXNIhe5EFpm2T9tUHqGvFyE6NGIQuRUVjOYmHjXAhCLvjFQfwX5V3tY4Bokpq
         fN7S56Im4uiE1C8W44cLGgDkW1lgu2+DwFCh1i2zM0KF3Hi+L7J0/gmxxr+YYD/oJ0
         w36+530255gzgTLiVEWjCBVY20IWduVKng7UReV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.19 69/74] eeprom: at24: make spd world-readable again
Date:   Mon,  5 Aug 2019 15:03:22 +0200
Message-Id: <20190805124941.387184724@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

commit 25e5ef302c24a6fead369c0cfe88c073d7b97ca8 upstream.

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
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
[Bartosz: backported to v4.19.y]
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/eeprom/at24.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -724,7 +724,7 @@ static int at24_probe(struct i2c_client
 	nvmem_config.name = dev_name(dev);
 	nvmem_config.dev = dev;
 	nvmem_config.read_only = !writable;
-	nvmem_config.root_only = true;
+	nvmem_config.root_only = !(pdata.flags & AT24_FLAG_IRUGO);
 	nvmem_config.owner = THIS_MODULE;
 	nvmem_config.compat = true;
 	nvmem_config.base_dev = dev;


