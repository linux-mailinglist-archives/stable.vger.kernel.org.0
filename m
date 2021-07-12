Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8503C5234
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349953AbhGLHpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349197AbhGLHln (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6A4610D1;
        Mon, 12 Jul 2021 07:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075534;
        bh=yZ4l5Fiz8Q2jhqFawudcOpO7DnpOWy1/I8cMjkE1W5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywohz9SYwIAhtHeNqnNnV1NTi+YrBqM+wRs7Mw8hcCCQOgO61ronP1wACLR309OIE
         ZKtH1MTjleLkAwHdmrefpkyhZ85VZOlw3qPZbMtz6Ni3u1kjBFtddVTX9UicesVr01
         fkPYJIKES1IVKX4t2q9zjQfkdshAnq77BE+V0R20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 256/800] smb3: fix possible access to uninitialized pointer to DACL
Date:   Mon, 12 Jul 2021 08:04:39 +0200
Message-Id: <20210712060950.259509464@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 784407f9280f..a18dee071fcd 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1308,7 +1308,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 		ndacl_ptr = (struct cifs_acl *)((char *)pnntsd + ndacloffset);
 		ndacl_ptr->revision =
 			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
-		ndacl_ptr->num_aces = dacl_ptr->num_aces;
+		ndacl_ptr->num_aces = dacl_ptr ? dacl_ptr->num_aces : 0;
 
 		if (uid_valid(uid)) { /* chown */
 			uid_t id;
-- 
2.30.2



