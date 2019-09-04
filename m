Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D352A8120
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 13:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfIDLdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 07:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfIDLdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 07:33:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBD8820820;
        Wed,  4 Sep 2019 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567596793;
        bh=ZMKU/xYdivUV0w6NTC4hBglX9vuHM3uDVElccE0W7RA=;
        h=Subject:To:From:Date:From;
        b=Tv1SOSBQkN37MYMP3ivLRUDT7DTxfpXGD6NE7/K159Ko0utls7+EcIk8DDMO4pU36
         PUWGQ+txCAYtp4fY3IKZ/kdsUzKs8o6zwpS0OLqjnCeplRyq6Im8++Eccf8GC9DkkM
         WWuf/3MnWqd70oI6TxSU/GYealvc4bFkMbCFeGT0=
Subject: patch "firmware: google: check if size is valid when decoding VPD data" added to char-misc-testing
To:     hungte@chromium.org, gregkh@linuxfoundation.org,
        linux@roeck-us.net, stable@vger.kernel.org, swboyd@chromium.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Sep 2019 13:32:55 +0200
Message-ID: <1567596775191247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware: google: check if size is valid when decoding VPD data

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4b708b7b1a2c09fbdfff6b942ebe3a160213aacd Mon Sep 17 00:00:00 2001
From: Hung-Te Lin <hungte@chromium.org>
Date: Fri, 30 Aug 2019 10:23:58 +0800
Subject: firmware: google: check if size is valid when decoding VPD data

The VPD implementation from Chromium Vital Product Data project used to
parse data from untrusted input without checking if the meta data is
invalid or corrupted. For example, the size from decoded content may
be negative value, or larger than whole input buffer. Such invalid data
may cause buffer overflow.

To fix that, the size parameters passed to vpd_decode functions should
be changed to unsigned integer (u32) type, and the parsing of entry
header should be refactored so every size field is correctly verified
before starting to decode.

Fixes: ad2ac9d5c5e0 ("firmware: Google VPD: import lib_vpd source files")
Signed-off-by: Hung-Te Lin <hungte@chromium.org>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20190830022402.214442-1-hungte@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/vpd.c        |  4 +-
 drivers/firmware/google/vpd_decode.c | 55 ++++++++++++++++------------
 drivers/firmware/google/vpd_decode.h |  6 +--
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/firmware/google/vpd.c b/drivers/firmware/google/vpd.c
index 0739f3b70347..db0812263d46 100644
--- a/drivers/firmware/google/vpd.c
+++ b/drivers/firmware/google/vpd.c
@@ -92,8 +92,8 @@ static int vpd_section_check_key_name(const u8 *key, s32 key_len)
 	return VPD_OK;
 }
 
-static int vpd_section_attrib_add(const u8 *key, s32 key_len,
-				  const u8 *value, s32 value_len,
+static int vpd_section_attrib_add(const u8 *key, u32 key_len,
+				  const u8 *value, u32 value_len,
 				  void *arg)
 {
 	int ret;
diff --git a/drivers/firmware/google/vpd_decode.c b/drivers/firmware/google/vpd_decode.c
index 92e3258552fc..dda525c0f968 100644
--- a/drivers/firmware/google/vpd_decode.c
+++ b/drivers/firmware/google/vpd_decode.c
@@ -9,8 +9,8 @@
 
 #include "vpd_decode.h"
 
-static int vpd_decode_len(const s32 max_len, const u8 *in,
-			  s32 *length, s32 *decoded_len)
+static int vpd_decode_len(const u32 max_len, const u8 *in,
+			  u32 *length, u32 *decoded_len)
 {
 	u8 more;
 	int i = 0;
@@ -30,18 +30,39 @@ static int vpd_decode_len(const s32 max_len, const u8 *in,
 	} while (more);
 
 	*decoded_len = i;
+	return VPD_OK;
+}
+
+static int vpd_decode_entry(const u32 max_len, const u8 *input_buf,
+			    u32 *_consumed, const u8 **entry, u32 *entry_len)
+{
+	u32 decoded_len;
+	u32 consumed = *_consumed;
+
+	if (vpd_decode_len(max_len - consumed, &input_buf[consumed],
+			   entry_len, &decoded_len) != VPD_OK)
+		return VPD_FAIL;
+	if (max_len - consumed < decoded_len)
+		return VPD_FAIL;
+
+	consumed += decoded_len;
+	*entry = input_buf + consumed;
+
+	/* entry_len is untrusted data and must be checked again. */
+	if (max_len - consumed < *entry_len)
+		return VPD_FAIL;
 
+	consumed += decoded_len;
+	*_consumed = consumed;
 	return VPD_OK;
 }
 
-int vpd_decode_string(const s32 max_len, const u8 *input_buf, s32 *consumed,
+int vpd_decode_string(const u32 max_len, const u8 *input_buf, u32 *consumed,
 		      vpd_decode_callback callback, void *callback_arg)
 {
 	int type;
-	int res;
-	s32 key_len;
-	s32 value_len;
-	s32 decoded_len;
+	u32 key_len;
+	u32 value_len;
 	const u8 *key;
 	const u8 *value;
 
@@ -56,26 +77,14 @@ int vpd_decode_string(const s32 max_len, const u8 *input_buf, s32 *consumed,
 	case VPD_TYPE_STRING:
 		(*consumed)++;
 
-		/* key */
-		res = vpd_decode_len(max_len - *consumed, &input_buf[*consumed],
-				     &key_len, &decoded_len);
-		if (res != VPD_OK || *consumed + decoded_len >= max_len)
+		if (vpd_decode_entry(max_len, input_buf, consumed, &key,
+				     &key_len) != VPD_OK)
 			return VPD_FAIL;
 
-		*consumed += decoded_len;
-		key = &input_buf[*consumed];
-		*consumed += key_len;
-
-		/* value */
-		res = vpd_decode_len(max_len - *consumed, &input_buf[*consumed],
-				     &value_len, &decoded_len);
-		if (res != VPD_OK || *consumed + decoded_len > max_len)
+		if (vpd_decode_entry(max_len, input_buf, consumed, &value,
+				     &value_len) != VPD_OK)
 			return VPD_FAIL;
 
-		*consumed += decoded_len;
-		value = &input_buf[*consumed];
-		*consumed += value_len;
-
 		if (type == VPD_TYPE_STRING)
 			return callback(key, key_len, value, value_len,
 					callback_arg);
diff --git a/drivers/firmware/google/vpd_decode.h b/drivers/firmware/google/vpd_decode.h
index cf8c2ace155a..8dbe41cac599 100644
--- a/drivers/firmware/google/vpd_decode.h
+++ b/drivers/firmware/google/vpd_decode.h
@@ -25,8 +25,8 @@ enum {
 };
 
 /* Callback for vpd_decode_string to invoke. */
-typedef int vpd_decode_callback(const u8 *key, s32 key_len,
-				const u8 *value, s32 value_len,
+typedef int vpd_decode_callback(const u8 *key, u32 key_len,
+				const u8 *value, u32 value_len,
 				void *arg);
 
 /*
@@ -44,7 +44,7 @@ typedef int vpd_decode_callback(const u8 *key, s32 key_len,
  * If one entry is successfully decoded, sends it to callback and returns the
  * result.
  */
-int vpd_decode_string(const s32 max_len, const u8 *input_buf, s32 *consumed,
+int vpd_decode_string(const u32 max_len, const u8 *input_buf, u32 *consumed,
 		      vpd_decode_callback callback, void *callback_arg);
 
 #endif  /* __VPD_DECODE_H */
-- 
2.23.0


