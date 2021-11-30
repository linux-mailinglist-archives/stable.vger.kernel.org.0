Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB934638C3
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbhK3PFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244555AbhK3PCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:02:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3D9C0619F8;
        Tue, 30 Nov 2021 06:53:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55EB6CE1A7B;
        Tue, 30 Nov 2021 14:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945B0C53FCF;
        Tue, 30 Nov 2021 14:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284014;
        bh=BVEFfntB/jq5JO8ybbq+Gh00U2lXAIUL6PqDDymVjTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGlyif/+MGVgzXOvA0fN/6HejTbKygxHlsdaC55P9Jx40ZTFGEnwTnY/eAESzb/UI
         cIs2+KZI4GCpnUE5JvVxDWFUzke/Gg3yr2LWZJH/lkKrXXsGMEhqhzLqi55Tguw8jg
         NY3KDxKU62u8PPr6wReKtvKstAV6ljmsk4pjAEKivpyeWDKDFNqSnR91MZgQEyakwr
         By7ASfUpUmvsF2N5FVwO9cpn6DzM1kGGVBC34XtoG60NHX+2BCT0adhXVMd0zXXjjm
         5zv9uHIkWm/+0gnI9MTSo9c/Oh8HU5e3DWIzpDUtpo5yjJqIomtQ7PQZgspIyf0hGk
         kYbp2j+QDdIcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 10/14] smb2: clarify rc initialization in smb2_reconnect
Date:   Tue, 30 Nov 2021 09:53:11 -0500
Message-Id: <20211130145317.946676-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
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
index 77a9aeaf2cb11..ae019210b26a6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -153,7 +153,7 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
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

