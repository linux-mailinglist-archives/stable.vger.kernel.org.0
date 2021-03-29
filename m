Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20D634DB7C
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhC2W2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhC2W0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D3C601FC;
        Mon, 29 Mar 2021 22:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056639;
        bh=9ReVkPrOz9r5j+WUgFzVtLbXPujArELNM9xjorZklvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTeg6PUCvF1IxqvS6VJe7umuYciDDh4imM3mO/Zx58Vdk/tmgAbnwFcFahecKJPw9
         M3ayo0rKbQL6o1vIRQZPIKawVw1uArqjE93ZJTK/F8+rh7vKILpLyQUtCqnw7pTknz
         /qaUc2o8pdUxa3c0FGfQFqXrtDkpLSiuYyCwXiS09aKCDxK2XErSxH0Gfjzwxkfdlb
         hUTwL1b9/HclnuX1WdR6AQZFgOXdzj+TiOK4oovXsFZlqaISOsEz4qv/yblrBiRn5l
         8boV1OEUbnyLe4konFRSoW7sbUADo+2pY3AsUlvOx+c+P0pmZuanhJPkQrDLjBID8g
         vSmdZIzYTQvMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 11/12] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Mon, 29 Mar 2021 18:23:44 -0400
Message-Id: <20210329222345.2383777-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222345.2383777-1-sashal@kernel.org>
References: <20210329222345.2383777-1-sashal@kernel.org>
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
index 6c77a96437e6..46e8e9324b58 100644
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

