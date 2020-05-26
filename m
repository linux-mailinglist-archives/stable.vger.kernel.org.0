Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E991E2EEF
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbgEZS46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389982AbgEZS44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB4A20870;
        Tue, 26 May 2020 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519416;
        bh=DYY57umynyFAZK/twDxMmZVr1Hq81x9GD9DqV30xJ0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K98ZDr4/O4fbhbBB9CNtMYtY8VCQPlMO8+BmhcRCLsnjvVXtusegq3y7km+FelGRI
         v+emOVPGKocSxm5GLzi5cfqR+Rrx9YdfnL4Bjp2cQhoV2Q7/yJP8kK0FQXekuG35j1
         K4k5rHdbLNCE4iw0iSZFZxJrW9VN5FzIwASZHxa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 61/65] Revert "gfs2: Dont demote a glock until its revokes are written"
Date:   Tue, 26 May 2020 20:53:20 +0200
Message-Id: <20200526183928.499403894@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



