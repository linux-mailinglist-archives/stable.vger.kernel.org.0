Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF09359A54
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhDIJ6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233732AbhDIJ47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C26E611ED;
        Fri,  9 Apr 2021 09:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962205;
        bh=mEYwedyN6cye1EEFQVAXhtl9/YNzpqawsB+j3nRacL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxfTXylQBQ0xWjjqZc/N/DOz9MemyVptMSxdqp7r76sDdqxrEp1GJ2KRqnh+jpqoB
         159T2TqtVPKHZq8LjO+3a7h6SamghtGmvZDw9o3gEtMT5LtXM83TsXm+YdJq5Kafyp
         wJhSeDfJl+tZifolLPZXo/UsOoplH3eSp5KHUOA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/18] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Fri,  9 Apr 2021 11:53:41 +0200
Message-Id: <20210409095301.962224321@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
References: <20210409095301.525783608@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.30.2



