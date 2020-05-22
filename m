Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B41DEA3A
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgEVOws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731211AbgEVOwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:52:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C658221FF;
        Fri, 22 May 2020 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159129;
        bh=DYY57umynyFAZK/twDxMmZVr1Hq81x9GD9DqV30xJ0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjaoTUzsAAlzq+/L0SsUq/dTvPUFgig/oHEU6gOvTI1FBgrcrii9QntmOZNe8D1UL
         iD+eroRlPhwt/sv3MGStZJzMGxnHaLZRPBbe01x86SmkYX9Lg54amhxX7vxXxD+kZH
         MVqmixMzDDfyZRuU1/mi4mGl7vRjedyoiIfzSzGg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.4 2/5] Revert "gfs2: Don't demote a glock until its revokes are written"
Date:   Fri, 22 May 2020 10:52:04 -0400
Message-Id: <20200522145207.435314-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145207.435314-1-sashal@kernel.org>
References: <20200522145207.435314-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit b14c94908b1b884276a6608dea3d0b1b510338b7 ]

This reverts commit df5db5f9ee112e76b5202fbc331f990a0fc316d6.

This patch fixes a regression: patch df5db5f9ee112 allowed function
run_queue() to bypass its call to do_xmote() if revokes were queued for
the glock. That's wrong because its call to do_xmote() is what is
responsible for calling the go_sync() glops functions to sync both
the ail list and any revokes queued for it. By bypassing the call,
gfs2 could get into a stand-off where the glock could not be demoted
until its revokes are written back, but the revokes would not be
written back because do_xmote() was never called.

It "sort of" works, however, because there are other mechanisms like
the log flush daemon (logd) that can sync the ail items and revokes,
if it deems it necessary. The problem is: without file system pressure,
it might never deem it necessary.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index f80ffccb0316..1eb737c466dd 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -541,9 +541,6 @@ __acquires(&gl->gl_lockref.lock)
 			goto out_unlock;
 		if (nonblock)
 			goto out_sched;
-		smp_mb();
-		if (atomic_read(&gl->gl_revokes) != 0)
-			goto out_sched;
 		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 		GLOCK_BUG_ON(gl, gl->gl_demote_state == LM_ST_EXCLUSIVE);
 		gl->gl_target = gl->gl_demote_state;
-- 
2.25.1

