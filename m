Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB8654796F
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiFLJBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 05:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbiFLJBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 05:01:36 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B10D5F272
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 02:01:19 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 588EEC022; Sun, 12 Jun 2022 10:54:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655024055; bh=NGrM8aOLW3P+D4Rx7zur1lNPPJiOVKsmRGPxJVvnPDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKvYGL0B9tcmmAYPevuw7CIc9o+pAtZr6haB5YQiuGao/Alip1H1REebw+hGJpFUB
         jMMRfYcP72Fx5gR8FoFC/Zp7BUuxsaELWTG+Tb8mjbxQHxA7V9SQf/UToasJr9LWaX
         EQC91qVZtNkDh8Mr6zNBt/89VcQg2/P+j+VKv38XZ5lvU1CQTlARjFDP7ZMcXv7zrZ
         YVoLifracoufWYgUPjxoyCb+6fwqauLOdLNVpOfM86XK35la4JpbFEeP9nnglEcHGz
         yCfiJ5cL5AkIaRgQiPbF4as24QyRobtOCaceF79fZk/l5Q4ra6+EycUHyWhPUNAQyB
         ey8VNNC2Vji5w==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 626F2C01C;
        Sun, 12 Jun 2022 10:54:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655024054; bh=NGrM8aOLW3P+D4Rx7zur1lNPPJiOVKsmRGPxJVvnPDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8JxRLMQM5jMQ6KIrOGYGqQ2cTmfPMaiDXcawSxqCTrcOe9i7TXA1CdG6yvXQvFF1
         P+hMvGTH7qo4uK5y4HYLxqlMdIsqhpiL6/IBHfibkpMMVQEnlyz0qKoXVj6UMN1idn
         VnoSI0xhPBkzFp+PzsHljfmsQTzDGpPV5F7ot/rgvom9PbQzNM/BT5Tz6S1fx5t0yz
         6J558nM8AteTMbpWweNCRspQgPB8K/pMWqyEM5c1nS2NaJspr2kppuFK+a7lHIe/+K
         1D2f7tfU2UFzhQVXknU3b/A8P4/4Scq+Y1kbWyPHAAaHBQUevvgOONEyT+nOZFFSGE
         ISxArtJEqAsRA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id afea8486;
        Sun, 12 Jun 2022 08:54:08 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jianyong Wu <jianyong.wu@arm.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 02/06] 9p: fix fid refcount leak in v9fs_vfs_get_link
Date:   Sun, 12 Jun 2022 17:53:25 +0900
Message-Id: <20220612085330.1451496-3-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220612085330.1451496-1-asmadeus@codewreck.org>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

we check for protocol version later than required, after a fid has
been obtained. Just move the version check earlier.

Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
Cc: stable@vger.kernel.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 55367ecb9442..18c780ffd4b5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1250,15 +1250,15 @@ static const char *v9fs_vfs_get_link(struct dentry *dentry,
 		return ERR_PTR(-ECHILD);
 
 	v9ses = v9fs_dentry2v9ses(dentry);
-	fid = v9fs_fid_lookup(dentry);
+	if (!v9fs_proto_dotu(v9ses))
+		return ERR_PTR(-EBADF);
+
 	p9_debug(P9_DEBUG_VFS, "%pd\n", dentry);
+	fid = v9fs_fid_lookup(dentry);
 
 	if (IS_ERR(fid))
 		return ERR_CAST(fid);
 
-	if (!v9fs_proto_dotu(v9ses))
-		return ERR_PTR(-EBADF);
-
 	st = p9_client_stat(fid);
 	p9_client_clunk(fid);
 	if (IS_ERR(st))
-- 
2.35.1

