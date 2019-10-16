Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5AD9C00
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 22:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437275AbfJPUwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 16:52:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58740 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437248AbfJPUwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 16:52:30 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 162A520B711D; Wed, 16 Oct 2019 13:52:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 162A520B711D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259150;
        bh=kg9qGUDQcR5JB1IHvCLmx3ZDZ+TrLbgdykBbU9w7tdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=DmTeNs6KJM8TsNqZY3tBn7BUSFj/UBSqLPISDnWJGYtDxqW+exlE5EvnzcesfLF1S
         8FVov1VK7Yp0J0X/M4Yjd4mAvT3+rjcTndBR61APY+nBtbPsG1JZRv0peEjbLGyplh
         zRrfZYHLaedXJuhSKBn/qFmPE0Dz5EAyZlm2FB28=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 4/7] cifs: smbd: Add messages on RDMA session destroy and reconnection
Date:   Wed, 16 Oct 2019 13:51:53 -0700
Message-Id: <1571259116-102015-5-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Long Li <longli@microsoft.com>

Log these activities to help production support.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/smbdirect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index d41a9345f90d..227ef51c0712 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1476,6 +1476,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	info->transport_status = SMBD_DESTROYED;
 
 	destroy_workqueue(info->workqueue);
+	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
 }
 
@@ -1505,8 +1506,9 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "creating rdma session\n");
 	server->smbd_conn = smbd_get_connection(
 		server, (struct sockaddr *) &server->dstaddr);
-	log_rdma_event(INFO, "created rdma session info=%p\n",
-		server->smbd_conn);
+
+	if (server->smbd_conn)
+		cifs_dbg(VFS, "RDMA transport re-established\n");
 
 	return server->smbd_conn ? 0 : -ENOENT;
 }
-- 
2.17.1

