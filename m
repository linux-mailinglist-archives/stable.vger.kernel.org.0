Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8061119290
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfEISoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfEISoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:44:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B834B2183F;
        Thu,  9 May 2019 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427463;
        bh=Re62/yqlEsr+zNIDQyZCR7n6Dos0mGOODH9pJfVwyRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovqDSPCG0+H4PV4zNTuFbRQkDWFRiBzsClQ13LwrTSj4giyCv2dcVEyjs7Ln2vvie
         4wOyfwt5yJU7piUL5fdF/1N6XtZN26gcaoL0x77JKmt8wrdeDx2auEluMDLiW1QDwz
         Iv9FYSKGX66OsU5lGaAfzdI+Pode+tnfphnLe/00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH 4.9 02/28] ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings
Date:   Thu,  9 May 2019 20:41:54 +0200
Message-Id: <20190509181250.255618574@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
References: <20190509181247.647767531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit f0996bc2978e02d2ea898101462b960f6119b18f upstream.

Building lib/ubsan.c with gcc-9 results in a ton of nasty warnings like
this one:

    lib/ubsan.c warning: conflicting types for built-in function
         ‘__ubsan_handle_negate_overflow’; expected ‘void(void *, void *)’ [-Wbuiltin-declaration-mismatch]

The kernel's declarations of __ubsan_handle_*() often uses 'unsigned
long' types in parameters while GCC these parameters as 'void *' types,
hence the mismatch.

Fix this by using 'void *' to match GCC's declarations.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Fixes: c6d308534aef ("UBSAN: run-time undefined behavior sanity checker")
Cc: <stable@vger.kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/ubsan.c |   49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -86,11 +86,13 @@ static bool is_inline_int(struct type_de
 	return bits <= inline_bits;
 }
 
-static s_max get_signed_val(struct type_descriptor *type, unsigned long val)
+static s_max get_signed_val(struct type_descriptor *type, void *val)
 {
 	if (is_inline_int(type)) {
 		unsigned extra_bits = sizeof(s_max)*8 - type_bit_width(type);
-		return ((s_max)val) << extra_bits >> extra_bits;
+		unsigned long ulong_val = (unsigned long)val;
+
+		return ((s_max)ulong_val) << extra_bits >> extra_bits;
 	}
 
 	if (type_bit_width(type) == 64)
@@ -99,15 +101,15 @@ static s_max get_signed_val(struct type_
 	return *(s_max *)val;
 }
 
-static bool val_is_negative(struct type_descriptor *type, unsigned long val)
+static bool val_is_negative(struct type_descriptor *type, void *val)
 {
 	return type_is_signed(type) && get_signed_val(type, val) < 0;
 }
 
-static u_max get_unsigned_val(struct type_descriptor *type, unsigned long val)
+static u_max get_unsigned_val(struct type_descriptor *type, void *val)
 {
 	if (is_inline_int(type))
-		return val;
+		return (unsigned long)val;
 
 	if (type_bit_width(type) == 64)
 		return *(u64 *)val;
@@ -116,7 +118,7 @@ static u_max get_unsigned_val(struct typ
 }
 
 static void val_to_string(char *str, size_t size, struct type_descriptor *type,
-	unsigned long value)
+			void *value)
 {
 	if (type_is_int(type)) {
 		if (type_bit_width(type) == 128) {
@@ -168,8 +170,8 @@ static void ubsan_epilogue(unsigned long
 	current->in_ubsan--;
 }
 
-static void handle_overflow(struct overflow_data *data, unsigned long lhs,
-			unsigned long rhs, char op)
+static void handle_overflow(struct overflow_data *data, void *lhs,
+			void *rhs, char op)
 {
 
 	struct type_descriptor *type = data->type;
@@ -196,8 +198,7 @@ static void handle_overflow(struct overf
 }
 
 void __ubsan_handle_add_overflow(struct overflow_data *data,
-				unsigned long lhs,
-				unsigned long rhs)
+				void *lhs, void *rhs)
 {
 
 	handle_overflow(data, lhs, rhs, '+');
@@ -205,23 +206,21 @@ void __ubsan_handle_add_overflow(struct
 EXPORT_SYMBOL(__ubsan_handle_add_overflow);
 
 void __ubsan_handle_sub_overflow(struct overflow_data *data,
-				unsigned long lhs,
-				unsigned long rhs)
+				void *lhs, void *rhs)
 {
 	handle_overflow(data, lhs, rhs, '-');
 }
 EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
 
 void __ubsan_handle_mul_overflow(struct overflow_data *data,
-				unsigned long lhs,
-				unsigned long rhs)
+				void *lhs, void *rhs)
 {
 	handle_overflow(data, lhs, rhs, '*');
 }
 EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
 
 void __ubsan_handle_negate_overflow(struct overflow_data *data,
-				unsigned long old_val)
+				void *old_val)
 {
 	unsigned long flags;
 	char old_val_str[VALUE_LENGTH];
@@ -242,8 +241,7 @@ EXPORT_SYMBOL(__ubsan_handle_negate_over
 
 
 void __ubsan_handle_divrem_overflow(struct overflow_data *data,
-				unsigned long lhs,
-				unsigned long rhs)
+				void *lhs, void *rhs)
 {
 	unsigned long flags;
 	char rhs_val_str[VALUE_LENGTH];
@@ -328,7 +326,7 @@ static void ubsan_type_mismatch_common(s
 }
 
 void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
-				unsigned long ptr)
+				void *ptr)
 {
 	struct type_mismatch_data_common common_data = {
 		.location = &data->location,
@@ -337,12 +335,12 @@ void __ubsan_handle_type_mismatch(struct
 		.type_check_kind = data->type_check_kind
 	};
 
-	ubsan_type_mismatch_common(&common_data, ptr);
+	ubsan_type_mismatch_common(&common_data, (unsigned long)ptr);
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch);
 
 void __ubsan_handle_type_mismatch_v1(struct type_mismatch_data_v1 *data,
-				unsigned long ptr)
+				void *ptr)
 {
 
 	struct type_mismatch_data_common common_data = {
@@ -352,7 +350,7 @@ void __ubsan_handle_type_mismatch_v1(str
 		.type_check_kind = data->type_check_kind
 	};
 
-	ubsan_type_mismatch_common(&common_data, ptr);
+	ubsan_type_mismatch_common(&common_data, (unsigned long)ptr);
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
 
@@ -376,7 +374,7 @@ void __ubsan_handle_nonnull_return(struc
 EXPORT_SYMBOL(__ubsan_handle_nonnull_return);
 
 void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
-					unsigned long bound)
+					void *bound)
 {
 	unsigned long flags;
 	char bound_str[VALUE_LENGTH];
@@ -393,8 +391,7 @@ void __ubsan_handle_vla_bound_not_positi
 }
 EXPORT_SYMBOL(__ubsan_handle_vla_bound_not_positive);
 
-void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data,
-				unsigned long index)
+void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data, void *index)
 {
 	unsigned long flags;
 	char index_str[VALUE_LENGTH];
@@ -412,7 +409,7 @@ void __ubsan_handle_out_of_bounds(struct
 EXPORT_SYMBOL(__ubsan_handle_out_of_bounds);
 
 void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
-					unsigned long lhs, unsigned long rhs)
+					void *lhs, void *rhs)
 {
 	unsigned long flags;
 	struct type_descriptor *rhs_type = data->rhs_type;
@@ -463,7 +460,7 @@ void __ubsan_handle_builtin_unreachable(
 EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
 
 void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
-				unsigned long val)
+				void *val)
 {
 	unsigned long flags;
 	char val_str[VALUE_LENGTH];


