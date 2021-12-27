Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A49B480072
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbhL0Pq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43540 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240189AbhL0Pov (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECBD461117;
        Mon, 27 Dec 2021 15:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53BCC36AEA;
        Mon, 27 Dec 2021 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619890;
        bh=RlxaPlramHDR+ZBWCa8QeUz7Q+hWOOPiDmk0XLX2QF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWdReU/sPcqUMpAoU5VCoKFREvjhtySjpOgZ/6nc22dzRqHyBEopkLLhdzEB2sZ4j
         ugKMNJ1MCJRK2rwb8xf0ykI0eXLFUEFpf0RcQ+1hHzgEWbOkQfZcseumMHxwz/d9l5
         UmFSXA+0pb0zLwtz/R8xezH/xhy5lMXTYRSKLDYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sangwoo Bae <sangwoob@amazon.com>,
        SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 105/128] mm/damon/dbgfs: protect targets destructions with kdamond_lock
Date:   Mon, 27 Dec 2021 16:31:20 +0100
Message-Id: <20211227151335.024082476@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

commit 34796417964b8d0aef45a99cf6c2d20cebe33733 upstream.

DAMON debugfs interface iterates current monitoring targets in
'dbgfs_target_ids_read()' while holding the corresponding
'kdamond_lock'.  However, it also destructs the monitoring targets in
'dbgfs_before_terminate()' without holding the lock.  This can result in
a use_after_free bug.  This commit avoids the race by protecting the
destruction with the corresponding 'kdamond_lock'.

Link: https://lkml.kernel.org/r/20211221094447.2241-1-sj@kernel.org
Reported-by: Sangwoo Bae <sangwoob@amazon.com>
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/dbgfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -309,10 +309,12 @@ static int dbgfs_before_terminate(struct
 	if (!targetid_is_pid(ctx))
 		return 0;
 
+	mutex_lock(&ctx->kdamond_lock);
 	damon_for_each_target_safe(t, next, ctx) {
 		put_pid((struct pid *)t->id);
 		damon_destroy_target(t);
 	}
+	mutex_unlock(&ctx->kdamond_lock);
 	return 0;
 }
 


