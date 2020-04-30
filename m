Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F091BFCE8
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgD3Nv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbgD3Nv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14D920873;
        Thu, 30 Apr 2020 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254715;
        bh=b2QdKOeAuXxVphJVniePs7dMgcY5GW7kcKW3nlDsHuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Puz9FCESQ1C2Wav2lcfWu+xLcVl8Ohw2i3tnmuHoUBpRGV3ZTy8M3uyr93EZ/l3WH
         ie1fwK7mNTEZ1TcQ7+A2IgsHun9j173VSiGbFHG437gJZfucQoEOj1QjwXMULlfFYG
         8a5CHlZbgWn41mMLeMFp+hlEDL8FkbeKeZIITvcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.6 63/79] cifs: do not share tcons with DFS
Date:   Thu, 30 Apr 2020 09:50:27 -0400
Message-Id: <20200430135043.19851-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit 65303de829dd6d291a4947c1a31de31896f8a060 ]

This disables tcon re-use for DFS shares.

tcon->dfs_path stores the path that the tcon should connect to when
doing failing over.

If that tcon is used multiple times e.g. 2 mounts using it with
different prefixpath, each will need a different dfs_path but there is
only one tcon. The other solution would be to split the tcon in 2
tcons during failover but that is much harder.

tcons could not be shared with DFS in cifs.ko because in a
DFS namespace like:

          //domain/dfsroot -> /serverA/dfsroot, /serverB/dfsroot

          //serverA/dfsroot/link -> /serverA/target1/aa/bb

          //serverA/dfsroot/link2 -> /serverA/target1/cc/dd

you can see that link and link2 are two DFS links that both resolve to
the same target share (/serverA/target1), so cifs.ko will only contain a
single tcon for both link and link2.

The problem with that is, if we (auto)mount "link" and "link2", cifs.ko
will only contain a single tcon for both DFS links so we couldn't
perform failover or refresh the DFS cache for both links because
tcon->dfs_path was set to either "link" or "link2", but not both --
which is wrong.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d4a23b48e24d8..9c614d6916c2d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3419,6 +3419,10 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+		if (tcon->dfs_path)
+			continue;
+#endif
 		if (!match_tcon(tcon, volume_info))
 			continue;
 		++tcon->tc_count;
-- 
2.20.1

