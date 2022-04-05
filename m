Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D074F3623
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244454AbiDEK7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347084AbiDEJp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7FADBC;
        Tue,  5 Apr 2022 02:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C04A616DB;
        Tue,  5 Apr 2022 09:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6DCC385A4;
        Tue,  5 Apr 2022 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151139;
        bh=t5hSDXWP6k/P9FBxBYltmkBE2Tk7nS9oj8fqA/DqdYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWpFRcWGbakR4RZwU/dn2KV7wP1xYlTJKPGt7hBXWI26VxB/QO4VG/e++IJL5QOe7
         IDIIskvN8rF5a7hE3z3IdasrUULO25N/fgPGbuXSAf1t9l99XzhxrXnquHY//gkRTB
         YAxrdnFXlhR/5xk9/q0594swmNaplcKEJ0EZ3O2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/913] vsprintf: Fix potential unaligned access
Date:   Tue,  5 Apr 2022 09:22:50 +0200
Message-Id: <20220405070349.087838793@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d75b26f880f60ead301e79ba0f4a635c5a60767f ]

The %p4cc specifier in some cases might get an unaligned pointer.
Due to this we need to make copy to local variable once to avoid
potential crashes on some architectures due to improper access.

Fixes: af612e43de6d ("lib/vsprintf: Add support for printing V4L2 and DRM fourccs")
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20220127181233.72910-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/vsprintf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d7ad44f2c8f5..ec07f6312445 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -49,6 +49,7 @@
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/byteorder.h>	/* cpu_to_le16 */
+#include <asm/unaligned.h>
 
 #include <linux/string_helpers.h>
 #include "kstrtox.h"
@@ -1771,7 +1772,7 @@ char *fourcc_string(char *buf, char *end, const u32 *fourcc,
 	char output[sizeof("0123 little-endian (0x01234567)")];
 	char *p = output;
 	unsigned int i;
-	u32 val;
+	u32 orig, val;
 
 	if (fmt[1] != 'c' || fmt[2] != 'c')
 		return error_string(buf, end, "(%p4?)", spec);
@@ -1779,21 +1780,22 @@ char *fourcc_string(char *buf, char *end, const u32 *fourcc,
 	if (check_pointer(&buf, end, fourcc, spec))
 		return buf;
 
-	val = *fourcc & ~BIT(31);
+	orig = get_unaligned(fourcc);
+	val = orig & ~BIT(31);
 
-	for (i = 0; i < sizeof(*fourcc); i++) {
+	for (i = 0; i < sizeof(u32); i++) {
 		unsigned char c = val >> (i * 8);
 
 		/* Print non-control ASCII characters as-is, dot otherwise */
 		*p++ = isascii(c) && isprint(c) ? c : '.';
 	}
 
-	strcpy(p, *fourcc & BIT(31) ? " big-endian" : " little-endian");
+	strcpy(p, orig & BIT(31) ? " big-endian" : " little-endian");
 	p += strlen(p);
 
 	*p++ = ' ';
 	*p++ = '(';
-	p = special_hex_number(p, output + sizeof(output) - 2, *fourcc, sizeof(u32));
+	p = special_hex_number(p, output + sizeof(output) - 2, orig, sizeof(u32));
 	*p++ = ')';
 	*p = '\0';
 
-- 
2.34.1



