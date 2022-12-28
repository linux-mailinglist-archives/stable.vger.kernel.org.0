Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F29657F64
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbiL1QE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiL1QEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:04:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A34519033
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:04:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA6F36155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA000C433D2;
        Wed, 28 Dec 2022 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243459;
        bh=ChABwfarEnxpiZ8bKwylaKD1+QV4NBac45YFxo79hTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6aruB1u6KL3Ebxu+uJcDzGo3w2bCL828f1kbWRezEeGQHCZPdifle5t4XfwYxC++
         kWGXDiN6l7rhdfHaCGbUr3rkf054oxQ0JFNiuNx9+zgBBcUjfh0s4QqmSAHO1SlEYx
         ncv4wTHSg3EZuh6Yr8lp/C14Uy/1pCQ3I8K2AQkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rickard x Andersson <rickaran@axis.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Martin Liska <mliska@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 723/731] gcov: add support for checksum field
Date:   Wed, 28 Dec 2022 15:43:50 +0100
Message-Id: <20221228144317.404616527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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


