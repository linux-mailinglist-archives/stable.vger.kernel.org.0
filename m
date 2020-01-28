Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2D14B6A6
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgA1OEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbgA1OEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02FAA24685;
        Tue, 28 Jan 2020 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220239;
        bh=tKyRT6zwCMjcUPxdZNGLWuSNWGv/b1e6eBAIZMS8VkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JE56JGkhb/XVk75ZTHZNkAb4Bq95mo4Wc0/QxSOHx2XkqCsW4qB5+hoG/fYOQOvhA
         S98/MDb9da5lN4cmHt1kMzyA2elNC8Lp1RpFxSjXyFmWL6nolr75/G97fCdSIDgEK7
         hgPo7d3vaMPQl8WTU+C7m+KbZReP/sNhNCIelkzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 071/104] lib: Reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()
Date:   Tue, 28 Jan 2020 15:00:32 +0100
Message-Id: <20200128135827.156445118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/strncpy_from_user.c |   14 +++++++-------
 lib/strnlen_user.c      |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -30,13 +30,6 @@ static inline long do_strncpy_from_user(
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
 
@@ -114,6 +107,13 @@ long strncpy_from_user(char *dst, const
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
 		if (user_access_begin(src, max)) {
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -27,13 +27,6 @@ static inline long do_strnlen_user(const
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
@@ -109,6 +102,13 @@ long strnlen_user(const char __user *str
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
+		/*
+		 * Truncate 'max' to the user-specified limit, so that
+		 * we only have one limit we need to check in the loop
+		 */
+		if (max > count)
+			max = count;
+
 		if (user_access_begin(str, max)) {
 			retval = do_strnlen_user(str, count, max);
 			user_access_end();


