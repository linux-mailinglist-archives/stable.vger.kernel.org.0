Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5749EC14A4
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfI2N47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfI2N46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:56:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0843421882;
        Sun, 29 Sep 2019 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765417;
        bh=zBIgDdIM5oBN2pRQk15Qm3YAgRhv9IwZ7wotxvqQnIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meayJ8swhzsvhIh9tnQbkRZ46EKwS3obVC5rrDw3WrZem/jnqycBkuE5IS5lGYDnO
         +ka0ffWoAOvsco/PitndfrQz7z2w1AtRidtWn4zecsBUvg5LUBPOu4XFb+/XHE324+
         +nx76KH6MR4N/DabTcuqx8gUMQOzdw2SSyPBVcs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 14/63] CIFS: fix deadlock in cached root handling
Date:   Sun, 29 Sep 2019 15:53:47 +0200
Message-Id: <20190929135033.649952261@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit 7e5a70ad88b1e6f6d9b934b2efb41afff496820f upstream.

Prevent deadlock between open_shroot() and
cifs_mark_open_files_invalid() by releasing the lock before entering
SMB2_open, taking it again after and checking if we still need to use
the result.

Link: https://lore.kernel.org/linux-cifs/684ed01c-cbca-2716-bc28-b0a59a0f8521@prodrive-technologies.com/T/#u
Fixes: 3d4ef9a15343 ("smb3: fix redundant opens on root")
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/cifs/smb2ops.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -553,7 +553,50 @@ int open_shroot(unsigned int xid, struct
 	oparams.fid = pfid;
 	oparams.reconnect = false;
 
+	/*
+	 * We do not hold the lock for the open because in case
+	 * SMB2_open needs to reconnect, it will end up calling
+	 * cifs_mark_open_files_invalid() which takes the lock again
+	 * thus causing a deadlock
+	 */
+	mutex_unlock(&tcon->crfid.fid_mutex);
 	rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
+	mutex_lock(&tcon->crfid.fid_mutex);
+
+	/*
+	 * Now we need to check again as the cached root might have
+	 * been successfully re-opened from a concurrent process
+	 */
+
+	if (tcon->crfid.is_valid) {
+		/* work was already done */
+
+		/* stash fids for close() later */
+		struct cifs_fid fid = {
+			.persistent_fid = pfid->persistent_fid,
+			.volatile_fid = pfid->volatile_fid,
+		};
+
+		/*
+		 * Caller expects this func to set pfid to a valid
+		 * cached root, so we copy the existing one and get a
+		 * reference
+		 */
+		memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
+		kref_get(&tcon->crfid.refcount);
+
+		mutex_unlock(&tcon->crfid.fid_mutex);
+
+		if (rc == 0) {
+			/* close extra handle outside of critical section */
+			SMB2_close(xid, tcon, fid.persistent_fid,
+				   fid.volatile_fid);
+		}
+		return 0;
+	}
+
+	/* Cached root is still invalid, continue normaly */
+
 	if (rc == 0) {
 		memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 		tcon->crfid.tcon = tcon;
@@ -561,6 +604,7 @@ int open_shroot(unsigned int xid, struct
 		kref_init(&tcon->crfid.refcount);
 		kref_get(&tcon->crfid.refcount);
 	}
+
 	mutex_unlock(&tcon->crfid.fid_mutex);
 	return rc;
 }


