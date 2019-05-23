Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E910288BD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391776AbfEWT2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391775AbfEWT2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0162217D7;
        Thu, 23 May 2019 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639702;
        bh=6/sov5HppODJictdLfb0HMtNQOYTNB4XKlV/pHVD8so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4HT4s68ulZ4oHBb8xA1xDSfUZfAUESZCDewGpw+eN1B8iojp/UNRliMLMqbVtvCI
         qA8qYyXcZgLqe+G2bktOOalJ5Z1M40kPTGh4nC8xMuU43hEv6gz1QZpP11tcHbGOJ+
         bomxF9eEnezMADwA1DuO+FREVgyON/flfyWz15Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Probst <kernel@probst.it>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 047/122] cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()
Date:   Thu, 23 May 2019 21:06:09 +0200
Message-Id: <20190523181710.926746164@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Probst <kernel@probst.it>

commit 6a54b2e002c9d00b398d35724c79f9fe0d9b38fb upstream.

Change strcat to strncpy in the "None" case to fix a buffer overflow
when cinode->oplock is reset to 0 by another thread accessing the same
cinode. It is never valid to append "None" to any other message.

Consolidate multiple writes to cinode->oplock to reduce raciness.

Signed-off-by: Christoph Probst <kernel@probst.it>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2917,26 +2917,28 @@ smb21_set_oplock_level(struct cifsInodeI
 		       unsigned int epoch, bool *purge_cache)
 {
 	char message[5] = {0};
+	unsigned int new_oplock = 0;
 
 	oplock &= 0xFF;
 	if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
 		return;
 
-	cinode->oplock = 0;
 	if (oplock & SMB2_LEASE_READ_CACHING_HE) {
-		cinode->oplock |= CIFS_CACHE_READ_FLG;
+		new_oplock |= CIFS_CACHE_READ_FLG;
 		strcat(message, "R");
 	}
 	if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
-		cinode->oplock |= CIFS_CACHE_HANDLE_FLG;
+		new_oplock |= CIFS_CACHE_HANDLE_FLG;
 		strcat(message, "H");
 	}
 	if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
-		cinode->oplock |= CIFS_CACHE_WRITE_FLG;
+		new_oplock |= CIFS_CACHE_WRITE_FLG;
 		strcat(message, "W");
 	}
-	if (!cinode->oplock)
-		strcat(message, "None");
+	if (!new_oplock)
+		strncpy(message, "None", sizeof(message));
+
+	cinode->oplock = new_oplock;
 	cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
 		 &cinode->vfs_inode);
 }


