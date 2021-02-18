Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE931E97D
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 13:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhBRMCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 07:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhBRKJR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 05:09:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AF2964EAE;
        Thu, 18 Feb 2021 10:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613642905;
        bh=8SxgXKz9u6HmAwFtrrTD4BRI30X3TGHaW/TFJfOO8gQ=;
        h=From:To:Cc:Subject:Date:From;
        b=so1Mu3Ps1gU98Tha/caBqosnDrIX7k2o3twPwq8zBIb35MicXQyjEjEHTLof1Nbbu
         g2gUxff6idKQd5GfJ0+/eN9rs3eIu0a1P9WdLcaoASn5T+pO3tbvD84EwxVj7Rn9MD
         aBZa3CZ636KbzUMCKpK/uSG43oweom+/q4ZGRr30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Walle <michael@walle.cc>,
        Marc Zyngier <maz@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] debugfs: be more robust at handling improper input in debugfs_lookup()
Date:   Thu, 18 Feb 2021 11:08:17 +0100
Message-Id: <20210218100818.3622317-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

debugfs_lookup() doesn't like it if it is passed an illegal name
pointer, or if the filesystem isn't even initialized yet.  If either of
these happen, it will crash the system, so fix it up by properly testing
for valid input and that we are up and running before trying to find a
file in the filesystem.

Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marc Zyngier <maz@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 2fcf66473436..bbeb563cbe78 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -297,7 +297,7 @@ struct dentry *debugfs_lookup(const char *name, struct dentry *parent)
 {
 	struct dentry *dentry;
 
-	if (IS_ERR(parent))
+	if (!debugfs_initialized() || IS_ERR_OR_NULL(name) || IS_ERR(parent))
 		return NULL;
 
 	if (!parent)
-- 
2.30.1

