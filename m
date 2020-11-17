Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7662B66C5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgKQNGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgKQNGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8A2238E6;
        Tue, 17 Nov 2020 13:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618400;
        bh=kKdD/bDi/r9OKiJHaRI2vjjhiyyLMAeSez8UFZWZ7lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+X7XFXLu4aUYsF2gw5HLtNfC/Pi4mTr38R+aCr7udEYJ/n+CynO0HP7IjQXYlE9x
         xyPZSeW9cBKjza8394JFHMkmngzjYQ4YR+3IW9JlIE/3guCukLSigzutWu3tQh3UDd
         rknWJnY/0LSbTdYPD9rm3b6OkkEDOUG0n659Eps0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 02/64] gfs2: Wake up when sd_glock_disposal becomes zero
Date:   Tue, 17 Nov 2020 14:04:25 +0100
Message-Id: <20201117122106.250567431@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit da7d554f7c62d0c17c1ac3cc2586473c2d99f0bd ]

Commit fc0e38dae645 ("GFS2: Fix glock deallocation race") fixed a
sd_glock_disposal accounting bug by adding a missing atomic_dec
statement, but it failed to wake up sd_glock_wait when that decrement
causes sd_glock_disposal to reach zero.  As a consequence,
gfs2_gl_hash_clear can now run into a 10-minute timeout instead of
being woken up.  Add the missing wakeup.

Fixes: fc0e38dae645 ("GFS2: Fix glock deallocation race")
Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1eb737c466ddc..8e8695eb652af 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -751,7 +751,8 @@ again:
 	}
 	kfree(gl->gl_lksb.sb_lvbptr);
 	kmem_cache_free(cachep, gl);
-	atomic_dec(&sdp->sd_glock_disposal);
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
 	*glp = tmp;
 
 	return ret;
-- 
2.27.0



