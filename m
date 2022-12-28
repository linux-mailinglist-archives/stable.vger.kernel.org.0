Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F55A65845D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiL1Q5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiL1Q4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE3E1D673
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC8561568
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4FAC433EF;
        Wed, 28 Dec 2022 16:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246345;
        bh=ChABwfarEnxpiZ8bKwylaKD1+QV4NBac45YFxo79hTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RP79OluqqjMZjBEmvv9TSx8pj1jSPMs9PdWDF9DJn7Rpk5kLEy3maqNnKLTEqFj2y
         TTOhERfKWHQzWavv6wSuHZzCBuCrH/g0MWDp8ldCI5jdLS6t8DtnLPWP2BYOVoh7x4
         LM8gxGh7tPBnV1tmvnQGOzl7BUNIJeAoOds61yGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rickard x Andersson <rickaran@axis.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Martin Liska <mliska@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 1053/1073] gcov: add support for checksum field
Date:   Wed, 28 Dec 2022 15:44:01 +0100
Message-Id: <20221228144356.824098357@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rickard x Andersson <rickaran@axis.com>

commit e96b95c2b7a63a454b6498e2df67aac14d046d13 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
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


