Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65C434DAD5
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhC2WXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhC2WWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 398D061996;
        Mon, 29 Mar 2021 22:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056539;
        bh=gYYxf2YlTbSeU/nFklOPxLrXqQH4/Dm0fpyodjHg0jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9Emlk2OXAuXNWRzq7Op1jNC7iFpKCSBjzeEO+t3BjVKIT4sj6esTeenVLpqqI1A6
         zaE6iXVBZ6JZzaVOXGbewoiw6QM+jvSGsWP/SWsZXEeIT/Dsom0GqCLNwv4MbrUOYm
         1MEFkkyvBzpevvtgSzmhAmWY+PJIB9hkDIJwekueBSqV3PykynaAhmifDz+39muD8d
         9vuf2z5q+yiwMRmaMsHQyCtPU7UU+DmB025au3W6ZN8h6IzO0nvapsE+CmPKa7ZgAM
         FWvL1F5c6eYqrB4kCZ5g5QyVodAeV0JR8OMxnYEjCFtfCNFkPHyh/Y455MhsH0Fdsq
         ECLJ1aSoz9frg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.11 36/38] cifs: Silently ignore unknown oplock break handle
Date:   Mon, 29 Mar 2021 18:21:31 -0400
Message-Id: <20210329222133.2382393-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 219481a8f90ec3a5eed9638fb35609e4b1aeece7 ]

Make SMB2 not print out an error when an oplock break is received for an
unknown handle, similar to SMB1.  The debug message which is printed for
these unknown handles may also be misleading, so fix that too.

The SMB2 lease break path is not affected by this patch.

Without this, a program which writes to a file from one thread, and
opens, reads, and writes the same file from another thread triggers the
below errors several times a minute when run against a Samba server
configured with "smb2 leases = no".

 CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
 00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
 00000010: 00000001 00000000 ffffffff ffffffff  ................
 00000020: 00000000 00000000 00000000 00000000  ................
 00000030: 00000000 00000000 00000000 00000000  ................

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d9073b569e17..53fb751bf210 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -754,8 +754,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
-	return false;
+	cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
+	return true;
 }
 
 void
-- 
2.30.1

