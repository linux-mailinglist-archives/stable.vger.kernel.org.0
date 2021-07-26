Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DE73D60B8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbhGZPX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237597AbhGZPXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E7AA60EB2;
        Mon, 26 Jul 2021 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315460;
        bh=gmEns8PhLF+o1uVXF0uNw72FyU1wHirlb4IqqBmMj3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bG9IPSe/s7YCteTk7lPPxVKKXGuN85snFkllh8SrkZ0p4RdR4YaQG/JpV8JRa5cgg
         x4EshJdvstRJ0jCSp8aDAsYQXp7cVBxa+iMZUsEfk0Yh3fatAqs+ZxFSyYsjmv5h3J
         oI1CYP35odPsmfVAMtrA/pWzQsFDOTBL9WLw9yLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/167] cifs: fix fallocate when trying to allocate a hole.
Date:   Mon, 26 Jul 2021 17:38:57 +0200
Message-Id: <20210726153842.888529961@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 488968a8945c119859d91bb6a8dc13bf50002f15 ]

Remove the conditional checking for out_data_len and skipping the fallocate
if it is 0. This is wrong will actually change any legitimate the fallocate
where the entire region is unallocated into a no-op.

Additionally, before allocating the range, if FALLOC_FL_KEEP_SIZE is set then
we need to clamp the length of the fallocate region as to not extend the size of the file.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 442bf422aa01..b0b06eb86edf 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3516,11 +3516,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			(char **)&out_data, &out_data_len);
 	if (rc)
 		goto out;
-	/*
-	 * It is already all allocated
-	 */
-	if (out_data_len == 0)
-		goto out;
 
 	buf = kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
@@ -3643,6 +3638,24 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	if (keep_size == true) {
+		/*
+		 * We can not preallocate pages beyond the end of the file
+		 * in SMB2
+		 */
+		if (off >= i_size_read(inode)) {
+			rc = 0;
+			goto out;
+		}
+		/*
+		 * For fallocates that are partially beyond the end of file,
+		 * clamp len so we only fallocate up to the end of file.
+		 */
+		if (off + len > i_size_read(inode)) {
+			len = i_size_read(inode) - off;
+		}
+	}
+
 	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
 		/*
 		 * At this point, we are trying to fallocate an internal
-- 
2.30.2



