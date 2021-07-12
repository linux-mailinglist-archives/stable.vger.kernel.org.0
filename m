Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219273C4D84
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242621AbhGLHNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242341AbhGLHGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53DB961182;
        Mon, 12 Jul 2021 07:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073427;
        bh=JUU/J6hxCQLqqZUB6VdJNrCq1pm1bQZDPZFxWYJzass=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOkNkIN7R4PMwoky8rZ+eZ48M/XCu8OLTKQ9z90R2YGIj/4QYu6tLg9mvjaeKnamI
         3+DWbyJdfWOcAx+wgpcRWM90BfwMHuDKw+xn6aCKzKGv7HqF5zPWYfYFV5LJjlDgZf
         oW37XnJoyxhaJ9uRBD0+gfKPyxfNrKxX+XUnu5qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 238/700] smb3: fix possible access to uninitialized pointer to DACL
Date:   Mon, 12 Jul 2021 08:05:21 +0200
Message-Id: <20210712061000.604523470@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit a5628263a9f8d47d9a1548fe9d5d75ba4423a735 ]

dacl_ptr can be null so we must check for it everywhere it is
used in build_sec_desc.

Addresses-Coverity: 1475598 ("Explicit null dereference")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d178cf85e926..b80b6ba232aa 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1310,7 +1310,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 		ndacl_ptr = (struct cifs_acl *)((char *)pnntsd + ndacloffset);
 		ndacl_ptr->revision =
 			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
-		ndacl_ptr->num_aces = dacl_ptr->num_aces;
+		ndacl_ptr->num_aces = dacl_ptr ? dacl_ptr->num_aces : 0;
 
 		if (uid_valid(uid)) { /* chown */
 			uid_t id;
-- 
2.30.2



