Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370BE15B05
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbfEGFvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbfEGFj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ACF0216F4;
        Tue,  7 May 2019 05:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207598;
        bh=NokzQTe48QPHBQvyu/mp0gTTSkMF3B3nNkgwopDX6Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcA2Wmd2psZlcHLkUFyugE5AmFHIDHw0lC14TUe/LdMTo0a148NZuajvdVhbxtJgJ
         AycBnkM8VdGUFKmfkOxQqmNBs6p2xa3D4z+A47VM9TitdV2cZcUGbMytTW9bzAgdN1
         Ug+AFgdsjPrG8oiVbIj99he8kHiT3KqlfjysWf78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 47/95] fuse: fix possibly missed wake-up after abort
Date:   Tue,  7 May 2019 01:37:36 -0400
Message-Id: <20190507053826.31622-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 2d84a2d19b6150c6dbac1e6ebad9c82e4c123772 ]

In current fuse_drop_waiting() implementation it's possible that
fuse_wait_aborted() will not be woken up in the unlikely case that
fuse_abort_conn() + fuse_wait_aborted() runs in between checking
fc->connected and calling atomic_dec(&fc->num_waiting).

Do the atomic_dec_and_test() unconditionally, which also provides the
necessary barrier against reordering with the fc->connected check.

The explicit smp_mb() in fuse_wait_aborted() is not actually needed, since
the spin_unlock() in fuse_abort_conn() provides the necessary RELEASE
barrier after resetting fc->connected.  However, this is not a performance
sensitive path, and adding the explicit barrier makes it easier to
document.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: b8f95e5d13f5 ("fuse: umount should wait for all requests")
Cc: <stable@vger.kernel.org> #v4.19
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 fs/fuse/dev.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 63fd33383413..af78ceead2dc 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -133,9 +133,13 @@ static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
 
 static void fuse_drop_waiting(struct fuse_conn *fc)
 {
-	if (fc->connected) {
-		atomic_dec(&fc->num_waiting);
-	} else if (atomic_dec_and_test(&fc->num_waiting)) {
+	/*
+	 * lockess check of fc->connected is okay, because atomic_dec_and_test()
+	 * provides a memory barrier mached with the one in fuse_wait_aborted()
+	 * to ensure no wake-up is missed.
+	 */
+	if (atomic_dec_and_test(&fc->num_waiting) &&
+	    !READ_ONCE(fc->connected)) {
 		/* wake up aborters */
 		wake_up_all(&fc->blocked_waitq);
 	}
@@ -2170,6 +2174,8 @@ EXPORT_SYMBOL_GPL(fuse_abort_conn);
 
 void fuse_wait_aborted(struct fuse_conn *fc)
 {
+	/* matches implicit memory barrier in fuse_drop_waiting() */
+	smp_mb();
 	wait_event(fc->blocked_waitq, atomic_read(&fc->num_waiting) == 0);
 }
 
-- 
2.20.1

