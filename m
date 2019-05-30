Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98A042EE71
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfE3Drc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732217AbfE3DUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A0E2492F;
        Thu, 30 May 2019 03:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186431;
        bh=WksFeKBKm23ZOKJUdAGeHa17sDokfaDq+8RAvwQ/XTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSqEyP28PsTMsUpatIThmXy0Tcn5BVmEmwIaoeysDWedNt6jQtGBSZ8qd6wnUEUh5
         aGvgp5WuKAFJOe7k67li64Ut+APX5p8AztBwhiLRcZy40q6PF3mHUP9xDtTKag4MCH
         ZVaCkUH9oyGZCLAAtJUZ4zvb31WSNnSo/kM8YFc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 023/128] gfs2: Fix lru_count going negative
Date:   Wed, 29 May 2019 20:05:55 -0700
Message-Id: <20190530030438.979746132@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7881ef3f33bb80f459ea6020d1e021fc524a6348 ]

Under certain conditions, lru_count may drop below zero resulting in
a large amount of log spam like this:

vmscan: shrink_slab: gfs2_dump_glock+0x3b0/0x630 [gfs2] \
    negative objects to delete nr=-1

This happens as follows:
1) A glock is moved from lru_list to the dispose list and lru_count is
   decremented.
2) The dispose function calls cond_resched() and drops the lru lock.
3) Another thread takes the lru lock and tries to add the same glock to
   lru_list, checking if the glock is on an lru list.
4) It is on a list (actually the dispose list) and so it avoids
   incrementing lru_count.
5) The glock is moved to lru_list.
5) The original thread doesn't dispose it because it has been re-added
   to the lru list but the lru_count has still decreased by one.

Fix by checking if the LRU flag is set on the glock rather than checking
if the glock is on some list and rearrange the code so that the LRU flag
is added/removed precisely when the glock is added/removed from lru_list.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 7a8b1d72e3d91..efd44d5645d83 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -136,22 +136,26 @@ static int demote_ok(const struct gfs2_glock *gl)
 
 void gfs2_glock_add_to_lru(struct gfs2_glock *gl)
 {
+	if (!(gl->gl_ops->go_flags & GLOF_LRU))
+		return;
+
 	spin_lock(&lru_lock);
 
-	if (!list_empty(&gl->gl_lru))
-		list_del_init(&gl->gl_lru);
-	else
+	list_del(&gl->gl_lru);
+	list_add_tail(&gl->gl_lru, &lru_list);
+
+	if (!test_bit(GLF_LRU, &gl->gl_flags)) {
+		set_bit(GLF_LRU, &gl->gl_flags);
 		atomic_inc(&lru_count);
+	}
 
-	list_add_tail(&gl->gl_lru, &lru_list);
-	set_bit(GLF_LRU, &gl->gl_flags);
 	spin_unlock(&lru_lock);
 }
 
 static void gfs2_glock_remove_from_lru(struct gfs2_glock *gl)
 {
 	spin_lock(&lru_lock);
-	if (!list_empty(&gl->gl_lru)) {
+	if (test_bit(GLF_LRU, &gl->gl_flags)) {
 		list_del_init(&gl->gl_lru);
 		atomic_dec(&lru_count);
 		clear_bit(GLF_LRU, &gl->gl_flags);
@@ -1048,8 +1052,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
 			fast_path = 1;
 	}
-	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl) &&
-	    (glops->go_flags & GLOF_LRU))
+	if (!test_bit(GLF_LFLUSH, &gl->gl_flags) && demote_ok(gl))
 		gfs2_glock_add_to_lru(gl);
 
 	trace_gfs2_glock_queue(gh, 0);
@@ -1349,6 +1352,7 @@ __acquires(&lru_lock)
 		if (!spin_trylock(&gl->gl_lockref.lock)) {
 add_back_to_lru:
 			list_add(&gl->gl_lru, &lru_list);
+			set_bit(GLF_LRU, &gl->gl_flags);
 			atomic_inc(&lru_count);
 			continue;
 		}
@@ -1356,7 +1360,6 @@ __acquires(&lru_lock)
 			spin_unlock(&gl->gl_lockref.lock);
 			goto add_back_to_lru;
 		}
-		clear_bit(GLF_LRU, &gl->gl_flags);
 		gl->gl_lockref.count++;
 		if (demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
@@ -1392,6 +1395,7 @@ static long gfs2_scan_glock_lru(int nr)
 		if (!test_bit(GLF_LOCK, &gl->gl_flags)) {
 			list_move(&gl->gl_lru, &dispose);
 			atomic_dec(&lru_count);
+			clear_bit(GLF_LRU, &gl->gl_flags);
 			freed++;
 			continue;
 		}
-- 
2.20.1



