Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCF7359AC2
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhDIKC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233829AbhDIKAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F11A1611F1;
        Fri,  9 Apr 2021 09:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962364;
        bh=Eyk8V1EXcB2tviQVNu4eTXGcnt36r8DS8FxRhP9LU08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2cyLa+Pjl1ImKZsmIAiSCtAdVNGg1jbN/LVBPCXJwi+sedNZnTi58ya7JgEnc5ZZ
         U4SuaYv/Tww5GTy5BYHVz1/xcqermjjxy/je6rMotDsw2OBepsOYnoVbxV2abHYNLG
         GaDpD9Yedao1AJpPT16V9bweI7xS2J198cQc/ZT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Tom Talpey <tom@talpey.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/41] cifs: Silently ignore unknown oplock break handle
Date:   Fri,  9 Apr 2021 11:53:51 +0200
Message-Id: <20210409095305.752570676@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index db22d686c61f..be3df90bb2bc 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -745,8 +745,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
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
2.30.2



