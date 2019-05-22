Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E293F26B0F
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730974AbfEVTXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730235AbfEVTXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:23:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B987B21850;
        Wed, 22 May 2019 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553024;
        bh=2exSR2Nnkhck0kqyrIIIcnFhOeWL/t1JxLNownjldOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPudtTCB/5H8v0DS9B9dVLlB1b2rm/fjBIRGz89aB7aRkAMbVDQrr7adFfTzicsYL
         4VpNqY7ldG452bfKGSjbEVA4n7JO5UwcXywYCRP/7qpFbRmAoGhEdZs+QNA5pHsS5C
         Ip7AazUqI4t6uqpwtCOGgc34PnmJhjv8Wt8jw0qI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abhi Das <adas@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.0 005/317] gfs2: fix race between gfs2_freeze_func and unmount
Date:   Wed, 22 May 2019 15:18:26 -0400
Message-Id: <20190522192338.23715-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhi Das <adas@redhat.com>

[ Upstream commit 8f91821990fd6f170a5dca79697a441181a41b16 ]

As part of the freeze operation, gfs2_freeze_func() is left blocking
on a request to hold the sd_freeze_gl in SH. This glock is held in EX
by the gfs2_freeze() code.

A subsequent call to gfs2_unfreeze() releases the EXclusively held
sd_freeze_gl, which allows gfs2_freeze_func() to acquire it in SH and
resume its operation.

gfs2_unfreeze(), however, doesn't wait for gfs2_freeze_func() to complete.
If a umount is issued right after unfreeze, it could result in an
inconsistent filesystem because some journal data (statfs update) isn't
written out.

Refer to commit 24972557b12c for a more detailed explanation of how
freeze/unfreeze work.

This patch causes gfs2_unfreeze() to wait for gfs2_freeze_func() to
complete before returning to the user.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/incore.h | 1 +
 fs/gfs2/super.c  | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e10e0b0a7cd58..e1a33d2881213 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -621,6 +621,7 @@ enum {
 	SDF_SKIP_DLM_UNLOCK	= 8,
 	SDF_FORCE_AIL_FLUSH     = 9,
 	SDF_AIL1_IO_ERROR	= 10,
+	SDF_FS_FROZEN           = 11,
 };
 
 enum gfs2_freeze_state {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ca71163ff7cfd..360206704a14c 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -973,8 +973,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	if (error) {
 		printk(KERN_INFO "GFS2: couldn't get freeze lock : %d\n", error);
 		gfs2_assert_withdraw(sdp, 0);
-	}
-	else {
+	} else {
 		atomic_set(&sdp->sd_freeze_state, SFS_UNFROZEN);
 		error = thaw_super(sb);
 		if (error) {
@@ -987,6 +986,8 @@ void gfs2_freeze_func(struct work_struct *work)
 		gfs2_glock_dq_uninit(&freeze_gh);
 	}
 	deactivate_super(sb);
+	clear_bit_unlock(SDF_FS_FROZEN, &sdp->sd_flags);
+	wake_up_bit(&sdp->sd_flags, SDF_FS_FROZEN);
 	return;
 }
 
@@ -1029,6 +1030,7 @@ static int gfs2_freeze(struct super_block *sb)
 		msleep(1000);
 	}
 	error = 0;
+	set_bit(SDF_FS_FROZEN, &sdp->sd_flags);
 out:
 	mutex_unlock(&sdp->sd_freeze_mutex);
 	return error;
@@ -1053,7 +1055,7 @@ static int gfs2_unfreeze(struct super_block *sb)
 
 	gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
 	mutex_unlock(&sdp->sd_freeze_mutex);
-	return 0;
+	return wait_on_bit(&sdp->sd_flags, SDF_FS_FROZEN, TASK_INTERRUPTIBLE);
 }
 
 /**
-- 
2.20.1

