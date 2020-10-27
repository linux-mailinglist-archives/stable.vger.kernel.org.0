Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F096829C18E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1776224AbgJ0Oxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772913AbgJ0Ouf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37CAC20709;
        Tue, 27 Oct 2020 14:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810233;
        bh=fkpBxmfNOcwEsEY2B5f6l5JmMKKxZmeXpAnX27yXbj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYBJYLoLgEJfSgGN4bURswh5vz0nmCFKgNpgQqwLYcr3LuwOPw42euP17rf2nk44t
         cSZwoDuxO+gkw1Dtqu4U7R5C2I7UrKQV0sTPOMbyiYNECwBy0ZfoOK/T5xPH8XDJmT
         9htP5Ct7UUHEszEt0B7QAWN3lbX+v4zFdSlMbejQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5.8 067/633] smb3: fix stat when special device file and mounted with modefromsid
Date:   Tue, 27 Oct 2020 14:46:50 +0100
Message-Id: <20201027135525.839372809@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 3c3317daef0afa0cd541fc9c1bfd6ce8bbf1129a upstream.

When mounting with modefromsid mount option, it was possible to
get the error on stat of a fifo or char or block device:
        "cannot stat <filename>: Operation not supported"

Special devices can be stored as reparse points by some servers
(e.g. Windows NFS server and when using the SMB3.1.1 POSIX
Extensions) but when the modefromsid mount option is used
the client attempts to get the ACL for the file which requires
opening with OPEN_REPARSE_POINT create option.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3072,7 +3072,12 @@ get_smb2_acl_by_path(struct cifs_sb_info
 	oparms.tcon = tcon;
 	oparms.desired_access = READ_CONTROL;
 	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
+	/*
+	 * When querying an ACL, even if the file is a symlink we want to open
+	 * the source not the target, and so the protocol requires that the
+	 * client specify this flag when opening a reparse point
+	 */
+	oparms.create_options = cifs_create_options(cifs_sb, 0) | OPEN_REPARSE_POINT;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 


