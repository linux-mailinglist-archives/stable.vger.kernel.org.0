Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35383D61F5
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhGZPdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233729AbhGZPcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5016960F5B;
        Mon, 26 Jul 2021 16:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315980;
        bh=2P89fFdx1V14WzPrSpB0gkcu8Roho3sJZjYhuF89D8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjBDsKvAj6Xw7W4DLhcNDCnJ92DlObD5LhD3pp605ir15PmHQjuonFUXVXGw+ogb4
         aasVpF4z7vxa/VGDqqspPAIcFUPzEQO6ICq10GbTkinjj7xTRfFrtQVUKUepi8IgMG
         KDoB+t06frb7PdUH4iTzzuUE8aODUTVrCi7JALs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 140/223] cifs: only write 64kb at a time when fallocating a small region of a file
Date:   Mon, 26 Jul 2021 17:38:52 +0200
Message-Id: <20210726153850.817887055@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 2485bd7557a7edb4520b4072af464f0a08c8efe0 ]

We only allow sending single credit writes through the SMB2_write() synchronous
api so split this into smaller chunks.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reported-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 903de7449aa3..cc253bbff696 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3613,7 +3613,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	int rc, nbytes;
 	struct kvec iov[2];
 
 	io_parms.netfid = cfile->fid.netfid;
@@ -3621,13 +3621,25 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 	io_parms.tcon = tcon;
 	io_parms.persistent_fid = cfile->fid.persistent_fid;
 	io_parms.volatile_fid = cfile->fid.volatile_fid;
-	io_parms.offset = off;
-	io_parms.length = len;
 
-	/* iov[0] is reserved for smb header */
-	iov[1].iov_base = buf;
-	iov[1].iov_len = io_parms.length;
-	return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
+	while (len) {
+		io_parms.offset = off;
+		io_parms.length = len;
+		if (io_parms.length > SMB2_MAX_BUFFER_SIZE)
+			io_parms.length = SMB2_MAX_BUFFER_SIZE;
+		/* iov[0] is reserved for smb header */
+		iov[1].iov_base = buf;
+		iov[1].iov_len = io_parms.length;
+		rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
+		if (rc)
+			break;
+		if (nbytes > len)
+			return -EINVAL;
+		buf += nbytes;
+		off += nbytes;
+		len -= nbytes;
+	}
+	return rc;
 }
 
 static int smb3_simple_fallocate_range(unsigned int xid,
-- 
2.30.2



