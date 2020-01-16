Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926EC13F560
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388703AbgAPRHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388893AbgAPRHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D79B24679;
        Thu, 16 Jan 2020 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194453;
        bh=eiozgSvE0P6s9NMNgVO9mWYQC/RhfGeUjT37ObuwHHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSsw2DKDUjn1Q0RaxXGrVACyeJsqu5aVyzCUMYau2736JUnPJIzOsV/uDluIZ6gz1
         +3aUwsDiS5+TScvU/LEUTAmPy6NBMQPky+TwoGJi401I/e97aMYS0yLrsYkUsyMtz4
         tDW0O72DUPUjIe961O+U7Sb56p1auBKKycCPn71Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 363/671] afs: Fix double inc of vnode->cb_break
Date:   Thu, 16 Jan 2020 12:00:01 -0500
Message-Id: <20200116170509.12787-100-sashal@kernel.org>
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

[ Upstream commit fd711586bb7d63f257da5eff234e68c446ac35ea ]

When __afs_break_callback() clears the CB_PROMISED flag, it increments
vnode->cb_break to trigger a future refetch of the status and callback -
however it also calls afs_clear_permits(), which also increments
vnode->cb_break.

Fix this by removing the increment from afs_clear_permits().

Whilst we're at it, fix the conditional call to afs_put_permits() as the
function checks to see if the argument is NULL, so the check is redundant.

Fixes: be080a6f43c4 ("afs: Overhaul permit caching");
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/security.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/afs/security.c b/fs/afs/security.c
index 81dfedb7879f..66042b432baa 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -87,11 +87,9 @@ void afs_clear_permits(struct afs_vnode *vnode)
 	permits = rcu_dereference_protected(vnode->permit_cache,
 					    lockdep_is_held(&vnode->lock));
 	RCU_INIT_POINTER(vnode->permit_cache, NULL);
-	vnode->cb_break++;
 	spin_unlock(&vnode->lock);
 
-	if (permits)
-		afs_put_permits(permits);
+	afs_put_permits(permits);
 }
 
 /*
-- 
2.20.1

