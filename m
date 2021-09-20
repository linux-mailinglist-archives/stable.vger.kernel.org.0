Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E93411E3A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350323AbhITR2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350048AbhITR0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:26:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 475076135F;
        Mon, 20 Sep 2021 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157352;
        bh=xhdoKSDHXdB+lWBA6Jjeu+jRei9dyhtrZCbnqD4y+DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTmcEGZ4t8QOlTmEXxvp6BkwBrSb96fwB3BJ4ejxbPrXzBz5Enj1ZuEkg0i8kN4nM
         /42HX5WGIu//XAbaZCLlc2ufc4rykcp/l5zVbWVb41JlD4yMs/7rvSvtUphvRUN8Rn
         +KcC+Ev6AWE5hpiDKiLm4I95fCPvH6QMSF6ulsDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 168/217] gfs2: Dont call dlm after protocol is unmounted
Date:   Mon, 20 Sep 2021 18:43:09 +0200
Message-Id: <20210920163930.329312854@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit d1340f80f0b8066321b499a376780da00560e857 ]

In the gfs2 withdraw sequence, the dlm protocol is unmounted with a call
to lm_unmount. After a withdraw, users are allowed to unmount the
withdrawn file system. But at that point we may still have glocks left
over that we need to free via unmount's call to gfs2_gl_hash_clear.
These glocks may have never been completed because of whatever problem
caused the withdraw (IO errors or whatever).

Before this patch, function gdlm_put_lock would still try to call into
dlm to unlock these leftover glocks, which resulted in dlm returning
-EINVAL because the lock space was abandoned. These glocks were never
freed because there was no mechanism after that to free them.

This patch adds a check to gdlm_put_lock to see if the locking protocol
was inactive (DFL_UNMOUNT flag) and if so, free the glock and not
make the invalid call into dlm.

I could have combined this "if" with the one that follows, related to
leftover glock LVBs, but I felt the code was more readable with its own
if clause.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lock_dlm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index de733a6c30bb..f3c16a504c8d 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -295,6 +295,11 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_update_request_times(gl);
 
+	/* don't want to call dlm if we've unmounted the lock protocol */
+	if (test_bit(DFL_UNMOUNT, &ls->ls_recover_flags)) {
+		gfs2_glock_free(gl);
+		return;
+	}
 	/* don't want to skip dlm_unlock writing the lvb when lock has one */
 
 	if (test_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags) &&
-- 
2.30.2



