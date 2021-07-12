Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F48D3C48CC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhGLGk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhGLGjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F33A7610F7;
        Mon, 12 Jul 2021 06:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071675;
        bh=Es+0d9EcP9Evsx2ZLxvbpYl3ZtfqtEGdQCCk0bywM4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnKS8f+uDRauelF/EgAizLnTG3l84vffcWhTHMO0ij3gEJW5urXLOq8pypKmNOoU4
         +e9bdvVu929z9Vb1C0PO/6McXfgcCF/G+09iCTGOnb16omcUx+FDtVAf1nmYtOjlIv
         lez+ujnZsfUv+I/egz1H0ib9KLmrdqWUXDovX8Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/593] lib: vsprintf: Fix handling of number field widths in vsscanf
Date:   Mon, 12 Jul 2021 08:05:32 +0200
Message-Id: <20210712060901.961957806@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 900fdc4573766dd43b847b4f54bd4a1ee2bc7360 ]

The existing code attempted to handle numbers by doing a strto[u]l(),
ignoring the field width, and then repeatedly dividing to extract the
field out of the full converted value. If the string contains a run of
valid digits longer than will fit in a long or long long, this would
overflow and no amount of dividing can recover the correct value.

This patch fixes vsscanf() to obey number field widths when parsing
the number.

A new _parse_integer_limit() is added that takes a limit for the number
of characters to parse. The number field conversion in vsscanf is changed
to use this new function.

If a number starts with a radix prefix, the field width  must be long
enough for at last one digit after the prefix. If not, it will be handled
like this:

 sscanf("0x4", "%1i", &i): i=0, scanning continues with the 'x'
 sscanf("0x4", "%2i", &i): i=0, scanning continues with the '4'

This is consistent with the observed behaviour of userland sscanf.

Note that this patch does NOT fix the problem of a single field value
overflowing the target type. So for example:

  sscanf("123456789abcdef", "%x", &i);

Will not produce the correct result because the value obviously overflows
INT_MAX. But sscanf will report a successful conversion.

Note that where a very large number is used to mean "unlimited", the value
INT_MAX is used for consistency with the behaviour of vsnprintf().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20210514161206.30821-2-rf@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kstrtox.c  | 13 ++++++--
 lib/kstrtox.h  |  2 ++
 lib/vsprintf.c | 82 +++++++++++++++++++++++++++++---------------------
 3 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index a14ccf905055..8504526541c1 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -39,20 +39,22 @@ const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
 
 /*
  * Convert non-negative integer string representation in explicitly given radix
- * to an integer.
+ * to an integer. A maximum of max_chars characters will be converted.
+ *
  * Return number of characters consumed maybe or-ed with overflow bit.
  * If overflow occurs, result integer (incorrect) is still returned.
  *
  * Don't you dare use this function.
  */
-unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *p)
+unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *p,
+				  size_t max_chars)
 {
 	unsigned long long res;
 	unsigned int rv;
 
 	res = 0;
 	rv = 0;
-	while (1) {
+	while (max_chars--) {
 		unsigned int c = *s;
 		unsigned int lc = c | 0x20; /* don't tolower() this line */
 		unsigned int val;
@@ -82,6 +84,11 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
 	return rv;
 }
 
+unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *p)
+{
+	return _parse_integer_limit(s, base, p, INT_MAX);
+}
+
 static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	unsigned long long _res;
diff --git a/lib/kstrtox.h b/lib/kstrtox.h
index 3b4637bcd254..158c400ca865 100644
--- a/lib/kstrtox.h
+++ b/lib/kstrtox.h
@@ -4,6 +4,8 @@
 
 #define KSTRTOX_OVERFLOW	(1U << 31)
 const char *_parse_integer_fixup_radix(const char *s, unsigned int *base);
+unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *res,
+				  size_t max_chars);
 unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *res);
 
 #endif
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fd0fde639ec9..8ade1a86d818 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -53,6 +53,31 @@
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
 
+static unsigned long long simple_strntoull(const char *startp, size_t max_chars,
+					   char **endp, unsigned int base)
+{
+	const char *cp;
+	unsigned long long result = 0ULL;
+	size_t prefix_chars;
+	unsigned int rv;
+
+	cp = _parse_integer_fixup_radix(startp, &base);
+	prefix_chars = cp - startp;
+	if (prefix_chars < max_chars) {
+		rv = _parse_integer_limit(cp, base, &result, max_chars - prefix_chars);
+		/* FIXME */
+		cp += (rv & ~KSTRTOX_OVERFLOW);
+	} else {
+		/* Field too short for prefix + digit, skip over without converting */
+		cp = startp + max_chars;
+	}
+
+	if (endp)
+		*endp = (char *)cp;
+
+	return result;
+}
+
 /**
  * simple_strtoull - convert a string to an unsigned long long
  * @cp: The start of the string
@@ -63,18 +88,7 @@
  */
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result;
-	unsigned int rv;
-
-	cp = _parse_integer_fixup_radix(cp, &base);
-	rv = _parse_integer(cp, base, &result);
-	/* FIXME */
-	cp += (rv & ~KSTRTOX_OVERFLOW);
-
-	if (endp)
-		*endp = (char *)cp;
-
-	return result;
+	return simple_strntoull(cp, INT_MAX, endp, base);
 }
 EXPORT_SYMBOL(simple_strtoull);
 
@@ -109,6 +123,21 @@ long simple_strtol(const char *cp, char **endp, unsigned int base)
 }
 EXPORT_SYMBOL(simple_strtol);
 
+static long long simple_strntoll(const char *cp, size_t max_chars, char **endp,
+				 unsigned int base)
+{
+	/*
+	 * simple_strntoull() safely handles receiving max_chars==0 in the
+	 * case cp[0] == '-' && max_chars == 1.
+	 * If max_chars == 0 we can drop through and pass it to simple_strntoull()
+	 * and the content of *cp is irrelevant.
+	 */
+	if (*cp == '-' && max_chars > 0)
+		return -simple_strntoull(cp + 1, max_chars - 1, endp, base);
+
+	return simple_strntoull(cp, max_chars, endp, base);
+}
+
 /**
  * simple_strtoll - convert a string to a signed long long
  * @cp: The start of the string
@@ -119,10 +148,7 @@ EXPORT_SYMBOL(simple_strtol);
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
-	if (*cp == '-')
-		return -simple_strtoull(cp + 1, endp, base);
-
-	return simple_strtoull(cp, endp, base);
+	return simple_strntoll(cp, INT_MAX, endp, base);
 }
 EXPORT_SYMBOL(simple_strtoll);
 
@@ -3442,25 +3468,13 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 			break;
 
 		if (is_sign)
-			val.s = qualifier != 'L' ?
-				simple_strtol(str, &next, base) :
-				simple_strtoll(str, &next, base);
+			val.s = simple_strntoll(str,
+						field_width >= 0 ? field_width : INT_MAX,
+						&next, base);
 		else
-			val.u = qualifier != 'L' ?
-				simple_strtoul(str, &next, base) :
-				simple_strtoull(str, &next, base);
-
-		if (field_width > 0 && next - str > field_width) {
-			if (base == 0)
-				_parse_integer_fixup_radix(str, &base);
-			while (next - str > field_width) {
-				if (is_sign)
-					val.s = div_s64(val.s, base);
-				else
-					val.u = div_u64(val.u, base);
-				--next;
-			}
-		}
+			val.u = simple_strntoull(str,
+						 field_width >= 0 ? field_width : INT_MAX,
+						 &next, base);
 
 		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
-- 
2.30.2



