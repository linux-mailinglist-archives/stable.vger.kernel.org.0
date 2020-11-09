Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208412ABB4A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbgKIN05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:26:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbgKINPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7EF8216C4;
        Mon,  9 Nov 2020 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927720;
        bh=YslYDa45oHKEau1PImBbICMtQ4p9PWkBeRpGnX9QEH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWhxamJDPTJrecJHfErlnfw2t9CsfyJL3x0QGpmODJ2Mx+4CdBROVAihQczbIwjU/
         tnWx6JEpRU4D7YyJJbA9aDO7rOAX+FhTSv1dUCd80C+lvOk6n/4ax3MeXSoNY6wjKh
         xUD/pi3inL2lZd8tuHhL2+fVZeZptjmETTNYTelI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Anthony Liguori <aliguori@amazon.com>
Subject: [PATCH 5.4 84/85] perf/core: Fix a memory leak in perf_event_parse_addr_filter()
Date:   Mon,  9 Nov 2020 13:56:21 +0100
Message-Id: <20201109125026.622601267@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
@@ -9415,6 +9415,7 @@ perf_event_parse_addr_filter(struct perf
 			if (token == IF_SRC_FILE || token == IF_SRC_FILEADDR) {
 				int fpos = token == IF_SRC_FILE ? 2 : 1;
 
+				kfree(filename);
 				filename = match_strdup(&args[fpos]);
 				if (!filename) {
 					ret = -ENOMEM;
@@ -9461,16 +9462,13 @@ perf_event_parse_addr_filter(struct perf
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
@@ -9490,13 +9488,13 @@ perf_event_parse_addr_filter(struct perf
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
 


