Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096F299C0F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410487AbgJZXye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410479AbgJZXye (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E41820882;
        Mon, 26 Oct 2020 23:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756473;
        bh=AmXG+RqQ+RuMXYS0CVb3zg/jUZcLD3saAdH1IpzA7Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9O67xe2jd5C2cldYxtMLnixnyoV+w9NNqu1/arc6s70iE3heYgNZNa9TxMK1KBqz
         J73QHpU8pifYhFDDsEpuT+UV1g526RNisPT0iZvp80shPrG7Vhf95at9oyO7OG3bQb
         pYnhZ7CWFmKxP+PJBNeRFKlCCzRfTU9wmxXUvL80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.8 119/132] cifs: handle -EINTR in cifs_setattr
Date:   Mon, 26 Oct 2020 19:51:51 -0400
Message-Id: <20201026235205.1023962-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7708175062eba..8c0b7f40714ba 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2885,13 +2885,18 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
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
2.25.1

