Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9F734DB4E
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhC2W1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhC2WY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A3F619C3;
        Mon, 29 Mar 2021 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056623;
        bh=1K4P1cg8oLAErK9TaMmPUNMqop6degPjriJpjD2Rcbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in83Rv648JrwSEoXIQq9kdIn2xcK6mbMqnhwLDLt6fwu2nbyZ6sX/aoM8oetxxlEi
         WcSL4VtFeMvYrH74u0F1kjiE82+y43YzVXhXrImiUi0sOeEq3TPbFAKNMeNb7QC647
         bjaTYiqsuxbYh7BxA7C5OI9UO6I9fhNmTCKIcU7PLBQyZXAEnldjY1zdGVIopmS7nv
         Br8WfgSm3T+BqHhNTPaKvWqt9bkMF9Y3ncbgv9FdEXaUx3K1i0fLdGXvqW3hY4+AlD
         kPWeoMs2OI7z9GsC3rabN6eBb1nYBDgxWOQ/Zph3u2F84yvsrfEA6QxxRpUo8n+ioL
         jK9YykHgaAL9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 14/15] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Mon, 29 Mar 2021 18:23:25 -0400
Message-Id: <20210329222327.2383533-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
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
index 5cb15649adb0..7b482489bd22 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -163,6 +163,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 			goto posix_open_ret;
 		}
 	} else {
+		cifs_revalidate_mapping(*pinode);
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-- 
2.30.1

