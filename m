Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA522A511C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgKCUiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729877AbgKCUiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C68223AB;
        Tue,  3 Nov 2020 20:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435886;
        bh=29d+8STEnezZ9ctvxTTxC2bfj7b6og+rhFvfXis6v2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6hgZeRfBA4x8bU910hkN8EgUg/Y8Y7nRgZTHWBgy85ejfov/shPLqPZ8b0RsVrqi
         T+Rws+286WvxVzQXtFTEv68yDhRWmb+4ls5WOsfyhFMnIirXr3tq1VOP2pKXN8mN5M
         1DfPi55bNG17L3M2c779AWcoAAS9FsG0YNbUSwqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 026/391] afs: Fix a use after free in afs_xattr_get_acl()
Date:   Tue,  3 Nov 2020 21:31:17 +0100
Message-Id: <20201103203349.592884635@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 248c944e2159de4868bef558feea40214aaf8464 ]

The "op" pointer is freed earlier when we call afs_put_operation().

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
index 84f3c4f575318..38884d6c57cdc 100644
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -85,7 +85,7 @@ static int afs_xattr_get_acl(const struct xattr_handler *handler,
 			if (acl->size <= size)
 				memcpy(buffer, acl->data, acl->size);
 			else
-				op->error = -ERANGE;
+				ret = -ERANGE;
 		}
 	}
 
-- 
2.27.0



