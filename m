Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C541747C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345178AbhIXNG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345916AbhIXNE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:04:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7ED61414;
        Fri, 24 Sep 2021 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488133;
        bh=FehYhLrYKIzLaICTnNDDLKTKGCU4uMlct6lxAVPPk4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrOdzExlioSljx206HEKeDDTTTe7wrkij8HMr/9s6aJN2ohLxHX3yK2G/o0J5ekXI
         MTl8G/6k5ia/bcgZIRh9ml5Z7AReTqHJjgEM011mVEXxoRMXR3VB/Viqy6Jqhu0e7X
         irhDHLCgf1e79kbzlFl5zjXWmE+xoV+U48lpcjWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/100] cifs: properly invalidate cached root handle when closing it
Date:   Fri, 24 Sep 2021 14:44:46 +0200
Message-Id: <20210924124344.730956476@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



