Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D249616BE
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfGGTlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57692 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbfGGTiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:13 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzA-0006ke-7U; Sun, 07 Jul 2019 20:38:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005eN-Ke; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pavel Shilovsky" <piastryyy@gmail.com>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>,
        "Steve French" <stfrench@microsoft.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.413915482@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 100/129] CIFS: Fix read after write for files with
 read caching
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 6dfbd84684700cb58b34e8602c01c12f3d2595c8 upstream.

When we have a READ lease for a file and have just issued a write
operation to the server we need to purge the cache and set oplock/lease
level to NONE to avoid reading stale data. Currently we do that
only if a write operation succedeed thus not covering cases when
a request was sent to the server but a negative error code was
returned later for some other reasons (e.g. -EIOCBQUEUED or -EINTR).
Fix this by turning off caching regardless of the error code being
returned.

The patches fixes generic tests 075 and 112 from the xfs-tests.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2661,14 +2661,16 @@ cifs_strict_writev(struct kiocb *iocb, s
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
 	written = cifs_user_writev(iocb, from);
-	if (written > 0 && CIFS_CACHE_READ(cinode)) {
+	if (CIFS_CACHE_READ(cinode)) {
 		/*
-		 * Windows 7 server can delay breaking level2 oplock if a write
-		 * request comes - break it on the client to prevent reading
-		 * an old data.
+		 * We have read level caching and we have just sent a write
+		 * request to the server thus making data in the cache stale.
+		 * Zap the cache and set oplock/lease level to NONE to avoid
+		 * reading stale data from the cache. All subsequent read
+		 * operations will read new data from the server.
 		 */
 		cifs_zap_mapping(inode);
-		cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
+		cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=%p after write\n",
 			 inode);
 		cinode->oplock = 0;
 	}

