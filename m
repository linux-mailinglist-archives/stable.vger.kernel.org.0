Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0227B2B6138
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgKQNRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:17:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729782AbgKQNQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:16:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C13206D5;
        Tue, 17 Nov 2020 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619018;
        bh=Ath5HiLb+Ur+ryUqN182/0Y5RZXzARERCr1b6+NLivk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVzFVRAg3v5gRWCpAVfA0S1Gza/3UZYHhwFUGTvhyQnBJhx0kjRDsYyFmwOOOSsvA
         KIr8xerQNPMi27RKXThzTVg2y34qeJoax+rna2AyNZgVR2MWA22vbwqy5XNOZqpBLu
         2GezHcfR4c1H3l5kLhSdcp3kJMFThkLND+KMqfRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Anthony Liguori <aliguori@amazon.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 68/85] perf/core: Fix a memory leak in perf_event_parse_addr_filter()
Date:   Tue, 17 Nov 2020 14:05:37 +0100
Message-Id: <20201117122114.364908010@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "kiyin(尹亮)" <kiyin@tencent.com>

commit 7bdb157cdebbf95a1cd94ed2e01b338714075d00 upstream

As shown through runtime testing, the "filename" allocation is not
always freed in perf_event_parse_addr_filter().

There are three possible ways that this could happen:

 - It could be allocated twice on subsequent iterations through the loop,
 - or leaked on the success path,
 - or on the failure path.

Clean up the code flow to make it obvious that 'filename' is always
freed in the reallocation path and in the two return paths as well.

We rely on the fact that kfree(NULL) is NOP and filename is initialized
with NULL.

This fixes the leak. No other side effects expected.

[ Dan Carpenter: cleaned up the code flow & added a changelog. ]
[ Ingo Molnar: updated the changelog some more. ]

Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Signed-off-by: "kiyin(尹亮)" <kiyin@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc: Anthony Liguori <aliguori@amazon.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8581,6 +8581,7 @@ perf_event_parse_addr_filter(struct perf
 			if (token == IF_SRC_FILE || token == IF_SRC_FILEADDR) {
 				int fpos = filter->range ? 2 : 1;
 
+				kfree(filename);
 				filename = match_strdup(&args[fpos]);
 				if (!filename) {
 					ret = -ENOMEM;
@@ -8619,16 +8620,13 @@ perf_event_parse_addr_filter(struct perf
 				 */
 				ret = -EOPNOTSUPP;
 				if (!event->ctx->task)
-					goto fail_free_name;
+					goto fail;
 
 				/* look up the path and grab its inode */
 				ret = kern_path(filename, LOOKUP_FOLLOW,
 						&filter->path);
 				if (ret)
-					goto fail_free_name;
-
-				kfree(filename);
-				filename = NULL;
+					goto fail;
 
 				ret = -EINVAL;
 				if (!filter->path.dentry ||
@@ -8648,13 +8646,13 @@ perf_event_parse_addr_filter(struct perf
 	if (state != IF_STATE_ACTION)
 		goto fail;
 
+	kfree(filename);
 	kfree(orig);
 
 	return 0;
 
-fail_free_name:
-	kfree(filename);
 fail:
+	kfree(filename);
 	free_filters_list(filters);
 	kfree(orig);
 


