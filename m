Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE39238ED52
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhEXPgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233884AbhEXPec (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:34:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9026B61407;
        Mon, 24 May 2021 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870312;
        bh=q9xQrSc5sl+L7ZGZa70/BVN647UacWgBDzev996eUNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCDShAkUWYAJikClpSW+fk9rwTkXofmzld4OKs/aIYFvSzJxuArAwq1swfeEe3tJh
         yqAyz7nTfDv83iz+ThotTXR+N9INsKm+XIOomDmN04P999MqWv+UIPIwqM2KxKUVRa
         KBZ4btgTXZ+52MkX4fA7/YPuASOD6R4TeiXZjU6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.9 05/36] cifs: fix memory leak in smb2_copychunk_range
Date:   Mon, 24 May 2021 17:24:50 +0200
Message-Id: <20210524152324.340206658@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.158146731@linuxfoundation.org>
References: <20210524152324.158146731@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit d201d7631ca170b038e7f8921120d05eec70d7c5 upstream.

When using smb2_copychunk_range() for large ranges we will
run through several iterations of a loop calling SMB2_ioctl()
but never actually free the returned buffer except for the final
iteration.
This leads to memory leaks everytime a large copychunk is requested.

Fixes: 9bf0c9cd4314 ("CIFS: Fix SMB2/SMB3 Copy offload support (refcopy) for large files")
Cc: <stable@vger.kernel.org>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -629,6 +629,8 @@ smb2_clone_range(const unsigned int xid,
 			cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
 
 		/* Request server copy to target from src identified by key */
+		kfree(retbuf);
+		retbuf = NULL;
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
 			true /* is_fsctl */, (char *)pcchunk,


