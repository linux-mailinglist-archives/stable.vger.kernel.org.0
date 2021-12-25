Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34F947F202
	for <lists+stable@lfdr.de>; Sat, 25 Dec 2021 06:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhLYFM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Dec 2021 00:12:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49984 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhLYFM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Dec 2021 00:12:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D937EB80B33;
        Sat, 25 Dec 2021 05:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C01DC36AE5;
        Sat, 25 Dec 2021 05:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409175;
        bh=jwq1C0xCNOQZ4o6aepOLSPYYPk9cTF/tgIqKQoBxg34=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xSA61ujtNjDkZtLPmLHfBT1+LxS6pJlEx5z4/wPNIzkseeNcv+WVWAq69gOWuqFFq
         akp2WTErizuLoHhgy46S4r8v952WtBksPb84YUcN4PY6xYWwQwiHup1HTEGgynsRVI
         FUCeyObq9KTOROLgioU7WDKAzKZVQ5NuuOYRKw4M=
Date:   Fri, 24 Dec 2021 21:12:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sangwoob@amazon.com, sj@kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 8/9] mm/damon/dbgfs: protect targets destructions
 with kdamond_lock
Message-ID: <20211225051254.qnNQD42Wg%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: protect targets destructions with kdamond_lock

DAMON debugfs interface iterates current monitoring targets in
'dbgfs_target_ids_read()' while holding the corresponding 'kdamond_lock'. 
However, it also destructs the monitoring targets in
'dbgfs_before_terminate()' without holding the lock.  This can result in a
use_after_free bug.  This commit avoids the race by protecting the
destruction with the corresponding 'kdamond_lock'.

Link: https://lkml.kernel.org/r/20211221094447.2241-1-sj@kernel.org
Reported-by: Sangwoo Bae <sangwoob@amazon.com>
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-protect-targets-destructions-with-kdamond_lock
+++ a/mm/damon/dbgfs.c
@@ -650,10 +650,12 @@ static void dbgfs_before_terminate(struc
 	if (!targetid_is_pid(ctx))
 		return;
 
+	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid((struct pid *)t->id);
 		damon_destroy_target(t);
 	}
+	mutex_unlock(&ctx->kdamond_lock);
 }
 
 static struct damon_ctx *dbgfs_new_ctx(void)
_
