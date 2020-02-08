Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB05156641
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgBHSdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:33:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34430 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727928AbgBHS3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:47 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-0003iT-3A; Sat, 08 Feb 2020 18:29:41 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-000CVG-Rj; Sat, 08 Feb 2020 18:29:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pavel Shilovsky" <pshilov@microsoft.com>,
        "Steve French" <stfrench@microsoft.com>
Date:   Sat, 08 Feb 2020 18:20:59 +0000
Message-ID: <lsq.1581185941.604009957@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 120/148] CIFS: Fix SMB2 oplock break processing
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilov@microsoft.com>

commit fa9c2362497fbd64788063288dc4e74daf977ebb upstream.

Even when mounting modern protocol version the server may be
configured without supporting SMB2.1 leases and the client
uses SMB2 oplock to optimize IO performance through local caching.

However there is a problem in oplock break handling that leads
to missing a break notification on the client who has a file
opened. It latter causes big latencies to other clients that
are trying to open the same file.

The problem reproduces when there are multiple shares from the
same server mounted on the client. The processing code tries to
match persistent and volatile file ids from the break notification
with an open file but it skips all share besides the first one.
Fix this by looking up in all shares belonging to the server that
issued the oplock break.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/smb2misc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -563,10 +563,10 @@ smb2_is_valid_oplock_break(char *buffer,
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+
 		list_for_each(tmp1, &ses->tcon_list) {
 			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 
-			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
 			spin_lock(&tcon->open_file_lock);
 			list_for_each(tmp2, &tcon->openFileList) {
 				cfile = list_entry(tmp2, struct cifsFileInfo,
@@ -578,6 +578,8 @@ smb2_is_valid_oplock_break(char *buffer,
 					continue;
 
 				cifs_dbg(FYI, "file id match, oplock break\n");
+				cifs_stats_inc(
+				    &tcon->stats.cifs_stats.num_oplock_brks);
 				cinode = CIFS_I(cfile->dentry->d_inode);
 				spin_lock(&cfile->file_info_lock);
 				if (!CIFS_CACHE_WRITE(cinode) &&
@@ -610,9 +612,6 @@ smb2_is_valid_oplock_break(char *buffer,
 				return true;
 			}
 			spin_unlock(&tcon->open_file_lock);
-			spin_unlock(&cifs_tcp_ses_lock);
-			cifs_dbg(FYI, "No matching file for oplock break\n");
-			return true;
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);

