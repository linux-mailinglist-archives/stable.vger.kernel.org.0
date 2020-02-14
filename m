Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE215F343
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgBNPxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731328AbgBNPxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4C26222C4;
        Fri, 14 Feb 2020 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695624;
        bh=rqJbW1MlOFAxeuXU4e+qgCWljI/SYsFcRUgHpHhi5L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnPcgXfzlR0kp7IiEh2O38kiI5GVlsuLGznOEn6rgsBeXC9xfMjyHOshpnq0Q1Jpd
         h4z6Rha0G1k8LYXdIILUh9zyRHBqX3x2CiTcnogJGbHvENIYx+qz/IeuyMO+zJ97bk
         rQJ5Lg2ubGkSwAj5oBu74mk5O0DplILi9EZ74Kkg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 223/542] nfs: fix timstamp debug prints
Date:   Fri, 14 Feb 2020 10:43:35 -0500
Message-Id: <20200214154854.6746-223-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 057f184b1245150b88e59997fc6f1af0e138d42e ]

Starting in v5.5, the timestamps are correctly passed down as
64-bit seconds with NFSv4 on 32-bit machines, but some debug
statements still truncate them to 'long'.

Fixes: e86d5a02874c ("NFS: Convert struct nfs_fattr to use struct timespec64")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 936c57779ff4d..728d88b6a698a 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4097,7 +4097,7 @@ static int decode_attr_time_access(struct xdr_stream *xdr, uint32_t *bitmap, str
 			status = NFS_ATTR_FATTR_ATIME;
 		bitmap[1] &= ~FATTR4_WORD1_TIME_ACCESS;
 	}
-	dprintk("%s: atime=%ld\n", __func__, (long)time->tv_sec);
+	dprintk("%s: atime=%lld\n", __func__, time->tv_sec);
 	return status;
 }
 
@@ -4115,7 +4115,7 @@ static int decode_attr_time_metadata(struct xdr_stream *xdr, uint32_t *bitmap, s
 			status = NFS_ATTR_FATTR_CTIME;
 		bitmap[1] &= ~FATTR4_WORD1_TIME_METADATA;
 	}
-	dprintk("%s: ctime=%ld\n", __func__, (long)time->tv_sec);
+	dprintk("%s: ctime=%lld\n", __func__, time->tv_sec);
 	return status;
 }
 
@@ -4132,8 +4132,8 @@ static int decode_attr_time_delta(struct xdr_stream *xdr, uint32_t *bitmap,
 		status = decode_attr_time(xdr, time);
 		bitmap[1] &= ~FATTR4_WORD1_TIME_DELTA;
 	}
-	dprintk("%s: time_delta=%ld %ld\n", __func__, (long)time->tv_sec,
-		(long)time->tv_nsec);
+	dprintk("%s: time_delta=%lld %ld\n", __func__, time->tv_sec,
+		time->tv_nsec);
 	return status;
 }
 
@@ -4197,7 +4197,7 @@ static int decode_attr_time_modify(struct xdr_stream *xdr, uint32_t *bitmap, str
 			status = NFS_ATTR_FATTR_MTIME;
 		bitmap[1] &= ~FATTR4_WORD1_TIME_MODIFY;
 	}
-	dprintk("%s: mtime=%ld\n", __func__, (long)time->tv_sec);
+	dprintk("%s: mtime=%lld\n", __func__, time->tv_sec);
 	return status;
 }
 
-- 
2.20.1

