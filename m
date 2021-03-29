Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DCC34DB22
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhC2WZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhC2WXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B4A361990;
        Mon, 29 Mar 2021 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056605;
        bh=ABixJEs+1GDjJj499aO3kybyji/C5xFLQDGqqXEFmSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAzj/awBKwbVq/lhKTX2byWwR1dHRxJRHB3wHMhMdCVZY0uDDZbr6cQVp+aptp0Ks
         CgoDo6DX+hEIwLYYP6HKaBkBVjCyMltQjvaIano7OHzhu7HeOoZaZheuCkLupBTJWR
         HMo/tqFuokBfRg7HXGfVfohPvrHZOLNAtQv0JmEMuDMatG5pevrHGgCNGfc8QvQDQ2
         eu/ElWMOQ2VV880HNk5VsPm4LQSEwRm1AxJjA6IL7IZ5PGIAeL38UYDkZwqWa1NwP9
         v1xOUB/DJmoCBLqWI35guOw6uMOKlBZ5e8j67yOfPSljImAJNkj8iLu+9z+VUNvF5w
         fAebS+A3HI3WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 18/19] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Mon, 29 Mar 2021 18:23:01 -0400
Message-Id: <20210329222303.2383319-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit cee8f4f6fcabfdf229542926128e9874d19016d5 ]

RHBZ: 1933527

Under SMB1 + POSIX, if an inode is reused on a server after we have read and
cached a part of a file, when we then open the new file with the
re-cycled inode there is a chance that we may serve the old data out of cache
to the application.
This only happens for SMB1 (deprecated) and when posix are used.
The simplest solution to avoid this race is to force a revalidate
on smb1-posix open.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 31d578739341..1aac8d38f887 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -164,6 +164,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 			goto posix_open_ret;
 		}
 	} else {
+		cifs_revalidate_mapping(*pinode);
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-- 
2.30.1

