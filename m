Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073064524B
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfFNDCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:02:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbfFNDCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 23:02:40 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A6C23086202;
        Fri, 14 Jun 2019 03:02:40 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D4DE5ED44;
        Fri, 14 Jun 2019 03:02:39 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix GlobalMid_Lock bug in cifs_reconnect
Date:   Fri, 14 Jun 2019 13:02:29 +1000
Message-Id: <20190614030229.22375-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 14 Jun 2019 03:02:40 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can not hold the GlobalMid_Lock spinlock during the
dfs processing in cifs_reconnect since it invokes things that may sleep
and thus trigger :

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:23

Thus we need to drop the spinlock during this code block.

RHBZ: 1716743

Cc: stable@vger.kernel.org
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8c4121da624e..8dd6637a3cbb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -476,6 +476,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_lock(&GlobalMid_Lock);
 	server->nr_targets = 1;
 #ifdef CONFIG_CIFS_DFS_UPCALL
+	spin_unlock(&GlobalMid_Lock);
 	cifs_sb = find_super_by_tcp(server);
 	if (IS_ERR(cifs_sb)) {
 		rc = PTR_ERR(cifs_sb);
@@ -493,6 +494,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	}
 	cifs_dbg(FYI, "%s: will retry %d target(s)\n", __func__,
 		 server->nr_targets);
+	spin_lock(&GlobalMid_Lock);
 #endif
 	if (server->tcpStatus == CifsExiting) {
 		/* the demux thread will exit normally
-- 
2.13.6

