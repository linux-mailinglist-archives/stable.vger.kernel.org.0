Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CBA306415
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 20:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhA0TcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 14:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhA0Tb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 14:31:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0F6C0613ED;
        Wed, 27 Jan 2021 11:31:16 -0800 (PST)
Date:   Wed, 27 Jan 2021 19:31:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611775872;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9KJpESEezEw7FjK+8Es36GYVxqjET2QbkM5fuH5NNI=;
        b=B/Q/ntJfB8QT/TcvewwOVIfuK/vi24dXZe/p7wS7f9XHeo5UTHExWxYKb3xg3nwrdeRc4y
        D0QaNLlWHP2jYO+Ypdq0cpElIbGqnJgwRqGRcSM7PYs2uBQjQm0bqj41nRvCUlEwvoGfR4
        ZL9fJJ1PFsR66XSIZmX1L12sy2xj1E0fOPKzrwuceAkF/c3d4vkm4V2QBuu9+IcQvOz+B9
        qGw323nOphOEjSiY26xUvkrCaaq1wzvx3CbC3TyKbvpEMhnJAgUK/Ac86H7KBO2Fz7NZ43
        SpjWv5fnUplVOkx+NyEm/j+9NPvyVTyzdzzKDxdF7Rou9B6dJZaVQzj33VIGpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611775872;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9KJpESEezEw7FjK+8Es36GYVxqjET2QbkM5fuH5NNI=;
        b=NEAbkJu30Mfk1ccQH/2iDUDiLqcXtahPDP/GXHpiigRZTawJSOCwIEpcuOkYZ6FI3LKIJI
        lv4sUUYF2r9BreCQ==
From:   "tip-bot2 for Lukas Wunner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi/apple-properties: Reinstate support for boolean
 properties
Cc:     <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <be958bda75331a011d53c696d1deec8dccd06fd2.1609388549.git.lukas@wunner.de>
References: <be958bda75331a011d53c696d1deec8dccd06fd2.1609388549.git.lukas@wunner.de>
MIME-Version: 1.0
Message-ID: <161177587165.23325.6382610532034532665.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     355845b738e76445c8522802552146d96cb4afa7
Gitweb:        https://git.kernel.org/tip/355845b738e76445c8522802552146d96cb4afa7
Author:        Lukas Wunner <lukas@wunner.de>
AuthorDate:    Thu, 31 Dec 2020 06:10:32 +01:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Thu, 31 Dec 2020 10:28:53 +01:00

efi/apple-properties: Reinstate support for boolean properties

Since commit 4466bf82821b ("efi/apple-properties: use
PROPERTY_ENTRY_U8_ARRAY_LEN"), my MacBook Pro issues a -ENODATA error
when trying to assign EFI properties to the discrete GPU:

pci 0000:01:00.0: assigning 56 device properties
pci 0000:01:00.0: error -61 assigning properties

That's because some of the properties have no value.  They're booleans
whose presence can be checked by drivers, e.g. "use-backlight-blanking".

Commit 6e98503dba64 ("efi/apple-properties: Remove redundant attribute
initialization from unmarshal_key_value_pairs()") employed a trick to
store such booleans as u8 arrays (which is the data type used for all
other EFI properties on Macs):  It cleared the property_entry's
"is_array" flag, thereby denoting that the value is stored inline in the
property_entry.

Commit 4466bf82821b erroneously removed that trick.  It was probably a
little fragile to begin with.

Reinstate support for boolean properties by explicitly invoking the
PROPERTY_ENTRY_BOOL() initializer for properties with zero-length value.

Fixes: 4466bf82821b ("efi/apple-properties: use PROPERTY_ENTRY_U8_ARRAY_LEN")
Cc: <stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/be958bda75331a011d53c696d1deec8dccd06fd2.1609388549.git.lukas@wunner.de
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/firmware/efi/apple-properties.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 34f53d8..e192648 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -3,8 +3,9 @@
  * apple-properties.c - EFI device properties on Macs
  * Copyright (C) 2016 Lukas Wunner <lukas@wunner.de>
  *
- * Note, all properties are considered as u8 arrays.
- * To get a value of any of them the caller must use device_property_read_u8_array().
+ * Properties are stored either as:
+ * u8 arrays which can be retrieved with device_property_read_u8_array() or
+ * booleans which can be queried with device_property_present().
  */
 
 #define pr_fmt(fmt) "apple-properties: " fmt
@@ -88,8 +89,12 @@ static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
 
 		entry_data = ptr + key_len + sizeof(val_len);
 		entry_len = val_len - sizeof(val_len);
-		entry[i] = PROPERTY_ENTRY_U8_ARRAY_LEN(key, entry_data,
-						       entry_len);
+		if (entry_len)
+			entry[i] = PROPERTY_ENTRY_U8_ARRAY_LEN(key, entry_data,
+							       entry_len);
+		else
+			entry[i] = PROPERTY_ENTRY_BOOL(key);
+
 		if (dump_properties) {
 			dev_info(dev, "property: %s\n", key);
 			print_hex_dump(KERN_INFO, pr_fmt(), DUMP_PREFIX_OFFSET,
