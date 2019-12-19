Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C464E126C11
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfLSSus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbfLSSus (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1F924683;
        Thu, 19 Dec 2019 18:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781447;
        bh=YZq17bvqHn0RDecNk9gGgHoIlYXiGXKbQkcatew4jYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqsNaFUlcrt6bmrZ9vCl4l3r0BfpR05LRwbr2tWU7QD+899kc3JRf1iqFPKX+b4rU
         KoAig6yBLWQZUECZa6jZBcCsMyZ6JEWFJoP7dSjyqor0gbNpF+xnh8cyP9wwV6J4FZ
         dPjDVyBWtaw1CGtfYlE0OHjUVMGFQY1CLD2586Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.14 26/36] CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
Date:   Thu, 19 Dec 2019 19:34:43 +0100
Message-Id: <20191219182917.831351899@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit 44805b0e62f15e90d233485420e1847133716bdc upstream.

Currently the client translates O_SYNC and O_DIRECT flags
into corresponding SMB create options when openning a file.
The problem is that on reconnect when the file is being
re-opened the client doesn't set those flags and it causes
a server to reject re-open requests because create options
don't match. The latter means that any subsequent system
call against that open file fail until a share is re-mounted.

Fix this by properly setting SMB create options when
re-openning files after reconnects.

Fixes: 1013e760d10e6: ("SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -722,6 +722,13 @@ cifs_reopen_file(struct cifsFileInfo *cf
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
+	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
+	if (cfile->f_flags & O_SYNC)
+		create_options |= CREATE_WRITE_THROUGH;
+
+	if (cfile->f_flags & O_DIRECT)
+		create_options |= CREATE_NO_BUFFER;
+
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
 


