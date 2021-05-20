Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA79738AB5D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbhETLXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240971AbhETLVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:21:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDD0A61D8F;
        Thu, 20 May 2021 10:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505485;
        bh=TCw6IzIBlq8q+GKZ9gdle9bWfo09GoqckjT9I6Ml+eg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdimsMC6xtJWD3K2rl5Oep3W7yLuldx/S/qY3N1+i3HUrHKwohBgoDZVZlmrtGVW+
         xwCf5GayPehN1Qc0ty6iL7e/34vIQaj0dnb3kcpQe2mwyoG7vSh677vuy+S6YYJfq1
         bb+eKgNAn35r/7XcYwJqswkudWQLfv9F1K6uoDoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 157/190] NFSv4.2 fix handling of sr_eof in SEEKs reply
Date:   Thu, 20 May 2021 11:23:41 +0200
Message-Id: <20210520092107.357813500@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 73f5c88f521a630ea1628beb9c2d48a2e777a419 ]

Currently the client ignores the value of the sr_eof of the SEEK
operation. According to the spec, if the server didn't find the
requested extent and reached the end of the file, the server
would return sr_eof=true. In case the request for DATA and no
data was found (ie in the middle of the hole), then the lseek
expects that ENXIO would be returned.

Fixes: 1c6dcbe5ceff8 ("NFS: Implement SEEK")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 7f1a0fb8c493..31cc6f3d992d 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -168,7 +168,10 @@ static loff_t _nfs42_proc_llseek(struct file *filep, loff_t offset, int whence)
 	if (status)
 		return status;
 
-	return vfs_setpos(filep, res.sr_offset, inode->i_sb->s_maxbytes);
+	if (whence == SEEK_DATA && res.sr_eof)
+		return -NFS4ERR_NXIO;
+	else
+		return vfs_setpos(filep, res.sr_offset, inode->i_sb->s_maxbytes);
 }
 
 loff_t nfs42_proc_llseek(struct file *filep, loff_t offset, int whence)
-- 
2.30.2



