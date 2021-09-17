Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E896640EF76
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhIQCgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243082AbhIQCfx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2364B61139;
        Fri, 17 Sep 2021 02:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846071;
        bh=MXoU39SgCkMTrmTI3ONBlIn6o3fNAP/MsVmu1zC/SEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3+mVtznC2zDQ6pkAqJGpvrx29Sb2EHbHw7oneghfL4XJcDaF/70oxnJwHfhLsJey
         I4xKvrNKJ75X8BfECXqHiUxQ/x5bCqgUcBA3pPdmgIA5luRu4vcfMcVGl0z2O3ViLb
         EPnNXk1Th0b+G852nhzFvganI+/5sV5a9tIGaTNzMVz23+/CcprVGTcV3BOOPvTl7H
         WINoyg+kUyANl3/5cxetkQLMJwNVqdlZjy+XZh1R9BRhvZDwSDYkB+ucFEQY8I+dz4
         8GlRrHNTUXAp9zsNcCC8P6vfYL+5YfWIZHFLf4ZsNoxriF41Eq6tDqSx8VLChRag+c
         1sUxSp7ceBosA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org
Subject: [PATCH AUTOSEL 5.14 20/21] cifs: properly invalidate cached root handle when closing it
Date:   Thu, 16 Sep 2021 22:33:14 -0400
Message-Id: <20210917023315.816225-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 9351590f51cdda49d0265932a37f099950998504 ]

Cached root file was not being completely invalidated sometimes.

Reproducing:
- With a DFS share with 2 targets, one disabled and one enabled
- start some I/O on the mount
  # while true; do ls /mnt/dfs; done
- at the same time, disable the enabled target and enable the disabled
  one
- wait for DFS cache to expire
- on reconnect, the previous cached root handle should be invalid, but
  open_cached_dir_by_dentry() will still try to use it, but throws a
  use-after-free warning (kref_get())

Make smb2_close_cached_fid() invalidate all fields every time, but only
send an SMB2_close() when the entry is still valid.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2dfd0d8297eb..1b9de38a136a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -689,13 +689,19 @@ smb2_close_cached_fid(struct kref *ref)
 		cifs_dbg(FYI, "clear cached root file handle\n");
 		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
 			   cfid->fid->volatile_fid);
-		cfid->is_valid = false;
-		cfid->file_all_info_is_valid = false;
-		cfid->has_lease = false;
-		if (cfid->dentry) {
-			dput(cfid->dentry);
-			cfid->dentry = NULL;
-		}
+	}
+
+	/*
+	 * We only check validity above to send SMB2_close,
+	 * but we still need to invalidate these entries
+	 * when this function is called
+	 */
+	cfid->is_valid = false;
+	cfid->file_all_info_is_valid = false;
+	cfid->has_lease = false;
+	if (cfid->dentry) {
+		dput(cfid->dentry);
+		cfid->dentry = NULL;
 	}
 }
 
-- 
2.30.2

