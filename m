Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7C546380D
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbhK3O5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49610 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbhK3Ozs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03788B81A62;
        Tue, 30 Nov 2021 14:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD06FC8D186;
        Tue, 30 Nov 2021 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283946;
        bh=IhfbY0YSU+daeOm17P9EDHIdDnraEHpXLX63bYEEBz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPYBB1E1hkBK+KvJLv9xkayC4v2yDpMiI8mWHEtOL4OYXSBx3h/PfOD6xAlx08oWG
         IKMDYGOVvIhml+B8vo31GDzLlmnE07AlnPUQ/3uUsYD7y+KXw4fXc8DwDM/hQH8Zzj
         kH+Vx2u7OzHN297BUrNpGybCZVbxQ8MViI5mnxxN3rQEtu7WY/ecSRuHrt3hbSMITx
         S5Ce7OhX9jWlJeyc53ccMbXJUxeGacPouwOswEukuQQ5w4UhVUPohstL9jXKg+iJBp
         ePFYmGnZeUvBVoPKW3naqxOG3lh5q3DfrFGF69HeC7p0K1rgWzsz7ztv37CUpSBshm
         CK+c31LbpiGsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 15/25] smb2: clarify rc initialization in smb2_reconnect
Date:   Tue, 30 Nov 2021 09:51:45 -0500
Message-Id: <20211130145156.946083-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 350f4a562e1ffc2e4869e3083dc9b0ec4bca6c3a ]

It is clearer to initialize rc at the beginning of the function.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e068f82ffeddf..da43365aa1420 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -238,7 +238,7 @@ static inline int __smb2_reconnect(const struct nls_table *nlsc,
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
-	int rc;
+	int rc = 0;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
-- 
2.33.0

