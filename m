Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113EB13F561
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388835AbgAPSzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729950AbgAPRHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8897821582;
        Thu, 16 Jan 2020 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194452;
        bh=9ffIg72vfAL9XOeRGbQvUSJeUprb7SNydkmcRf2SO2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XcO2XazkZ77b+AhN+4jzVvtfR5ZJ4h3cWJh9X/76aBXYTLBtCfQgGb50/lHAgomB
         vyRVb24VOqQtTSGa+uRFDyrXjJ6BhlNrHslsjHE0NaK0G07r9MeyB9r/uuB+YrUFPF
         HywCBsxzMjrk4YJMFUKqJQJlLV+UDpPcj+S492LA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 362/671] afs: Fix lock-wait/callback-break double locking
Date:   Thu, 16 Jan 2020 12:00:00 -0500
Message-Id: <20200116170509.12787-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c7226e407b6065d3bda8bd9dc627663d2c505ea3 ]

__afs_break_callback() holds vnode->lock around its call of
afs_lock_may_be_available() - which also takes that lock.

Fix this by not taking the lock in __afs_break_callback().

Also, there's no point checking the granted_locks and pending_locks queues;
it's sufficient to check lock_state, so move that check out of
afs_lock_may_be_available() into __afs_break_callback() to replace the
queue checks.

Fixes: e8d6c554126b ("AFS: implement file locking")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 8 +-------
 fs/afs/flock.c    | 3 ---
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 4ad701250299..97283b04fa6f 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -221,14 +221,8 @@ void afs_break_callback(struct afs_vnode *vnode)
 		vnode->cb_break++;
 		afs_clear_permits(vnode);
 
-		spin_lock(&vnode->lock);
-
-		_debug("break callback");
-
-		if (list_empty(&vnode->granted_locks) &&
-		    !list_empty(&vnode->pending_locks))
+		if (vnode->lock_state == AFS_VNODE_LOCK_WAITING_FOR_CB)
 			afs_lock_may_be_available(vnode);
-		spin_unlock(&vnode->lock);
 	}
 
 	write_sequnlock(&vnode->cb_lock);
diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index 075fe7f94810..457ce62e5c0f 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -39,9 +39,6 @@ void afs_lock_may_be_available(struct afs_vnode *vnode)
 {
 	_enter("{%x:%u}", vnode->fid.vid, vnode->fid.vnode);
 
-	if (vnode->lock_state != AFS_VNODE_LOCK_WAITING_FOR_CB)
-		return;
-
 	spin_lock(&vnode->lock);
 	if (vnode->lock_state == AFS_VNODE_LOCK_WAITING_FOR_CB)
 		afs_next_locker(vnode, 0);
-- 
2.20.1

