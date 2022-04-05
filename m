Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C75C4F2A99
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347789AbiDEJ2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244909AbiDEIwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075A7245B5;
        Tue,  5 Apr 2022 01:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9025C6117A;
        Tue,  5 Apr 2022 08:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97875C385A0;
        Tue,  5 Apr 2022 08:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148362;
        bh=KPm1yhX8itA60T9NSlrJoLLEguqqJLGw5Tnm4qUUNxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlF0VHVvuUmjnccvzTfALALwU38JxkqpWcH2D1VUbabIS3vQ6gXruWbETfD/RG9lB
         nfsNGBOel06HRuIn9OIjOFy7FZNazxjTsvZmmK9tne1e1lKBG+y2Pq/pAXZQv6vUjR
         JiKd/Z9W9qmG5C/Z2yYRuHFPIMElQ5LpBZBLe+80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0329/1017] vsprintf: Fix potential unaligned access
Date:   Tue,  5 Apr 2022 09:20:42 +0200
Message-Id: <20220405070404.047600293@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 58d5e567f836..01e61c85f274 100644
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



