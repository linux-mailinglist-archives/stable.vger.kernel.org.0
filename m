Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F0638EEC8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhEXPzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234733AbhEXPyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E57961422;
        Mon, 24 May 2021 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870781;
        bh=MQPWFhuDBxFHafnOD0b0OKwcznXauzBzgd4vPtxUXgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pY/KooBtyoHQXWXvKvyEyFISJEujmFKRluZw2R9bCmvwgGE7n+OwMTNIz0Xw2Q3AA
         yjkwEmkV2+46Z1E5j8sQdt6SATHIS6980HPDBPSmXSAGqD7D/1UKQTOfc2r0impBTZ
         QFhBCsfutIcJWdl2ohzg1MSneRaYbkx/IkOcmqrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 032/104] cifs: fix memory leak in smb2_copychunk_range
Date:   Mon, 24 May 2021 17:25:27 +0200
Message-Id: <20210524152333.881710396@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
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
@@ -1764,6 +1764,8 @@ smb2_copychunk_range(const unsigned int
 			cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
 
 		/* Request server copy to target from src identified by key */
+		kfree(retbuf);
+		retbuf = NULL;
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
 			true /* is_fsctl */, (char *)pcchunk,


