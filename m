Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D35F3A022D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhFHTBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235617AbhFHS6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E487261405;
        Tue,  8 Jun 2021 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177778;
        bh=AyCAmFFdwNBACzlEWmHi1Hqqo5DCuwBpS3cSPsWgARY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCvM40aaaQI2oPfFaErMUSTNwjz9KVSBK/ZUyM/UfrqdXe0yoL6IiljsSp0LUEJlq
         NuidqouKcI88FqlAbLRfaKCnP82Z0w8lSksqhM5Uw+pxiVGhCx5EYHbHcttJhfZaT7
         c8iPcg88ygGa0o/Dw9GU5SFIvFOjE0L6IblRrfgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.10 096/137] gfs2: fix scheduling while atomic bug in glocks
Date:   Tue,  8 Jun 2021 20:27:16 +0200
Message-Id: <20210608175945.623752120@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 20265d9a67e40eafd39a8884658ca2e36f05985d upstream.

Before this patch, in the unlikely event that gfs2_glock_dq encountered
a withdraw, it would do a wait_on_bit to wait for its journal to be
recovered, but it never released the glock's spin_lock, which caused a
scheduling-while-atomic error.

This patch unlocks the lockref spin_lock before waiting for recovery.

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1457,9 +1457,11 @@ void gfs2_glock_dq(struct gfs2_holder *g
 	    glock_blocked_by_withdraw(gl) &&
 	    gh->gh_gl != sdp->sd_jinode_gl) {
 		sdp->sd_glock_dqs_held++;
+		spin_unlock(&gl->gl_lockref.lock);
 		might_sleep();
 		wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
 			    TASK_UNINTERRUPTIBLE);
+		spin_lock(&gl->gl_lockref.lock);
 	}
 	if (gh->gh_flags & GL_NOCACHE)
 		handle_callback(gl, LM_ST_UNLOCKED, 0, false);


