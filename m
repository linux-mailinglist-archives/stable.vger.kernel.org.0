Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0694F73CDB
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390977AbfGXUMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404852AbfGXT5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:57:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFB1A205C9;
        Wed, 24 Jul 2019 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998231;
        bh=BaCUtOpBk5NR380AvK+1GHq4ZwFVoy4k4pxaJsg3mgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DK3omRgxAegIt4vjejT3x0g65oGrAvfmZCQ5fLEdSbGACFVF9ukDNlENypAtVQF5A
         HQwZvfnhpNq7hS1ql3XXCbwQAnTUpIeB1Dplpa3sHw4qBf3j5XVFGVeSTBRM3YpqJb
         9ZPjlTTxNLGG7tuUaxPqKPn98TP11XyCZJthTbc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.1 255/371] CIFS: fix deadlock in cached root handling
Date:   Wed, 24 Jul 2019 21:20:07 +0200
Message-Id: <20190724191743.787523781@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
 fs/cifs/smb2ops.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -705,8 +705,51 @@ int open_shroot(unsigned int xid, struct
 
 	smb2_set_related(&rqst[1]);
 
+	/*
+	 * We do not hold the lock for the open because in case
+	 * SMB2_open needs to reconnect, it will end up calling
+	 * cifs_mark_open_files_invalid() which takes the lock again
+	 * thus causing a deadlock
+	 */
+
+	mutex_unlock(&tcon->crfid.fid_mutex);
 	rc = compound_send_recv(xid, ses, flags, 2, rqst,
 				resp_buftype, rsp_iov);
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
+		 * caller expects this func to set pfid to a valid
+		 * cached root, so we copy the existing one and get a
+		 * reference.
+		 */
+		memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
+		kref_get(&tcon->crfid.refcount);
+
+		mutex_unlock(&tcon->crfid.fid_mutex);
+
+		if (rc == 0) {
+			/* close extra handle outside of crit sec */
+			SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+		}
+		goto oshr_free;
+	}
+
+	/* Cached root is still invalid, continue normaly */
+
 	if (rc)
 		goto oshr_exit;
 
@@ -740,8 +783,9 @@ int open_shroot(unsigned int xid, struct
 				(char *)&tcon->crfid.file_all_info))
 		tcon->crfid.file_all_info_is_valid = 1;
 
- oshr_exit:
+oshr_exit:
 	mutex_unlock(&tcon->crfid.fid_mutex);
+oshr_free:
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);


