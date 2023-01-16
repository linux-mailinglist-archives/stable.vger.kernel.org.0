Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809D066C8AE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbjAPQlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjAPQlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:41:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551513E60A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:29:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4C0AB81065
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4600CC433D2;
        Mon, 16 Jan 2023 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886567;
        bh=7SnJQGvgtJRvEgpsEeIL25fx1CggEPI0+icVR9veNTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g97+YYYx4x9iPDEhu2alB3VKTdbDMhu2oCh0KCIO0egbOEPPQhc+B6C+TbkUwq6Hf
         W+YX29hwTsdoeHWGvMzFp3sBG3N6FtPvpx9/rfzhxciK436pYivCjixz2RhJfRwI6M
         nw0T0Fd7GRjCkA5aSaEzFR9gMORJ8ZxkIYgnQYgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rickard x Andersson <rickaran@axis.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Martin Liska <mliska@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 450/658] gcov: add support for checksum field
Date:   Mon, 16 Jan 2023 16:48:58 +0100
Message-Id: <20230116154930.078611021@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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


