Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5689A1D4F25
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 15:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgEONUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 09:20:21 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:55990 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgEONUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 09:20:21 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id 04FDKARu002266
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 15:20:10 +0200
Received: from localhost.localdomain ([167.87.8.125])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 04FDK8Di013102;
        Fri, 15 May 2020 15:20:09 +0200
From:   Henning Schild <henning.schild@siemens.com>
To:     stable@vger.kernel.org
Cc:     Greg KH <greg@kroah.com>,
        Henning Schild <henning.schild@siemens.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.9.y] cifs: Fix a race condition with cifs_echo_request
Date:   Fri, 15 May 2020 15:20:05 +0200
Message-Id: <20200515132005.17949-1-henning.schild@siemens.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515125748.GA1936050@kroah.com>
References: <20200515125748.GA1936050@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henning Schild <henning.schild@siemens.com>

commit f2caf901c1b7ce65f9e6aef4217e3241039db768 upstream

There is a race condition with how we send (or supress and don't send)
smb echos that will cause the client to incorrectly think the
server is unresponsive and thus needs to be reconnected.

Summary of the race condition:
 1) Daisy chaining scheduling creates a gap.
 2) If traffic comes unfortunate shortly after
    the last echo, the planned echo is suppressed.
 3) Due to the gap, the next echo transmission is delayed
    until after the timeout, which is set hard to twice
    the echo interval.

This is fixed by changing the timeouts from 2 to three times the echo interval.

Detailed description of the bug: https://lutz.donnerhacke.de/eng/Blog/Groundhog-Day-with-SMB-remount

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Henning Schild <henning.schild@siemens.com>
---
 fs/cifs/connect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c018d161735c..f54277049512 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -551,10 +551,10 @@ static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
 	/*
-	 * We need to wait 2 echo intervals to make sure we handle such
+	 * We need to wait 3 echo intervals to make sure we handle such
 	 * situations right:
 	 * 1s  client sends a normal SMB request
-	 * 2s  client gets a response
+	 * 3s  client gets a response
 	 * 30s echo workqueue job pops, and decides we got a response recently
 	 *     and don't need to send another
 	 * ...
@@ -562,9 +562,9 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 *     a response in >60s.
 	 */
 	if (server->tcpStatus == CifsGood &&
-	    time_after(jiffies, server->lstrp + 2 * server->echo_interval)) {
+	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
 		cifs_dbg(VFS, "Server %s has not responded in %lu seconds. Reconnecting...\n",
-			 server->hostname, (2 * server->echo_interval) / HZ);
+			 server->hostname, (3 * server->echo_interval) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
-- 
2.26.2

