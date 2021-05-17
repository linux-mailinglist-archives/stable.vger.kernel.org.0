Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9404383411
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbhEQPFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239933AbhEQPCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C718E61A13;
        Mon, 17 May 2021 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261658;
        bh=tF9+NaIMTVI/hTZTGJpNqhAQ5iXTTR/6B8dyOruPJRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCOMNyYB0n3sbGU12WtBMhlXo2Z4sSWiDUroU+hc5WY6O5Ans+KapXVYkg67MKVQ6
         5lUdA3PD3LMtoOOZDw2o6FBz2gq+AovdaNLYCU1zNsg8DuNWb78KI6zLw7Becowk0K
         UfM3lvgaqp+cmlAIPqUHRXVIJ4Qd5/ooZN4HCJVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 146/329] NFSv4.2 fix handling of sr_eof in SEEKs reply
Date:   Mon, 17 May 2021 16:00:57 +0200
Message-Id: <20210517140307.056534039@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 7add6332016a..b85f7d56a155 100644
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



