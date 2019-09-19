Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4105EB8494
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405926AbfISWMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405924AbfISWMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:12:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E435218AF;
        Thu, 19 Sep 2019 22:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931129;
        bh=yoIrDO0cf+GaDOLoHFCRsXHjgRGCbBc+beEhYdSyiCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0+ZU9cmXIAsbaFg4VyZ8vhSBfE3TVjix0cyby8EfDB5Ava5q1Lx4Z9yEJmpPcnjO
         lvDEaK6c3L9F6ImkykyMzNMxZsx19gXi1GX0J4TnsKlT5UVQYiqvBWEvMsZrBvKIX6
         ZLgSCAiAkYcJABA9egst+4QF9w8nSe7noHYM8adg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hung-Te Lin <hungte@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 4.19 14/79] firmware: google: check if size is valid when decoding VPD data
Date:   Fri, 20 Sep 2019 00:02:59 +0200
Message-Id: <20190919214809.079749683@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hung-Te Lin <hungte@chromium.org>

commit 4b708b7b1a2c09fbdfff6b942ebe3a160213aacd upstream.

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
 drivers/firmware/google/vpd.c        |    4 +-
 drivers/firmware/google/vpd_decode.c |   55 ++++++++++++++++++++---------------
 drivers/firmware/google/vpd_decode.h |    6 +--
 3 files changed, 37 insertions(+), 28 deletions(-)

--- a/drivers/firmware/google/vpd.c
+++ b/drivers/firmware/google/vpd.c
@@ -100,8 +100,8 @@ static int vpd_section_check_key_name(co
 	return VPD_OK;
 }
 
-static int vpd_section_attrib_add(const u8 *key, s32 key_len,
-				  const u8 *value, s32 value_len,
+static int vpd_section_attrib_add(const u8 *key, u32 key_len,
+				  const u8 *value, u32 value_len,
 				  void *arg)
 {
 	int ret;
--- a/drivers/firmware/google/vpd_decode.c
+++ b/drivers/firmware/google/vpd_decode.c
@@ -19,8 +19,8 @@
 
 #include "vpd_decode.h"
 
-static int vpd_decode_len(const s32 max_len, const u8 *in,
-			  s32 *length, s32 *decoded_len)
+static int vpd_decode_len(const u32 max_len, const u8 *in,
+			  u32 *length, u32 *decoded_len)
 {
 	u8 more;
 	int i = 0;
@@ -40,18 +40,39 @@ static int vpd_decode_len(const s32 max_
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
+
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
 
@@ -66,26 +87,14 @@ int vpd_decode_string(const s32 max_len,
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
--- a/drivers/firmware/google/vpd_decode.h
+++ b/drivers/firmware/google/vpd_decode.h
@@ -33,8 +33,8 @@ enum {
 };
 
 /* Callback for vpd_decode_string to invoke. */
-typedef int vpd_decode_callback(const u8 *key, s32 key_len,
-				const u8 *value, s32 value_len,
+typedef int vpd_decode_callback(const u8 *key, u32 key_len,
+				const u8 *value, u32 value_len,
 				void *arg);
 
 /*
@@ -52,7 +52,7 @@ typedef int vpd_decode_callback(const u8
  * If one entry is successfully decoded, sends it to callback and returns the
  * result.
  */
-int vpd_decode_string(const s32 max_len, const u8 *input_buf, s32 *consumed,
+int vpd_decode_string(const u32 max_len, const u8 *input_buf, u32 *consumed,
 		      vpd_decode_callback callback, void *callback_arg);
 
 #endif  /* __VPD_DECODE_H */


