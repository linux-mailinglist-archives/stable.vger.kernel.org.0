Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8795E8DB30
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfHNRHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbfHNRHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8108D214DA;
        Wed, 14 Aug 2019 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802432;
        bh=n7th62+p9HsiNvdVUJr1MZnEwS84TWzyJY78o6f1Fxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXsWWpgv0zYext8m8LoCTpdPC/lmZDe7O7Oppr3wtJaVSQqVvO+z5u4u4GmY4n5gA
         zvEbnLl62rM7H01v5WsW7I5VN2O4PafP/WKAFz6uVnctLHGY1Px8CPBM3or+zVZij0
         LKj6080el+q/zmbS45yJwwlKEncR2pskahsrQsEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Iker Perez del Palomar Sustatxa 
        <iker.perez@codethink.co.uk>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.2 124/144] hwmon: (lm75) Fixup tmp75b clr_mask
Date:   Wed, 14 Aug 2019 19:01:20 +0200
Message-Id: <20190814165805.116317258@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iker Perez del Palomar Sustatxa <iker.perez@codethink.co.uk>

commit a95a4f3f2702b55a89393bf0f1b2b3d79e0f7da2 upstream.

The configuration register of the tmp75b sensor is 16bit long, however
the first byte is reserved, so there is not no need to take care of it.

Because the order of the bytes is little endian and it is only necessary
to write one byte, the desired bits must be shifted into a 8 bit range.

Fixes: 39abe9d88b30 ("hwmon: (lm75) Add support for TMP75B")
Cc: stable@vger.kernel.org
Signed-off-by: Iker Perez del Palomar Sustatxa <iker.perez@codethink.co.uk>
Link: https://lore.kernel.org/r/20190801075324.4638-1-iker.perez@codethink.co.uk
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/lm75.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -343,7 +343,7 @@ lm75_probe(struct i2c_client *client, co
 		data->sample_time = MSEC_PER_SEC / 2;
 		break;
 	case tmp75b:  /* not one-shot mode, Conversion rate 37Hz */
-		clr_mask |= 1 << 15 | 0x3 << 13;
+		clr_mask |= 1 << 7 | 0x3 << 5;
 		data->resolution = 12;
 		data->sample_time = MSEC_PER_SEC / 37;
 		break;


