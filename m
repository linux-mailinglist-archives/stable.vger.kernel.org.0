Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010BE1670F8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgBUHuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbgBUHuF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:50:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7047524650;
        Fri, 21 Feb 2020 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271404;
        bh=HAmXvkOBj7wGi5sj2L8cQWewIrF6aeIPxUXQV2C0J68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0w4jw3SlDGgLaDW5QkR3Bv4A3vEbFQskVmKHzlWCZzzL0gDWovk9iMpx2Ph/87wN
         Hdq+ENWoGbW995Zws0RmoihAbVUPXgCxuP2qwIYjEfCIWgMBFGfMeKK46ueP3cqlIE
         SkuD3qkKB5A1SVznSMTgcTlGJwrU4lPCowgI6inw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 151/399] nfs: fix timstamp debug prints
Date:   Fri, 21 Feb 2020 08:37:56 +0100
Message-Id: <20200221072417.169613497@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d0feef17db50d..dc6b9c2f36b2a 100644
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



