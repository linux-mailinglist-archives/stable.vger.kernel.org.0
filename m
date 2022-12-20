Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E39651EB5
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 11:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLTKXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 05:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiLTKXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 05:23:42 -0500
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8415FAF2;
        Tue, 20 Dec 2022 02:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1671531821;
  x=1703067821;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Xh5Y6FwbdNID/96r51blgPxGkBw0GmwLd4y9nEZHdW0=;
  b=DVqNZTjdvFEIArPZTwailrkzdVyJbTakHZgTPrNY8UXrDGwsIVWBcZZS
   WkVNux1lEm0Crly1hCPMtZo92onHvmUhCVbDir5GZ81XEWiQxKC3D/pdA
   LgkFH3E0+PbNPDp+hZdmW2bVEiihhcDEVL974Kysyt0UzilNKl1cT19WL
   4n8bysDuEW8lTAVx/gmnoMla0dmuBXsiytSTO3ImogIxqTmIxJ4V7t6ga
   QZud7kbeYPa7MW7RDI5jEsrVe7wYuU5xKk9rxGxq8GsecB7SK/FPGr0qh
   l90YNmfPSewY6k5V4VPgmqiszwr5BCFNp6V4I4ZFgv8C+JGYZZWP8p1EP
   Q==;
From:   Rickard Andersson <rickaran@axis.com>
To:     <linux-kernel@vger.kernel.org>, <oberpar@linux.ibm.com>
CC:     <rickard314.andersson@gmail.com>, <mliska@suse.cz>,
        <Jesper.Nilsson@axis.com>, Rickard x Andersson <rickaran@axis.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] gcov: Add support for checksum field
Date:   Tue, 20 Dec 2022 11:23:18 +0100
Message-ID: <20221220102318.3418501-1-rickaran@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: se-mail05w.axis.com (10.20.40.11) To se-mail03w.axis.com
 (10.20.40.9)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rickard x Andersson <rickaran@axis.com>

In GCC version 12.1 a checksum field was added.

This patch fixes a kernel crash occurring during boot when
using gcov-kernel with GCC version 12.2. The crash occurred on
a system running on i.MX6SX.

Fixes: 977ef30a7d88 ("gcov: support GCC 12.1 and newer compilers")
Signed-off-by: Rickard x Andersson <rickaran@axis.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: <stable@vger.kernel.org>
---
 kernel/gcov/gcc_4_7.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/gcov/gcc_4_7.c b/kernel/gcov/gcc_4_7.c
index c699feda21ac..04880d8fba25 100644
--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -85,6 +85,7 @@ struct gcov_fn_info {
  * @version: gcov version magic indicating the gcc version used for compilation
  * @next: list head for a singly-linked list
  * @stamp: uniquifying time stamp
+ * @checksum: unique object checksum
  * @filename: name of the associated gcov data file
  * @merge: merge functions (null for unused counter type)
  * @n_functions: number of instrumented functions
@@ -97,6 +98,10 @@ struct gcov_info {
 	unsigned int version;
 	struct gcov_info *next;
 	unsigned int stamp;
+ /* Since GCC 12.1 a checksum field is added. */
+#if (__GNUC__ >= 12)
+	unsigned int checksum;
+#endif
 	const char *filename;
 	void (*merge[GCOV_COUNTERS])(gcov_type *, unsigned int);
 	unsigned int n_functions;
-- 
2.30.2

