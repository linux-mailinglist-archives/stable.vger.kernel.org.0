Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDD45136D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348245AbhKOTvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343551AbhKOTVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DBD0632FD;
        Mon, 15 Nov 2021 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001716;
        bh=xzBjlW1GAoVzxKZVkGz6oFK/TeaGbJh751oaVW3kHlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUNAUq9VwfN75dhT8xlK7tzc52sy86J94IYCHtKqtwFwTM8wSintZinY+/Bw2CQTK
         Uz8F4K8o4XJtyYFzmsllw4N7AMEXfIpTUP7FKbGfoZAEqxWdpZ816uDNV4QHqXDfC0
         6zLoRn0RbWfYa7DpjrKWZcyw/SzxRxBM+20ZNhgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/917] gfs2: Cancel remote delete work asynchronously
Date:   Mon, 15 Nov 2021 17:56:28 +0100
Message-Id: <20211115165438.703441508@linuxfoundation.org>
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

[ Upstream commit 486408d690e130c3adacf816754b97558d715f46 ]

In gfs2_inode_lookup and gfs2_create_inode, we're calling
gfs2_cancel_delete_work which currently cancels any remote delete work
(delete_work_func) synchronously.  This means that if the work is
currently running, it will wait for it to finish.  We're doing this to
pevent a previous instance of an inode from having any influence on the
next instance.

However, delete_work_func uses gfs2_inode_lookup internally, and we can
end up in a deadlock when delete_work_func gets interrupted at the wrong
time.  For example,

  (1) An inode's iopen glock has delete work queued, but the inode
      itself has been evicted from the inode cache.

  (2) The delete work is preempted before reaching gfs2_inode_lookup.

  (3) Another process recreates the inode (gfs2_create_inode).  It tries
      to cancel any outstanding delete work, which blocks waiting for
      the ongoing delete work to finish.

  (4) The delete work calls gfs2_inode_lookup, which blocks waiting for
      gfs2_create_inode to instantiate and unlock the new inode =>
      deadlock.

It turns out that when the delete work notices that its inode has been
re-instantiated, it will do nothing.  This means that it's safe to
cancel the delete work asynchronously.  This prevents the kind of
deadlock described above.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e0eaa9cf9fb6f..8ca89adf31a86 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1919,7 +1919,7 @@ bool gfs2_queue_delete_work(struct gfs2_glock *gl, unsigned long delay)
 
 void gfs2_cancel_delete_work(struct gfs2_glock *gl)
 {
-	if (cancel_delayed_work_sync(&gl->gl_delete)) {
+	if (cancel_delayed_work(&gl->gl_delete)) {
 		clear_bit(GLF_PENDING_DELETE, &gl->gl_flags);
 		gfs2_glock_put(gl);
 	}
-- 
2.33.0



