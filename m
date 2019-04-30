Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43968F86D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfD3Lj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfD3Lj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:39:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A03721734;
        Tue, 30 Apr 2019 11:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624397;
        bh=/qjWqKHu3ZXP6yVjNlOP85MfxlesW2a+Jy4lSu2u2kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7QtcR5RQwD085q6W2ZNHVdj7jzP9csMtNFuVAYVnF2mBzWlc0/82rkC9BBifzfzX
         zUO0OJVc3tW2OeN7B/r9YzHnTnYws66x8CoINLjkGc8CbJSVm50XfxLnbifWBx8FPn
         GMP9sGHY9dLBSxRcXpPJuRhHaT0VQG6hdLyDmnnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Sorenson <sorenson@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.9 02/41] cifs: do not attempt cifs operation on smb2+ rename error
Date:   Tue, 30 Apr 2019 13:38:13 +0200
Message-Id: <20190430113524.880372121@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Sorenson <sorenson@redhat.com>

commit 652727bbe1b17993636346716ae5867627793647 upstream.

A path-based rename returning EBUSY will incorrectly try opening
the file with a cifs (NT Create AndX) operation on an smb2+ mount,
which causes the server to force a session close.

If the mount is smb2+, skip the fallback.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1722,6 +1722,10 @@ cifs_do_rename(const unsigned int xid, s
 	if (rc == 0 || rc != -EBUSY)
 		goto do_rename_exit;
 
+	/* Don't fall back to using SMB on SMB 2+ mount */
+	if (server->vals->protocol_id != 0)
+		goto do_rename_exit;
+
 	/* open-file renames don't work across directories */
 	if (to_dentry->d_parent != from_dentry->d_parent)
 		goto do_rename_exit;


