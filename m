Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1992013F55D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388689AbgAPRHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388697AbgAPRHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D7820663;
        Thu, 16 Jan 2020 17:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194451;
        bh=IaqOLNm/i0yLc3Jpw9UIY1y+vn8BKJAc9Js6nsMGAnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHnU4ku9U560EOzCo3C39yibbBSRpxNCriJ9t9O2WljHTbFxPbsMPM/kZ2vRSAYEh
         2h/wXPiPCt8/VuBvJ+fVdQKVujXJcWNllD9Ql8rc9bySUPIp4wnXX4MS/S5bnQnB1b
         dz23RhC5/7ro5SiIscEZqLdW0QNDSSUWlJBqwFmM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 361/671] afs: Don't invalidate callback if AFS_VNODE_DIR_VALID not set
Date:   Thu, 16 Jan 2020 11:59:59 -0500
Message-Id: <20200116170509.12787-98-sashal@kernel.org>
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

[ Upstream commit d9052dda8a39069312218f913d22d99c48d90004 ]

Don't invalidate the callback promise on a directory if the
AFS_VNODE_DIR_VALID flag is not set (which indicates that the directory
contents are invalid, due to edit failure, callback break, page reclaim).

The directory will be reloaded next time the directory is accessed, so
clearing the callback flag at this point may race with a reload of the
directory and cancel it's recorded callback promise.

Fixes: f3ddee8dc4e2 ("afs: Fix directory handling")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 718fab2f151a..e6f11da5461b 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -398,12 +398,9 @@ int afs_validate(struct afs_vnode *vnode, struct key *key)
 			vnode->cb_s_break = vnode->cb_interest->server->cb_s_break;
 			vnode->cb_v_break = vnode->volume->cb_v_break;
 			valid = false;
-		} else if (vnode->status.type == AFS_FTYPE_DIR &&
-			   (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags) ||
-			    vnode->cb_expires_at - 10 <= now)) {
+		} else if (test_bit(AFS_VNODE_ZAP_DATA, &vnode->flags)) {
 			valid = false;
-		} else if (test_bit(AFS_VNODE_ZAP_DATA, &vnode->flags) ||
-			   vnode->cb_expires_at - 10 <= now) {
+		} else if (vnode->cb_expires_at - 10 <= now) {
 			valid = false;
 		} else {
 			valid = true;
-- 
2.20.1

