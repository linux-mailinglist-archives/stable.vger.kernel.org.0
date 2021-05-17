Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10D73835F5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244052AbhEQP0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245098AbhEQPYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:24:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5212561C93;
        Mon, 17 May 2021 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262153;
        bh=rPzfRhXVwvUYNERhAyxZi2v+rFlGSzdr0h5b84aoilM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhSZyx6GN6WUUTQyBl0BJgiPna4pCRsRRjs31n31pARxEZOJyvVRMr2Ei1JU9ke/P
         DqyXA4vzQTK4P5RzV7NJlOf3cfBTha4+wxnvcsUA30aPy+6Q/PNpJUMGNzdZGHB2TN
         ItXaSMVEwAJUDbQNA6UkuB8DOeixxRI+uUn8+0u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/289] NFSv4.2 fix handling of sr_eof in SEEKs reply
Date:   Mon, 17 May 2021 16:00:47 +0200
Message-Id: <20210517140309.269363928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index 948a4c69687c..4ebcd9dd1535 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -665,7 +665,10 @@ static loff_t _nfs42_proc_llseek(struct file *filep,
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



