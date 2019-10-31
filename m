Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE34EB8D7
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 22:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfJaVTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 17:19:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38726 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaVTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 17:19:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id c13so5322558pfp.5;
        Thu, 31 Oct 2019 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QHjg6cf8a3DCHiEQ6cgO5fiuIXYg8F/FcsSBS84DcVQ=;
        b=MUAhSaRmFPpX6bIB1saz7LVQ1ZusfwUfceSkJLUkimjuHeFcEnZK9f6AAiEYkuuPeD
         B5mQN3jCO55l6nMMn5T3kxLQzBl5szbUFq9pqm2pbHBHLQ97wH23w7lBZ0Y7xAFrcB9v
         fQyvNsgz1nRDBIP0ad3VPVvLY36zeDLq97K7XbAOWbr4dM5Aaynr09SehE11woGdv+3R
         ZWs7uAXKpjUOL68BW9z4fFF5uXjRv1bv9vI4F4IucO9GR5iKZHWS2G4t017SeaKUzYpU
         f6iDtwxnb7WG0OGg9ckn0EqFMKgPpRiuvcKCwY4Q9jjNcKFRVpyXHbqiorPxeTpFKhf6
         XZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QHjg6cf8a3DCHiEQ6cgO5fiuIXYg8F/FcsSBS84DcVQ=;
        b=WiTVTpXI8XRnXU+a5waPUX3gB2PHbDv8NmU4xPg4Yn0cUoe2FV6a0qTxzETr959E28
         xEgt2XozXEvlbNBCR9q+9BER+K+ZNDMUr1ryE2WA7LrSuydjQD3jBpBABopWqfpsFBTK
         doA53Q82/9OvaqJVRYiYr2Je54+IJgKKzTSyUKSY8ldPXS6njyx39wN1DZ8aDFXeqEhP
         oTYlhbmPocsyhR9aRFZSrsgl+u6jKkCCAqsaBNgpJX3O0uLRi5nwcXDnhKeH6zwmURyZ
         RYvInHyndTIWdoD6LvhyXF7vqTrnpm3jzml9ppBhim3aAy7Jcz9VSo7nhxySjOFI5RyC
         eaqw==
X-Gm-Message-State: APjAAAVG5M0AziHiEGwhQByw2JdKMbE2SW0Zny+2WR8cED8XsPdoAb9a
        DkcNObP/rgK1zE2lRKlAy7G80Dc=
X-Google-Smtp-Source: APXvYqxbZMzzdlV7mMn8ygiaqDn3ouJm8ewGKkDaLhFiJ+c+f9jwlEDkKxpanRSWF4NqmqxG+eWLyg==
X-Received: by 2002:a17:90a:a002:: with SMTP id q2mr10307944pjp.124.1572556742949;
        Thu, 31 Oct 2019 14:19:02 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id x14sm3954604pfm.96.2019.10.31.14.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 14:19:02 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] CIFS: Fix SMB2 oplock break processing
Date:   Thu, 31 Oct 2019 14:18:57 -0700
Message-Id: <20191031211857.18989-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/smb2misc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 8db6201b18ba..527c9efd3de0 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -664,10 +664,10 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
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
@@ -679,6 +679,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 					continue;
 
 				cifs_dbg(FYI, "file id match, oplock break\n");
+				cifs_stats_inc(
+				    &tcon->stats.cifs_stats.num_oplock_brks);
 				cinode = CIFS_I(d_inode(cfile->dentry));
 				spin_lock(&cfile->file_info_lock);
 				if (!CIFS_CACHE_WRITE(cinode) &&
@@ -702,9 +704,6 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				return true;
 			}
 			spin_unlock(&tcon->open_file_lock);
-			spin_unlock(&cifs_tcp_ses_lock);
-			cifs_dbg(FYI, "No matching file for oplock break\n");
-			return true;
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-- 
2.17.1

