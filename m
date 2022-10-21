Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F053606EF1
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 06:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJUEfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 00:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJUEev (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 00:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563531BEBB;
        Thu, 20 Oct 2022 21:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E98ED61DAD;
        Fri, 21 Oct 2022 04:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FF0C433D6;
        Fri, 21 Oct 2022 04:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326884;
        bh=aW3sNXiSi40YEyx0v+ssh8Vx4VEcAAx6uZDbal192jM=;
        h=Date:To:From:Subject:From;
        b=sAe0SjsUvDIfzVsRtg0aYHq2Ww01R01Hhccr7rCERXRwOxJjoa/sgDVUVLWfla/cJ
         6q9vu1JlSpnniQdTdu/37MMMIOhtu72NIX+jXoUheGjTRkGVUyI3MUX/m9Uet3oyih
         ziFmcLxrPvZe9NFyG3zlK6fsJcJv4u6rivaJVxH8=
Date:   Thu, 20 Oct 2022 21:34:43 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        oberpar@linux.ibm.com, mliska@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] gcov-support-gcc-121-and-newer-compilers.patch removed from -mm tree
Message-Id: <20221021043444.46FF0C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: gcov: support GCC 12.1 and newer compilers
has been removed from the -mm tree.  Its filename was
     gcov-support-gcc-121-and-newer-compilers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Liska <mliska@suse.cz>
Subject: gcov: support GCC 12.1 and newer compilers
Date: Thu, 13 Oct 2022 09:40:59 +0200

Starting with GCC 12.1, the created .gcda format can't be read by gcov
tool.  There are 2 significant changes to the .gcda file format that
need to be supported:

a) [gcov: Use system IO buffering]
   (23eb66d1d46a34cb28c4acbdf8a1deb80a7c5a05) changed that all sizes in
   the format are in bytes and not in words (4B)

b) [gcov: make profile merging smarter]
   (72e0c742bd01f8e7e6dcca64042b9ad7e75979de) add a new checksum to the
   file header.

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


