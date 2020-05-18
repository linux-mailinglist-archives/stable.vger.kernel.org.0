Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB74B1D86C5
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgERRni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgERRng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89B0920849;
        Mon, 18 May 2020 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823816;
        bh=bd0Z/Xy/yKAVxb3vsoj/gDqfJK1l6k8boULgRIH4QG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYJpCFq8td3QcVED04wANDOAPeMp9DR1cnVrxXF3/Zf8iHMbDWt5NzTWtPNnf4cir
         8CoQK3TPidP6uWrneEMn5V/jIV7nYqgBV+DdchRVwCXluAYyA7bfbhNsPTyW0XTbzz
         bC1rIwU/ONVxCZwq3KnbxLjnvT3ES+9KI7v5UpCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Cabrero <scabrero@suse.de>,
        =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 47/90] cifs: Check for timeout on Negotiate stage
Date:   Mon, 18 May 2020 19:36:25 +0200
Message-Id: <20200518173500.787954575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Cabrero <scabrero@suse.de>

[ Upstream commit 76e752701a8af4404bbd9c45723f7cbd6e4a251e ]

Some servers seem to accept connections while booting but never send
the SMBNegotiate response neither close the connection, causing all
processes accessing the share hang on uninterruptible sleep state.

This happens when the cifs_demultiplex_thread detects the server is
unresponsive so releases the socket and start trying to reconnect.
At some point, the faulty server will accept the socket and the TCP
status will be set to NeedNegotiate. The first issued command accessing
the share will start the negotiation (pid 5828 below), but the response
will never arrive so other commands will be blocked waiting on the mutex
(pid 55352).

This patch checks for unresponsive servers also on the negotiate stage
releasing the socket and reconnecting if the response is not received
and checking again the tcp state when the mutex is acquired.

PID: 55352  TASK: ffff880fd6cc02c0  CPU: 0   COMMAND: "ls"
 #0 [ffff880fd9add9f0] schedule at ffffffff81467eb9
 #1 [ffff880fd9addb38] __mutex_lock_slowpath at ffffffff81468fe0
 #2 [ffff880fd9addba8] mutex_lock at ffffffff81468b1a
 #3 [ffff880fd9addbc0] cifs_reconnect_tcon at ffffffffa042f905 [cifs]
 #4 [ffff880fd9addc60] smb_init at ffffffffa042faeb [cifs]
 #5 [ffff880fd9addca0] CIFSSMBQPathInfo at ffffffffa04360b5 [cifs]
 ....

Which is waiting a mutex owned by:

PID: 5828   TASK: ffff880fcc55e400  CPU: 0   COMMAND: "xxxx"
 #0 [ffff880fbfdc19b8] schedule at ffffffff81467eb9
 #1 [ffff880fbfdc1b00] wait_for_response at ffffffffa044f96d [cifs]
 #2 [ffff880fbfdc1b60] SendReceive at ffffffffa04505ce [cifs]
 #3 [ffff880fbfdc1bb0] CIFSSMBNegotiate at ffffffffa0438d79 [cifs]
 #4 [ffff880fbfdc1c50] cifs_negotiate_protocol at ffffffffa043b383 [cifs]
 #5 [ffff880fbfdc1c80] cifs_reconnect_tcon at ffffffffa042f911 [cifs]
 #6 [ffff880fbfdc1d20] smb_init at ffffffffa042faeb [cifs]
 #7 [ffff880fbfdc1d60] CIFSSMBQFSInfo at ffffffffa0434eb0 [cifs]
 ....

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
Reviewed-by: Aurélien Aptel <aaptel@suse.de>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 12 ++++++++++++
 fs/cifs/connect.c |  3 ++-
 fs/cifs/smb2pdu.c | 12 ++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 741b83c59a306..568abcd6d0dd3 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -184,6 +184,18 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * reconnect the same SMB session
 	 */
 	mutex_lock(&ses->session_mutex);
+
+	/*
+	 * Recheck after acquire mutex. If another thread is negotiating
+	 * and the server never sends an answer the socket will be closed
+	 * and tcpStatus set to reconnect.
+	 */
+	if (server->tcpStatus == CifsNeedReconnect) {
+		rc = -EHOSTDOWN;
+		mutex_unlock(&ses->session_mutex);
+		goto out;
+	}
+
 	rc = cifs_negotiate_protocol(0, ses);
 	if (rc == 0 && ses->need_reconnect)
 		rc = cifs_setup_session(0, ses, nls_codepage);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c018d161735c4..37c8cac86431f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -561,7 +561,8 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
 	 *     a response in >60s.
 	 */
-	if (server->tcpStatus == CifsGood &&
+	if ((server->tcpStatus == CifsGood ||
+	    server->tcpStatus == CifsNeedNegotiate) &&
 	    time_after(jiffies, server->lstrp + 2 * server->echo_interval)) {
 		cifs_dbg(VFS, "Server %s has not responded in %lu seconds. Reconnecting...\n",
 			 server->hostname, (2 * server->echo_interval) / HZ);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e8dc28dbe563e..0a23b6002ff12 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -246,6 +246,18 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	 * the same SMB session
 	 */
 	mutex_lock(&tcon->ses->session_mutex);
+
+	/*
+	 * Recheck after acquire mutex. If another thread is negotiating
+	 * and the server never sends an answer the socket will be closed
+	 * and tcpStatus set to reconnect.
+	 */
+	if (server->tcpStatus == CifsNeedReconnect) {
+		rc = -EHOSTDOWN;
+		mutex_unlock(&tcon->ses->session_mutex);
+		goto out;
+	}
+
 	rc = cifs_negotiate_protocol(0, tcon->ses);
 	if (!rc && tcon->ses->need_reconnect) {
 		rc = cifs_setup_session(0, tcon->ses, nls_codepage);
-- 
2.20.1



