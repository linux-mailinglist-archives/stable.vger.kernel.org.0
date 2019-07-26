Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6650F76A60
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfGZN6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387561AbfGZNko (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95BF222BEF;
        Fri, 26 Jul 2019 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148443;
        bh=2MXhqljQf7IMFqHmhVvDjqDPhscxIYuwMTCiLHA670Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSkyK/iocW2pj3MgCUwWeqbjYK6lvSnK1ToWFB8TaueyASCdnjwz/RemsLMC+2Jve
         eCw3fSuCAuEaqJWCwLbmvUoa1Hly9yH+8D5AlRdnr/ttfAdiJnTpHYnrIidVuZyag4
         YJZwghLA7ghrUstR2ek3LTx1zzGFC0b5+UGY9Dms=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 41/85] cifs: fix crash in cifs_dfs_do_automount
Date:   Fri, 26 Jul 2019 09:38:51 -0400
Message-Id: <20190726133936.11177-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit ce465bf94b70f03136171a62b607864f00093b19 ]

RHBZ: 1649907

Fix a crash that happens while attempting to mount a DFS referral from the same server on the root of a filesystem.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0872188ce3c6..e508613f09ff 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4459,11 +4459,13 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 					unsigned int xid,
 					struct cifs_tcon *tcon,
 					struct cifs_sb_info *cifs_sb,
-					char *full_path)
+					char *full_path,
+					int added_treename)
 {
 	int rc;
 	char *s;
 	char sep, tmp;
+	int skip = added_treename ? 1 : 0;
 
 	sep = CIFS_DIR_SEP(cifs_sb);
 	s = full_path;
@@ -4478,7 +4480,14 @@ cifs_are_all_path_components_accessible(struct TCP_Server_Info *server,
 		/* next separator */
 		while (*s && *s != sep)
 			s++;
-
+		/*
+		 * if the treename is added, we then have to skip the first
+		 * part within the separators
+		 */
+		if (skip) {
+			skip = 0;
+			continue;
+		}
 		/*
 		 * temporarily null-terminate the path at the end of
 		 * the current component
@@ -4526,8 +4535,7 @@ static int is_path_remote(struct cifs_sb_info *cifs_sb, struct smb_vol *vol,
 
 	if (rc != -EREMOTE) {
 		rc = cifs_are_all_path_components_accessible(server, xid, tcon,
-							     cifs_sb,
-							     full_path);
+			cifs_sb, full_path, tcon->Flags & SMB_SHARE_IS_IN_DFS);
 		if (rc != 0) {
 			cifs_dbg(VFS, "cannot query dirs between root and final path, "
 				 "enabling CIFS_MOUNT_USE_PREFIX_PATH\n");
-- 
2.20.1

