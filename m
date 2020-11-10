Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2046A2ACD89
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbgKJDy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732925AbgKJDy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D1820721;
        Tue, 10 Nov 2020 03:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980497;
        bh=O/CzOtPuXcotBTHN4rjOHt8SUYFa7xTB3W2iAvt+Vzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3b4WNbxi8kTek5ovD2cK3lY1ECQQQFM/89gaO9spJsxW21OIxFdT4/R3g5df5xGM
         3hWeUD7xlae3SJVzATJk6bdRmT+uqTbgenw6H0P8l2/UCIsvt0Do4AIbvBJUJzeki+
         TCBOGfQVBTEfLfm+NNZsJxbrX32jWLCSlVRDGxtY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 12/42] gfs2: check for live vs. read-only file system in gfs2_fitrim
Date:   Mon,  9 Nov 2020 22:54:10 -0500
Message-Id: <20201110035440.424258-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit c5c68724696e7d2f8db58a5fce3673208d35c485 ]

Before this patch, gfs2_fitrim was not properly checking for a "live" file
system. If the file system had something to trim and the file system
was read-only (or spectator) it would start the trim, but when it starts
the transaction, gfs2_trans_begin returns -EROFS (read-only file system)
and it errors out. However, if the file system was already trimmed so
there's no work to do, it never called gfs2_trans_begin. That code is
bypassed so it never returns the error. Instead, it returns a good
return code with 0 work. All this makes for inconsistent behavior:
The same fstrim command can return -EROFS in one case and 0 in another.
This tripped up xfstests generic/537 which reports the error as:

    +fstrim with unrecovered metadata just ate your filesystem

This patch adds a check for a "live" (iow, active journal, iow, RW)
file system, and if not, returns the error properly.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e23735084ad17..3d5aa0c10a4c1 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1410,6 +1410,9 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
+		return -EROFS;
+
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
-- 
2.27.0

