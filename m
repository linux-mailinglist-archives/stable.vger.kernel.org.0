Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6D830BFFC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhBBNrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhBBNpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B952F64F7A;
        Tue,  2 Feb 2021 13:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273242;
        bh=Uiq+arb6QqwjnP5X/3KBHy1LG3r5dBCWyZ8aIf1Qxlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQ0AqKUJK9ppWuSkui8Mi5p+jFcY29N7xoIuPQ0ZltlcanjBdiSXganUMuHmcNVuK
         b4pKRsh3XfZZjAVN32caFJnjLGbiIxD6/Eivg10ECIBIc6KIToY9jmC8WxY8JxPZuB
         55xaWcjt6V1XPOaw47qHAawG1Ub1e94hdJCnyACU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 033/142] efi/apple-properties: Reinstate support for boolean properties
Date:   Tue,  2 Feb 2021 14:36:36 +0100
Message-Id: <20210202132959.073713338@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 355845b738e76445c8522802552146d96cb4afa7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/apple-properties.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

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
@@ -88,8 +89,12 @@ static void __init unmarshal_key_value_p
 
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


