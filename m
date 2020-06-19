Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EE2200D20
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389704AbgFSOxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389730AbgFSOx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E2902184D;
        Fri, 19 Jun 2020 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578408;
        bh=AfBtStXJXaYPmnT+dTRLZ/pe4//6x1OcubtVyz9z2Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzhrAP52BZT0dxWbaPREWEo1AFhE09erOEOHCwpPpocvh+OG9xKMkgxxnEz3tvzdC
         XO9iLSfbnfRO+PkWG7SGUQKcqXcpURDQVV3hZwiuap42qwXUguGnCNkGV+YsV5WAIP
         tpMPEIW3giLkcVGGZjKePktzbe9gJEAI2e+RBZ0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miles Chen <miles.chen@mediatek.com>
Subject: [PATCH 4.19 011/267] lib: Reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()
Date:   Fri, 19 Jun 2020 16:29:56 +0200
Message-Id: <20200619141649.402695278@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit ab10ae1c3bef56c29bac61e1201c752221b87b41 upstream.

The range passed to user_access_begin() by strncpy_from_user() and
strnlen_user() starts at 'src' and goes up to the limit of userspace
although reads will be limited by the 'count' param.

On 32 bits powerpc (book3s/32) access has to be granted for each
256Mbytes segment and the cost increases with the number of segments to
unlock.

Limit the range with 'count' param.

Fixes: 594cc251fdd0 ("make 'user_access_begin()' do 'access_ok()'")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/strncpy_from_user.c |   14 +++++++-------
 lib/strnlen_user.c      |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -29,13 +29,6 @@ static inline long do_strncpy_from_user(
 	const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
 	unsigned long res = 0;
 
-	/*
-	 * Truncate 'max' to the user-specified limit, so that
-	 * we only have one limit we need to check in the loop
-	 */
-	if (max > count)
-		max = count;
-
 	if (IS_UNALIGNED(src, dst))
 		goto byte_at_a_time;
 
@@ -113,6 +106,13 @@ long strncpy_from_user(char *dst, const
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
+		/*
+		 * Truncate 'max' to the user-specified limit, so that
+		 * we only have one limit we need to check in the loop
+		 */
+		if (max > count)
+			max = count;
+
 		kasan_check_write(dst, count);
 		check_object_size(dst, count, false);
 		if (user_access_begin(VERIFY_READ, src, max)) {
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -32,13 +32,6 @@ static inline long do_strnlen_user(const
 	unsigned long c;
 
 	/*
-	 * Truncate 'max' to the user-specified limit, so that
-	 * we only have one limit we need to check in the loop
-	 */
-	if (max > count)
-		max = count;
-
-	/*
 	 * Do everything aligned. But that means that we
 	 * need to also expand the maximum..
 	 */
@@ -114,6 +107,13 @@ long strnlen_user(const char __user *str
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
+		/*
+		 * Truncate 'max' to the user-specified limit, so that
+		 * we only have one limit we need to check in the loop
+		 */
+		if (max > count)
+			max = count;
+
 		if (user_access_begin(VERIFY_READ, str, max)) {
 			retval = do_strnlen_user(str, count, max);
 			user_access_end();


