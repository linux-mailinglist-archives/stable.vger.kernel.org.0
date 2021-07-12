Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD893C5266
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346084AbhGLHpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245601AbhGLHne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9138661179;
        Mon, 12 Jul 2021 07:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075618;
        bh=U/Wk3xklJzSoSp+qrIP77EGaiACD/fE7Vvq6NiNz9cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRyfaVMX4NphlfwVgAAgmie0S+ua7FEgAYMfZTeuufT1ltWBjbCCCyeCTcUtaOYgz
         rKKhMYB2gG8O69Op+sX5ziDbf2pjFg6PTWLOMu8ExMXWsUeK7mwH7lEE4Bp1ifFhVU
         cP2jA/Iq9eaxesF3z9RbCZ8AqLeSG4ySeW4Ibltk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 249/800] cifs: fix SMB1 error path in cifs_get_file_info_unix
Date:   Mon, 12 Jul 2021 08:04:32 +0200
Message-Id: <20210712060948.826669782@linuxfoundation.org>
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

[ Upstream commit e39df24169a2ceb0d359eb3a05ff982711f2eb32 ]

We were trying to fill in uninitialized file attributes in the error case.

Addresses-Coverity: 139689 ("Uninitialized variables")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1dfa57982522..f60f068d33e8 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -367,9 +367,12 @@ cifs_get_file_info_unix(struct file *filp)
 	} else if (rc == -EREMOTE) {
 		cifs_create_dfs_fattr(&fattr, inode->i_sb);
 		rc = 0;
-	}
+	} else
+		goto cifs_gfiunix_out;
 
 	rc = cifs_fattr_to_inode(inode, &fattr);
+
+cifs_gfiunix_out:
 	free_xid(xid);
 	return rc;
 }
-- 
2.30.2



