Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF2E3289A8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbhCASCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:02:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237954AbhCAR4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC8EA64F4A;
        Mon,  1 Mar 2021 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618875;
        bh=dLhgrHfjxi1ErbFdmYw0lXiVq25TUtBHfAnko04EZfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6tFjCJjrFzH0O+n+E4cEbAv2c+73i9opQ8c9nOWpvZTl1OOT9f2wCmHvPD/jTaWX
         mwis2CqrHQO6V8LYyVVFq7IitKBEex/X2cFF0zE2j0e00/+anpu+Z229diSGR/IsRV
         bbr/aTGZad/aSj4zDGucp+ObIXtc0dwdEQxkOMMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/663] fs/jfs: fix potential integer overflow on shift of a int
Date:   Mon,  1 Mar 2021 17:08:17 +0100
Message-Id: <20210301161154.142576632@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 4208c398aae4c2290864ba15c3dab7111f32bec1 ]

The left shift of int 32 bit integer constant 1 is evaluated using 32 bit
arithmetic and then assigned to a signed 64 bit integer. In the case where
l2nb is 32 or more this can lead to an overflow.  Avoid this by shifting
the value 1LL instead.

Addresses-Coverity: ("Uninitentional integer overflow")
Fixes: b40c2e665cd5 ("fs/jfs: TRIM support for JFS Filesystem")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 7dfcab2a2da68..aedad59f8a458 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1656,7 +1656,7 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 		} else if (rc == -ENOSPC) {
 			/* search for next smaller log2 block */
 			l2nb = BLKSTOL2(nblocks) - 1;
-			nblocks = 1 << l2nb;
+			nblocks = 1LL << l2nb;
 		} else {
 			/* Trim any already allocated blocks */
 			jfs_error(bmp->db_ipbmap->i_sb, "-EIO\n");
-- 
2.27.0



