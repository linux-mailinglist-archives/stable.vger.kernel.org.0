Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063AF1161FE
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLHN4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60310 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfLHNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0007fc-I8; Sun, 08 Dec 2019 13:54:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0002O7-Vo; Sun, 08 Dec 2019 13:54:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>,
        "Steve French" <stfrench@microsoft.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>
Date:   Sun, 08 Dec 2019 13:53:30 +0000
Message-ID: <lsq.1575813165.677152770@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 46/72] CIFS: Fix oplock handling for SMB 2.1+ protocols
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilov@microsoft.com>

commit a016e2794fc3a245a91946038dd8f34d65e53cc3 upstream.

There may be situations when a server negotiates SMB 2.1
protocol version or higher but responds to a CREATE request
with an oplock rather than a lease.

Currently the client doesn't handle such a case correctly:
when another CREATE comes in the server sends an oplock
break to the initial CREATE and the client doesn't send
an ack back due to a wrong caching level being set (READ
instead of RWH). Missing an oplock break ack makes the
server wait until the break times out which dramatically
increases the latency of the second CREATE.

Fix this by properly detecting oplocks when using SMB 2.1
protocol version and higher.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1006,6 +1006,11 @@ smb21_set_oplock_level(struct cifsInodeI
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
 
+	/* Check if the server granted an oplock rather than a lease */
+	if (oplock & SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+		return smb2_set_oplock_level(cinode, oplock, epoch,
+					     purge_cache);
+
 	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
 		new_oplock |= CIFS_CACHE_READ_FLG;
 		strcat(message, "R");

