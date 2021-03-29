Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE9534DAF0
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhC2WYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232311AbhC2WW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE226198E;
        Mon, 29 Mar 2021 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056579;
        bh=7WivkTwt3Qho7FYaPS6DVi9+11PGsKEdbb8NQr6QT8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=By3TKS8W60WeNCV2pMxRNLrKbs7dyXMA7Q5SPFTHPLzw9QPfVmStUnf1nAqYe0nsh
         sbmLJAxG70sNoDqknOOOlmDplu4tgDh+kZ/ghmCMDd4SzvhqlKRPy+WyDs0GoJyHD8
         +guUE3nG+uiWdlN99MRRzGtwYDXRN5RnMZsP9AIEjCN6YYmP4H/qmuznNiv4XUNU94
         uWKD3471YPv3u5Cy3hWkigMWxZP4g/1aN+EjupVAJGQhhg4t4tS6d27M6TwSZf1Ia2
         aczPsmakrYsM/WK2Oqz97wjSjhYd5e2pHfc3ygqUw/mnOgSpqJ6tJr9+lODzhIR8nX
         Xg/0xGHaW8tLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 30/33] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Mon, 29 Mar 2021 18:22:18 -0400
Message-Id: <20210329222222.2382987-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
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
index be46fab4c96d..da057570bb93 100644
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

