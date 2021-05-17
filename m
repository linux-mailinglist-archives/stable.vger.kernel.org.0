Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2693E382FBD
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbhEQOU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234797AbhEQORh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49191611EE;
        Mon, 17 May 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260609;
        bh=lOlsJjgaOPtDTbYmbKCrNFRFhoILXqDGkvLtaB4IIV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7VKn02FGEGsFe7bVOnCNolfBjWf54hXhU6OPN3A8Rny4EPmSDP/R+SWm8tIfCGUL
         MkKl8NLk42MtBZ9sHlmDJ3XToTIkRN/MFzlLwkoRKe8Nqeb+NPUWOHh2C/A/rKgA62
         tVBtwZv2z0LvMKVixFbIM6n3ULoah0fKOGd6mlqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 159/363] NFSv4.2 fix handling of sr_eof in SEEKs reply
Date:   Mon, 17 May 2021 16:00:25 +0200
Message-Id: <20210517140307.981336756@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 704a5246ccb5..8d64eb953347 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -667,7 +667,10 @@ static loff_t _nfs42_proc_llseek(struct file *filep,
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



