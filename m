Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590BA14880
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 12:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfEFKpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 06:45:11 -0400
Received: from relay.sw.ru ([185.231.240.75]:53854 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfEFKpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 06:45:11 -0400
Received: from [172.16.25.12] (helo=i7.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.91)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hNb7J-0002zI-Ox; Mon, 06 May 2019 13:45:05 +0300
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings
Date:   Mon,  6 May 2019 13:45:26 +0300
Message-Id: <20190506104527.10724-1-aryabinin@virtuozzo.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <CAHk-=winPBAQwSr9onDoa_ejnV6uWhFiAuQSwd1X-B16vknyXw@mail.gmail.com>
References: <CAHk-=winPBAQwSr9onDoa_ejnV6uWhFiAuQSwd1X-B16vknyXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building lib/ubsan.c with gcc-9 results in a ton of nasty warnings
like this one:
    lib/ubsan.c warning: conflicting types for built-in function
         ‘__ubsan_handle_negate_overflow’; expected ‘void(void *, void *)’ [-Wbuiltin-declaration-mismatch]

The kernel's declarations of __ubsan_handle_*() often uses 'unsigned long'
types in parameters while GCC these parameters as 'void *' types,
hence the mismatch.

Fix this by using 'void *' to match GCC's declarations.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Fixes: c6d308534aef ("UBSAN: run-time undefined behavior sanity checker")
Cc: <stable@vger.kernel.org>
---
 lib/ubsan.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/lib/ubsan.c b/lib/ubsan.c
index e4162f59a81c..1e9e2ab25539 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -86,11 +86,13 @@ static bool is_inline_int(struct type_descriptor *type)
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
@@ -99,15 +101,15 @@ static s_max get_signed_val(struct type_descriptor *type, unsigned long val)
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
@@ -116,7 +118,7 @@ static u_max get_unsigned_val(struct type_descriptor *type, unsigned long val)
 }
 
 static void val_to_string(char *str, size_t size, struct type_descriptor *type,
-	unsigned long value)
+			void *value)
 {
 	if (type_is_int(type)) {
 		if (type_bit_width(type) == 128) {
@@ -163,8 +165,8 @@ static void ubsan_epilogue(unsigned long *flags)
 	current->in_ubsan--;
 }
 
-static void handle_overflow(struct overflow_data *data, unsigned long lhs,
-			unsigned long rhs, char op)
+static void handle_overflow(struct overflow_data *data, void *lhs,
+			void *rhs, char op)
 {
 
 	struct type_descriptor *type = data->type;
@@ -191,8 +193,7 @@ static void handle_overflow(struct overflow_data *data, unsigned long lhs,
 }
 
 void __ubsan_handle_add_overflow(struct overflow_data *data,
-				unsigned long lhs,
-				unsigned long rhs)
+				void *lhs, void *rhs)
 {
 
 	handle_overflow(data, lhs, rhs, '+');
@@ -200,23 +201,21 @@ void __ubsan_handle_add_overflow(struct overflow_data *data,
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
@@ -237,8 +236,7 @@ EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
 
 
 void __ubsan_handle_divrem_overflow(struct overflow_data *data,
-				unsigned long lhs,
-				unsigned long rhs)
+				void *lhs, void *rhs)
 {
 	unsigned long flags;
 	char rhs_val_str[VALUE_LENGTH];
@@ -323,7 +321,7 @@ static void ubsan_type_mismatch_common(struct type_mismatch_data_common *data,
 }
 
 void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
-				unsigned long ptr)
+				void *ptr)
 {
 	struct type_mismatch_data_common common_data = {
 		.location = &data->location,
@@ -332,12 +330,12 @@ void __ubsan_handle_type_mismatch(struct type_mismatch_data *data,
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
@@ -347,12 +345,12 @@ void __ubsan_handle_type_mismatch_v1(struct type_mismatch_data_v1 *data,
 		.type_check_kind = data->type_check_kind
 	};
 
-	ubsan_type_mismatch_common(&common_data, ptr);
+	ubsan_type_mismatch_common(&common_data, (unsigned long)ptr);
 }
 EXPORT_SYMBOL(__ubsan_handle_type_mismatch_v1);
 
 void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
-					unsigned long bound)
+					void *bound)
 {
 	unsigned long flags;
 	char bound_str[VALUE_LENGTH];
@@ -369,8 +367,7 @@ void __ubsan_handle_vla_bound_not_positive(struct vla_bound_data *data,
 }
 EXPORT_SYMBOL(__ubsan_handle_vla_bound_not_positive);
 
-void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data,
-				unsigned long index)
+void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data, void *index)
 {
 	unsigned long flags;
 	char index_str[VALUE_LENGTH];
@@ -388,7 +385,7 @@ void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data,
 EXPORT_SYMBOL(__ubsan_handle_out_of_bounds);
 
 void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
-					unsigned long lhs, unsigned long rhs)
+					void *lhs, void *rhs)
 {
 	unsigned long flags;
 	struct type_descriptor *rhs_type = data->rhs_type;
@@ -439,7 +436,7 @@ void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 EXPORT_SYMBOL(__ubsan_handle_builtin_unreachable);
 
 void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
-				unsigned long val)
+				void *val)
 {
 	unsigned long flags;
 	char val_str[VALUE_LENGTH];
-- 
2.21.0

