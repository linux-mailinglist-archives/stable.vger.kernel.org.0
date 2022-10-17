Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA0600490
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 02:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJQAlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 20:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiJQAkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 20:40:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E20C3608A;
        Sun, 16 Oct 2022 17:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8F3760E8C;
        Mon, 17 Oct 2022 00:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB78C433D6;
        Mon, 17 Oct 2022 00:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665967239;
        bh=UOif+H4Ud2xLm8w0li5sSTXC56P6awBtoVABNqlVhYU=;
        h=Date:To:From:Subject:From;
        b=gWJC1+JzaKzIkIUDZ893wLZUqEZZmaxl9Wk+SLsnZyP5S7vnLrBXqWlSXsYGegZtE
         PZczLFt6qFBwHCti3XSCgtaPMDnwVBlxaiWIF2SfwDxteg4FPrve/3asqM8aSWElNy
         zdooFQwnXsPuQ1sjz3j5gE5GoprQUIJxM904eybA=
Date:   Sun, 16 Oct 2022 17:40:38 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        oberpar@linux.ibm.com, mliska@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-support-gcc-121-and-newer-compilers.patch added to mm-hotfixes-unstable branch
Message-Id: <20221017004039.4AB78C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: gcov: support GCC 12.1 and newer compilers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     gcov-support-gcc-121-and-newer-compilers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-support-gcc-121-and-newer-compilers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Martin Liska <mliska@suse.cz>
Subject: gcov: support GCC 12.1 and newer compilers
Date: Thu, 13 Oct 2022 09:40:59 +0200

Starting with GCC 12.1, there are 2 significant changes to the .gcda file
format that needs to be supported:

a) [gcov: Use system IO buffering] (23eb66d1d46a34cb28c4acbdf8a1deb80a7c5a05) changed
   that all sizes in the format are in bytes and not in words (4B)
b) [gcov: make profile merging smarter] (72e0c742bd01f8e7e6dcca64042b9ad7e75979de)
   add a new checksum to the file header.

Tested with GCC 7.5, 10.4, 12.2 and the current master.

Link: https://lkml.kernel.org/r/624bda92-f307-30e9-9aaa-8cc678b2dfb2@suse.cz
Signed-off-by: Martin Liska <mliska@suse.cz>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-support-gcc-121-and-newer-compilers
+++ a/kernel/gcov/gcc_4_7.c
@@ -30,6 +30,13 @@
 
 #define GCOV_TAG_FUNCTION_LENGTH	3
 
+/* Since GCC 12.1 sizes are in BYTES and not in WORDS (4B). */
+#if (__GNUC__ >= 12)
+#define GCOV_UNIT_SIZE				4
+#else
+#define GCOV_UNIT_SIZE				1
+#endif
+
 static struct gcov_info *gcov_info_head;
 
 /**
@@ -383,12 +390,18 @@ size_t convert_to_gcda(char *buffer, str
 	pos += store_gcov_u32(buffer, pos, info->version);
 	pos += store_gcov_u32(buffer, pos, info->stamp);
 
+#if (__GNUC__ >= 12)
+	/* Use zero as checksum of the compilation unit. */
+	pos += store_gcov_u32(buffer, pos, 0);
+#endif
+
 	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++) {
 		fi_ptr = info->functions[fi_idx];
 
 		/* Function record. */
 		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
-		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION_LENGTH);
+		pos += store_gcov_u32(buffer, pos,
+			GCOV_TAG_FUNCTION_LENGTH * GCOV_UNIT_SIZE);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->ident);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->lineno_checksum);
 		pos += store_gcov_u32(buffer, pos, fi_ptr->cfg_checksum);
@@ -402,7 +415,8 @@ size_t convert_to_gcda(char *buffer, str
 			/* Counter record. */
 			pos += store_gcov_u32(buffer, pos,
 					      GCOV_TAG_FOR_COUNTER(ct_idx));
-			pos += store_gcov_u32(buffer, pos, ci_ptr->num * 2);
+			pos += store_gcov_u32(buffer, pos,
+				ci_ptr->num * 2 * GCOV_UNIT_SIZE);
 
 			for (cv_idx = 0; cv_idx < ci_ptr->num; cv_idx++) {
 				pos += store_gcov_u64(buffer, pos,
_

Patches currently in -mm which might be from mliska@suse.cz are

gcov-support-gcc-121-and-newer-compilers.patch

