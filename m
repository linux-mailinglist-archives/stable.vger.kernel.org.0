Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB14B34DBC9
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhC2Wap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232791AbhC2W2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BEB1619F6;
        Mon, 29 Mar 2021 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056663;
        bh=ZqjYW4/fyq6bvZoR5UU/DdcgoUHRCZsjKRfLCC2DPs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6Z0eDHfoKmNlsOm9ZBZZ6rJoppAebPzE1yEIRedcaJsLZ04Tjf6d0+bHz8Mvx0qp
         aPi4eJKJ7Db1LiFVdXt509Jo6VxtVkHe7SjAN4lgF9yPP/779BPShgURdl2+euH8+4
         iODFDhbTM9vPVkQznyG1IyreLbO9SkL94taGQ6LRmFvu0CZWsMMJ8w/6IZ97p2ar6F
         XnBcU8Q9M2JVq6TC2P4UAlS2/d4wf7keRApq0hRqQhyUwj8nMXX2b7nAfevHnyGFrv
         dykSFjswV4VWLbmQ5sO3eJB3WYgZhB3CcwMCzE1Q6yV0QF2mFA62ybNQ3WpgrknHSB
         jq47PRIrPUdPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.4 7/8] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Mon, 29 Mar 2021 18:24:13 -0400
Message-Id: <20210329222415.2384075-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222415.2384075-1-sashal@kernel.org>
References: <20210329222415.2384075-1-sashal@kernel.org>
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
index b5a05092f862..5bc617cb7721 100644
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

