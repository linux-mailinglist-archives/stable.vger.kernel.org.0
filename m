Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200C41FE85D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgFRBJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbgFRBJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB4221D92;
        Thu, 18 Jun 2020 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442595;
        bh=LOq9WDryFQBQbvgVCaB1OKHLeNMRXnbcTegbuYzqQAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii3/40K02JKSed7s3eqJNmXksE8hBl7aS2hoX0UxhNZTvD6ryV+vNXr4LXAnZsbYT
         C0GZiGSLfAXdz/HFp+P2tkaVlBYIUNjdXtLk1YfG6SiccSgj8CalYUvAHLj1uqa8m1
         bsCL8SIfFZqkdTqfSN8r5JVurMnEOhLkI6l7W2yA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.7 084/388] cifs: set up next DFS target before generic_ip_connect()
Date:   Wed, 17 Jun 2020 21:03:01 -0400
Message-Id: <20200618010805.600873-84-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit aaa3aef34d3ab9499a5c7633823429f7a24e6dff ]

If we mount a very specific DFS link

    \\FS0.FOO.COM\dfs\link -> \FS0\share1, \FS1\share2

where its target list contains NB names ("FS0" & "FS1") rather than
FQDN ones ("FS0.FOO.COM" & "FS1.FOO.COM"), we end up connecting to
\FOO\share1 but server->hostname will have "FOO.COM".  The reason is
because both "FS0" and "FS0.FOO.COM" resolve to same IP address and
they share same TCP server connection, but "FS0.FOO.COM" was the first
hostname set -- which is OK.

However, if the echo thread timeouts and we still have a good
connection to "FS0", in cifs_reconnect()

    rc = generic_ip_connect(server) -> success
    if (rc) {
            ...
            reconn_inval_dfs_target(server, cifs_sb, &tgt_list,
	                            &tgt_it);
            ...
     }
     ...

it successfully reconnects to "FS0" server but does not set up next
DFS target - which should be the same target server "\FS0\share1" -
and server->hostname remains set to "FS0.FOO.COM" rather than "FS0",
as reconn_inval_dfs_target() would have it set to "FS0" if called
earlier.

Finally, in __smb2_reconnect(), the reconnect of tcons would fail
because tcon->ses->server->hostname (FS0.FOO.COM) does not match DFS
target's hostname (FS0).

Fix that by calling reconn_inval_dfs_target() before
generic_ip_connect() so server->hostname will get updated correctly
prior to reconnecting its tcons in __smb2_reconnect().

With "cifs: handle hostnames that resolve to same ip in failover"
patch

    - The above problem would not occur.
    - We could save an DNS query to find out that they both resolve to
      the same ip address.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 28268ed461b8..47b9fbb70bf5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -572,26 +572,26 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		try_to_freeze();
 
 		mutex_lock(&server->srv_mutex);
+#ifdef CONFIG_CIFS_DFS_UPCALL
 		/*
 		 * Set up next DFS target server (if any) for reconnect. If DFS
 		 * feature is disabled, then we will retry last server we
 		 * connected to before.
 		 */
+		reconn_inval_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
+#endif
+		rc = reconn_set_ipaddr(server);
+		if (rc) {
+			cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
+				 __func__, rc);
+		}
+
 		if (cifs_rdma_enabled(server))
 			rc = smbd_reconnect(server);
 		else
 			rc = generic_ip_connect(server);
 		if (rc) {
 			cifs_dbg(FYI, "reconnect error %d\n", rc);
-#ifdef CONFIG_CIFS_DFS_UPCALL
-			reconn_inval_dfs_target(server, cifs_sb, &tgt_list,
-						&tgt_it);
-#endif
-			rc = reconn_set_ipaddr(server);
-			if (rc) {
-				cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-					 __func__, rc);
-			}
 			mutex_unlock(&server->srv_mutex);
 			msleep(3000);
 		} else {
-- 
2.25.1

