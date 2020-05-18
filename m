Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C661F1D8072
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgERRjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbgERRjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CE4F2083E;
        Mon, 18 May 2020 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823590;
        bh=zZkOHLlY0C4rzlyING27MznEU+bpSrDuBYLW1QwahNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7C9j1xblen4afFFbUZ1HXPgwfRDwbN85anoy8EmLvxE1ImDRCd3HHQEOJJwo0hMt
         en0gbPJGnVnAaJe9GkyFuW+cNNbx/1n2M4pnE/5IKn8eRpxDzwvSpVSPhToUGbguVX
         m7bAseA5bGH+ZqEU/s9x7ud2iFMugUDJficz9jDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 42/86] cifs: Fix a race condition with cifs_echo_request
Date:   Mon, 18 May 2020 19:36:13 +0200
Message-Id: <20200518173458.913521023@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit f2caf901c1b7ce65f9e6aef4217e3241039db768 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7022750cae2fd..21ddfd77966eb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -548,10 +548,10 @@ static bool
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
@@ -560,9 +560,9 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 */
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
-	    time_after(jiffies, server->lstrp + 2 * SMB_ECHO_INTERVAL)) {
+	    time_after(jiffies, server->lstrp + 3 * SMB_ECHO_INTERVAL)) {
 		cifs_dbg(VFS, "Server %s has not responded in %d seconds. Reconnecting...\n",
-			 server->hostname, (2 * SMB_ECHO_INTERVAL) / HZ);
+			 server->hostname, (3 * SMB_ECHO_INTERVAL) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
-- 
2.20.1



