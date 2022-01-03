Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E049B4833A1
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiACOkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiACOie (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:38:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D654C07E5C5;
        Mon,  3 Jan 2022 06:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC824B80EFC;
        Mon,  3 Jan 2022 14:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24181C36AEB;
        Mon,  3 Jan 2022 14:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220457;
        bh=0KT3S0XbWs81qlP4UYJnOm9Id4lGWX9ST4UF77bfTZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xhrm3QLmgpTybq+B3RjD7ZubWoW/I3Qvage55Dzp307PikPvKNZWqkw7EO5dyXIg/
         kII+Uh3ONU8sn7lA51FqxBdkbW447T/Hc+q4DGVdVsHjTISiSzCyw6oGfUJ2r++Ou3
         DYstivfD5dz3OjVOfxsjyHA0fKENpToP8368Frq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 68/73] mm/damon/dbgfs: fix struct pid leaks in dbgfs_target_ids_write()
Date:   Mon,  3 Jan 2022 15:24:29 +0100
Message-Id: <20220103142059.125762091@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sj@kernel.org>

commit ebb3f994dd92f8fb4d70c7541091216c1e10cb71 upstream.

DAMON debugfs interface increases the reference counts of 'struct pid's
for targets from the 'target_ids' file write callback
('dbgfs_target_ids_write()'), but decreases the counts only in DAMON
monitoring termination callback ('dbgfs_before_terminate()').

Therefore, when 'target_ids' file is repeatedly written without DAMON
monitoring start/termination, the reference count is not decreased and
therefore memory for the 'struct pid' cannot be freed.  This commit
fixes this issue by decreasing the reference counts when 'target_ids' is
written.

Link: https://lkml.kernel.org/r/20211229124029.23348-1-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/dbgfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -185,6 +185,7 @@ static ssize_t dbgfs_target_ids_write(st
 		const char __user *buf, size_t count, loff_t *ppos)
 {
 	struct damon_ctx *ctx = file->private_data;
+	struct damon_target *t, *next_t;
 	char *kbuf, *nrs;
 	unsigned long *targets;
 	ssize_t nr_targets;
@@ -224,6 +225,13 @@ static ssize_t dbgfs_target_ids_write(st
 		goto unlock_out;
 	}
 
+	/* remove previously set targets */
+	damon_for_each_target_safe(t, next_t, ctx) {
+		if (targetid_is_pid(ctx))
+			put_pid((struct pid *)t->id);
+		damon_destroy_target(t);
+	}
+
 	err = damon_set_targets(ctx, targets, nr_targets);
 	if (err) {
 		if (targetid_is_pid(ctx))


