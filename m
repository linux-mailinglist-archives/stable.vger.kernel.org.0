Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7AF2A530E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgKCU4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:56:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732421AbgKCUz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06CC422226;
        Tue,  3 Nov 2020 20:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436956;
        bh=VcqJGZGvfLtSxMUUO8ZasHLqmWQGZ+sqivDw7+BUfEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akfNdc3Cs1m4romsSi0NCDb3ol0jMeRUcdn/sXi3fWw0UDR9kErJyxrA8mQR7Fiql
         9ybpzp7oBr12tW8ZyVpjAVltoc1EPbxjKvwUaMWh9DePSp/6iMKtYiEA9BqW7kGIPt
         LsMbL8fpFWrpVzzEsffdfyfAzTD+ZhwNnhKrc1Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/214] cifs: handle -EINTR in cifs_setattr
Date:   Tue,  3 Nov 2020 21:35:33 +0100
Message-Id: <20201103203258.321164049@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit c6cc4c5a72505a0ecefc9b413f16bec512f38078 ]

RHBZ: 1848178

Some calls that set attributes, like utimensat(), are not supposed to return
-EINTR and thus do not have handlers for this in glibc which causes us
to leak -EINTR to the applications which are also unprepared to handle it.

For example tar will break if utimensat() return -EINTR and abort unpacking
the archive. Other applications may break too.

To handle this we add checks, and retry, for -EINTR in cifs_setattr()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 17df90b5f57a2..fd9e289f3e72a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2614,13 +2614,18 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
 	struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
+	int rc, retries = 0;
 
-	if (pTcon->unix_ext)
-		return cifs_setattr_unix(direntry, attrs);
-
-	return cifs_setattr_nounix(direntry, attrs);
+	do {
+		if (pTcon->unix_ext)
+			rc = cifs_setattr_unix(direntry, attrs);
+		else
+			rc = cifs_setattr_nounix(direntry, attrs);
+		retries++;
+	} while (is_retryable_error(rc) && retries < 2);
 
 	/* BB: add cifs_setattr_legacy for really old servers */
+	return rc;
 }
 
 #if 0
-- 
2.27.0



