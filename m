Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08652F419
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfE3EfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbfE3DNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C72523D83;
        Thu, 30 May 2019 03:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185996;
        bh=RE8GP/AypUFDoLqbJz6sv5laRPxyjfqswOlola62AMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMQ5pW1JhnOUE1Ifq66j3r7FcPih6RCZUJsphtrti2rNj69UaBx1Z6C9v1rgPqiHf
         AC0tT9ZtYt/UgOPh+Ex4n8HlcPTLwBJ7/3lnwhbfSEXoiYgS6gIM8Kmwu9RPWJgV0Z
         0WcQPeDSuQCRW8oYpqG7gmo02CUCOKexm8SQ0VLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 044/346] afs: Fix getting the afs.fid xattr
Date:   Wed, 29 May 2019 20:01:57 -0700
Message-Id: <20190530030543.102221798@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a2f611a3dc317d8ea1c98ad6c54b911cf7f93193 ]

The AFS3 FID is three 32-bit unsigned numbers and is represented as three
up-to-8-hex-digit numbers separated by colons to the afs.fid xattr.
However, with the advent of support for YFS, the FID is now a 64-bit volume
number, a 96-bit vnode/inode number and a 32-bit uniquifier (as before).
Whilst the sprintf in afs_xattr_get_fid() has been partially updated (it
currently ignores the upper 32 bits of the 96-bit vnode number), the size
of the stack-based buffer has not been increased to match, thereby allowing
stack corruption to occur.

Fix this by increasing the buffer size appropriately and conditionally
including the upper part of the vnode number if it is non-zero.  The latter
requires the lower part to be zero-padded if the upper part is non-zero.

Fixes: 3b6492df4153 ("afs: Increase to 64-bit volume ID and 96-bit vnode ID for YFS")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xattr.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
index a2cdf25573e24..706801c6c4c4c 100644
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -69,11 +69,20 @@ static int afs_xattr_get_fid(const struct xattr_handler *handler,
 			     void *buffer, size_t size)
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
-	char text[8 + 1 + 8 + 1 + 8 + 1];
+	char text[16 + 1 + 24 + 1 + 8 + 1];
 	size_t len;
 
-	len = sprintf(text, "%llx:%llx:%x",
-		      vnode->fid.vid, vnode->fid.vnode, vnode->fid.unique);
+	/* The volume ID is 64-bit, the vnode ID is 96-bit and the
+	 * uniquifier is 32-bit.
+	 */
+	len = sprintf(text, "%llx:", vnode->fid.vid);
+	if (vnode->fid.vnode_hi)
+		len += sprintf(text + len, "%x%016llx",
+			       vnode->fid.vnode_hi, vnode->fid.vnode);
+	else
+		len += sprintf(text + len, "%llx", vnode->fid.vnode);
+	len += sprintf(text + len, ":%x", vnode->fid.unique);
+
 	if (size == 0)
 		return len;
 	if (len > size)
-- 
2.20.1



