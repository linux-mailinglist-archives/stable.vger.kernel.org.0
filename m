Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD35652805
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 21:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLTUms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 15:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiLTUmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 15:42:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16261B9D1;
        Tue, 20 Dec 2022 12:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652C0615B9;
        Tue, 20 Dec 2022 20:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BD3C433EF;
        Tue, 20 Dec 2022 20:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671568955;
        bh=PGrG0md7K7FotQmq+2NMgclYpNmSdsE77lXRX6WCrUU=;
        h=Date:To:From:Subject:From;
        b=T1ysSKxNNmL4f1d5zWa0nAt7zfOyl6EapnzmPdtqcl4YG2iyuiO48VYe9HMSd0ZJN
         LZjyWmkurosn94p57mwe5gzH+BC0OFNBOjJkcToJ2vvH7/O6crVfC7yr5B6VNUjyei
         O4sTKODyIeo5v7n2DMrdW9dRtmLMZ3obzIusebho=
Date:   Tue, 20 Dec 2022 12:42:34 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        oberpar@linux.ibm.com, mliska@suse.cz, rickaran@axis.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-add-support-for-checksum-field.patch added to mm-hotfixes-unstable branch
Message-Id: <20221220204235.B5BD3C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: gcov: add support for checksum field
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     gcov-add-support-for-checksum-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-add-support-for-checksum-field.patch

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
Reviewed-By: Martin Liska <mliska@suse.cz>
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

gcov-add-support-for-checksum-field.patch

