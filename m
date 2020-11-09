Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917442ABACE
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbgKINW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:22:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgKINWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:22:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F235B2076E;
        Mon,  9 Nov 2020 13:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928138;
        bh=WKesmw1EB5KG72XqKogbKm0+CFZevf0raON6CsIXZqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQGsQ9JTTqKLp9Z5H1Qpuk6nZQ0zBXt90vcEN33BmboFukMjyCtnO6fFZXQ8G2vf8
         JrAd4tXpbbVIGjuArxQhqrPbE2fig0syT1wn/MYHpycolLAJMHP7YCwIxjyXa64+2Y
         nZfmXUcP3trprj3EjJb8u1885WBBAp2fcBgjlqu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Anthony Liguori <aliguori@amazon.com>
Subject: [PATCH 5.9 133/133] perf/core: Fix a memory leak in perf_event_parse_addr_filter()
Date:   Mon,  9 Nov 2020 13:56:35 +0100
Message-Id: <20201109125037.090717654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kiyin(尹亮) <kiyin@tencent.com>

commit 7bdb157cdebbf95a1cd94ed2e01b338714075d00 upstream.

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
--
 kernel/events/core.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10058,6 +10058,7 @@ perf_event_parse_addr_filter(struct perf
 			if (token == IF_SRC_FILE || token == IF_SRC_FILEADDR) {
 				int fpos = token == IF_SRC_FILE ? 2 : 1;
 
+				kfree(filename);
 				filename = match_strdup(&args[fpos]);
 				if (!filename) {
 					ret = -ENOMEM;
@@ -10104,16 +10105,13 @@ perf_event_parse_addr_filter(struct perf
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
@@ -10133,13 +10131,13 @@ perf_event_parse_addr_filter(struct perf
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
 


