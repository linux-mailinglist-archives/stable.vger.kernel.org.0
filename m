Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2C205EB1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbgFWUZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387665AbgFWUZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:25:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A651D20723;
        Tue, 23 Jun 2020 20:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943902;
        bh=IggdwPrKJgKSf2XHqFk4mLCLH7gRmrm2RvKkfmimOlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idj3FI3YQEYBnXlYV2tSrwwwmxIdeQTltD2krO81/nxC4tbPQIxGF4dEEvKQfL509
         pqmpGKCSPD3HcIYrA9UTlWFxW6911+CrmGR1Kogb7te+WMcZVvu9GujF6XsD4CnJq7
         mOh3iSnYeSvGOkpT+k6Sn04iAxNTzJceqdtQbZD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/314] cifs: set up next DFS target before generic_ip_connect()
Date:   Tue, 23 Jun 2020 21:54:20 +0200
Message-Id: <20200623195341.934366058@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 721b2560caa74..947c4aad5d6a4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -614,26 +614,26 @@ cifs_reconnect(struct TCP_Server_Info *server)
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



