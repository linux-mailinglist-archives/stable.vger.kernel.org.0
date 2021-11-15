Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F7C451373
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348258AbhKOTv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343552AbhKOTVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA33635AA;
        Mon, 15 Nov 2021 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001718;
        bh=maGUbOpIvCnDQ4k7C+Pzo4Ap4iYOQRf8odEQQqxmUZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Kzfouxm7uOh3bN6hgK3QTJ4uuMlw5eTpWrUDSyfbBzgzRv1M6jzg56Yvgf5Dy9p2
         uPyoHxx7RrcpjgkovqXyL5aaT+JrjeMii7USWRJnAwAZmPvbmj5XzrIsqgbaVdV1W1
         nET9U6/fuMTQWJOIpbNBtK4odXEiMlMJwplj05Fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 294/917] gfs2: Fix glock_hash_walk bugs
Date:   Mon, 15 Nov 2021 17:56:29 +0100
Message-Id: <20211115165438.736199293@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 7427f3bb49d81525b7dd1d0f7c5f6bbc752e6f0e ]

So far, glock_hash_walk took a reference on each glock it iterated over, and it
was the examiner's responsibility to drop those references.  Dropping the final
reference to a glock can sleep and the examiners are called in a RCU critical
section with spin locks held, so examiners that didn't need the extra reference
had to drop it asynchronously via gfs2_glock_queue_put or similar.  This wasn't
done correctly in thaw_glock which did call gfs2_glock_put, and not at all in
dump_glock_func.

Change glock_hash_walk to not take glock references at all.  That way, the
examiners that don't need them won't have to bother with slow asynchronous
puts, and the examiners that do need references can take them themselves.

Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8ca89adf31a86..02cd0ae98208d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1893,10 +1893,10 @@ static void glock_hash_walk(glock_examiner examiner, const struct gfs2_sbd *sdp)
 	do {
 		rhashtable_walk_start(&iter);
 
-		while ((gl = rhashtable_walk_next(&iter)) && !IS_ERR(gl))
-			if (gl->gl_name.ln_sbd == sdp &&
-			    lockref_get_not_dead(&gl->gl_lockref))
+		while ((gl = rhashtable_walk_next(&iter)) && !IS_ERR(gl)) {
+			if (gl->gl_name.ln_sbd == sdp)
 				examiner(gl);
+		}
 
 		rhashtable_walk_stop(&iter);
 	} while (cond_resched(), gl == ERR_PTR(-EAGAIN));
@@ -1938,7 +1938,6 @@ static void flush_delete_work(struct gfs2_glock *gl)
 					   &gl->gl_delete, 0);
 		}
 	}
-	gfs2_glock_queue_work(gl, 0);
 }
 
 void gfs2_flush_delete_work(struct gfs2_sbd *sdp)
@@ -1955,10 +1954,10 @@ void gfs2_flush_delete_work(struct gfs2_sbd *sdp)
 
 static void thaw_glock(struct gfs2_glock *gl)
 {
-	if (!test_and_clear_bit(GLF_FROZEN, &gl->gl_flags)) {
-		gfs2_glock_put(gl);
+	if (!test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
+		return;
+	if (!lockref_get_not_dead(&gl->gl_lockref))
 		return;
-	}
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 	gfs2_glock_queue_work(gl, 0);
 }
@@ -1974,9 +1973,12 @@ static void clear_glock(struct gfs2_glock *gl)
 	gfs2_glock_remove_from_lru(gl);
 
 	spin_lock(&gl->gl_lockref.lock);
-	if (gl->gl_state != LM_ST_UNLOCKED)
-		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
-	__gfs2_glock_queue_work(gl, 0);
+	if (!__lockref_is_dead(&gl->gl_lockref)) {
+		gl->gl_lockref.count++;
+		if (gl->gl_state != LM_ST_UNLOCKED)
+			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
+		__gfs2_glock_queue_work(gl, 0);
+	}
 	spin_unlock(&gl->gl_lockref.lock);
 }
 
-- 
2.33.0



