Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECCA148195
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391018AbgAXLVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391016AbgAXLVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:08 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1D8206D4;
        Fri, 24 Jan 2020 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864868;
        bh=JrqLKDLYLNi+x0503eUJhT4fVkYEoBvfduJguyc3OGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVN6O3eeYnZnX7xu4rKezsF2/GBWxOoSUMhGPakra/Uz9hydakdrTY0K88Bv15Rh4
         x2q3EkZmzGncdD0nGLBBBUF3JO2WaocLIpWhdbDWe4KifOagBDmq0Us4CXJjF/g4u0
         pdqHiOl2i5Ar8XNs9q8LXTNU543tg7UueNdmRyss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 376/639] afs: Dont invalidate callback if AFS_VNODE_DIR_VALID not set
Date:   Fri, 24 Jan 2020 10:29:06 +0100
Message-Id: <20200124093134.113405191@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 718fab2f151a1..e6f11da5461be 100644
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



