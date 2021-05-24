Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6381438ED27
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhEXPeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233469AbhEXPdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E787F613EA;
        Mon, 24 May 2021 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870284;
        bh=KRrJAdxoYL0QCt6u4SSirQA78U2D4mC3usFw8C+NznA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLD1xk7Cb3R/tIGHBxYGuHIsTQa3I3NU/JRo8uvgJo9a0pltLFFDoQOfjrKya/eQV
         V8zgDH8wkRDz3PD+LhHhffIX5jYP7gY6ahjP4L8ht0wpDsHTkITBeW8RScjple788V
         Mx77BX0345QIRj9O9lNmDYSKLULA9moj8+nVQxTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.4 04/31] cifs: fix memory leak in smb2_copychunk_range
Date:   Mon, 24 May 2021 17:24:47 +0200
Message-Id: <20210524152323.061291491@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
References: <20210524152322.919918360@linuxfoundation.org>
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
@@ -619,6 +619,8 @@ smb2_clone_range(const unsigned int xid,
 			cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
 
 		/* Request server copy to target from src identified by key */
+		kfree(retbuf);
+		retbuf = NULL;
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
 			true /* is_fsctl */, (char *)pcchunk,


