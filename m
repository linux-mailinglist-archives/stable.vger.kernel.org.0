Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBE439FF7A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhFHSdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234440AbhFHScd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E8A61380;
        Tue,  8 Jun 2021 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177039;
        bh=RGpMOJ16txcZmIJsuu42MGUiZJmBuqBIh/pHaydqCmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyBB/yQ6Wp/VsVDMO0N9oL1DWapC9C74uMi3qSsMe5FFN8Ms/7fd/XXh6+j3zlVbO
         K0CW3hrVpEOxobtdGGIQ8gJKaToZJHGDpsPYdouMTx6pPqnyhywFZVOHYjAqyBF+Zf
         H+cT08XspUcKZEblT7bZm3zENv/LU3Lg8GO2rXB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/29] HID: i2c-hid: fix format string mismatch
Date:   Tue,  8 Jun 2021 20:27:03 +0200
Message-Id: <20210608175928.120985240@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit dc5f9f55502e13ba05731d5046a14620aa2ff456 ]

clang doesn't like printing a 32-bit integer using %hX format string:

drivers/hid/i2c-hid/i2c-hid-core.c:994:18: error: format specifies type 'unsigned short' but the argument has type '__u32' (aka 'unsigned int') [-Werror,-Wformat]
                 client->name, hid->vendor, hid->product);
                               ^~~~~~~~~~~
drivers/hid/i2c-hid/i2c-hid-core.c:994:31: error: format specifies type 'unsigned short' but the argument has type '__u32' (aka 'unsigned int') [-Werror,-Wformat]
                 client->name, hid->vendor, hid->product);
                                            ^~~~~~~~~~~~

Use an explicit cast to truncate it to the low 16 bits instead.

Fixes: 9ee3e06610fd ("HID: i2c-hid: override HID descriptors for certain devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 606fd875740c..800c477dd076 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1157,8 +1157,8 @@ static int i2c_hid_probe(struct i2c_client *client,
 	hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
 	hid->product = le16_to_cpu(ihid->hdesc.wProductID);
 
-	snprintf(hid->name, sizeof(hid->name), "%s %04hX:%04hX",
-		 client->name, hid->vendor, hid->product);
+	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X",
+		 client->name, (u16)hid->vendor, (u16)hid->product);
 	strlcpy(hid->phys, dev_name(&client->dev), sizeof(hid->phys));
 
 	ihid->quirks = i2c_hid_lookup_quirk(hid->vendor, hid->product);
-- 
2.30.2



