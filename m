Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE3E6538AD
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 23:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiLUWco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 17:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiLUWck (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 17:32:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDEB111E;
        Wed, 21 Dec 2022 14:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEE3161965;
        Wed, 21 Dec 2022 22:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC23C433F0;
        Wed, 21 Dec 2022 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671661956;
        bh=Qls6VaXvM9hwrp2/ufd/C4QxrNAtLR7c2Hcr8t4602A=;
        h=Date:To:From:Subject:From;
        b=QqndkipV/OSrcQyQBaeAUx0vka101ZMj8Stz0eGHuE1x3jfTZBd8Gk/LPUTCh4aMz
         nOsQqFTZbtFO0IfEBfKhHjNCAEeDwu6PVZmbsQpNoHkXE+eyz8LHKh9yUIlOSfiY7e
         DNx2oZ9n3HvmQWS2QyTrcJj6SOsoIgiMUr4NoUs4=
Date:   Wed, 21 Dec 2022 14:32:35 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        oberpar@linux.ibm.com, mliska@suse.cz, rickaran@axis.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] gcov-add-support-for-checksum-field.patch removed from -mm tree
Message-Id: <20221221223236.4BC23C433F0@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: gcov: add support for checksum field
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-checksum-field.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rickard x Andersson <rickaran@axis.com>
Subject: gcov: add support for checksum field
Date: Tue, 20 Dec 2022 11:23:18 +0100

In GCC version 12.1 a checksum field was added.

This patch fixes a kernel crash occurring during boot when using
gcov-kernel with GCC version 12.2.  The crash occurred on a system running
on i.MX6SX.

Link: https://lkml.kernel.org/r/20221220102318.3418501-1-rickaran@axis.com
Fixes: 977ef30a7d88 ("gcov: support GCC 12.1 and newer compilers")
Signed-off-by: Rickard x Andersson <rickaran@axis.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Martin Liska <mliska@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-checksum-field
+++ a/kernel/gcov/gcc_4_7.c
@@ -82,6 +82,7 @@ struct gcov_fn_info {
  * @version: gcov version magic indicating the gcc version used for compilation
  * @next: list head for a singly-linked list
  * @stamp: uniquifying time stamp
+ * @checksum: unique object checksum
  * @filename: name of the associated gcov data file
  * @merge: merge functions (null for unused counter type)
  * @n_functions: number of instrumented functions
@@ -94,6 +95,10 @@ struct gcov_info {
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
_

Patches currently in -mm which might be from rickaran@axis.com are


