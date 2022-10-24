Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2760A3B2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiJXL6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiJXL5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36FC7B79F;
        Mon, 24 Oct 2022 04:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC35A612B4;
        Mon, 24 Oct 2022 11:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E34C433D6;
        Mon, 24 Oct 2022 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611912;
        bh=gpFlxMFq9z9WFf3Ip2j0XYJri/W568vOh5sGgcJ2nzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFrplSOM3KDZK9pDy5Vpo8ozP3Bx8KhyjCWzDPegjMf1QKMn0RRrac7dis6TLBnIV
         ynpMoPM58sSdECZavIiVc8SR32+OfU/X2BUi1gPGkLjYcyQVgXMWmvCijyYVLqkwG7
         VLyAFMh/jaVDZT3jhYWItL2DdVm/OucsBHAkNtik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 159/159] gcov: support GCC 12.1 and newer compilers
Date:   Mon, 24 Oct 2022 13:31:53 +0200
Message-Id: <20221024112955.234880986@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Liska <mliska@suse.cz>

commit 977ef30a7d888eeb52fb6908f99080f33e5309a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -32,6 +32,13 @@
 
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
@@ -438,12 +445,18 @@ static size_t convert_to_gcda(char *buff
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
@@ -457,7 +470,8 @@ static size_t convert_to_gcda(char *buff
 			/* Counter record. */
 			pos += store_gcov_u32(buffer, pos,
 					      GCOV_TAG_FOR_COUNTER(ct_idx));
-			pos += store_gcov_u32(buffer, pos, ci_ptr->num * 2);
+			pos += store_gcov_u32(buffer, pos,
+				ci_ptr->num * 2 * GCOV_UNIT_SIZE);
 
 			for (cv_idx = 0; cv_idx < ci_ptr->num; cv_idx++) {
 				pos += store_gcov_u64(buffer, pos,


