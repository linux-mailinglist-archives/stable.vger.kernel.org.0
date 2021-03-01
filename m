Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5767832838B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhCAQVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:21:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237785AbhCAQTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:19:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB20864EBD;
        Mon,  1 Mar 2021 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615444;
        bh=1eKXSA8cIktsJfyE3Kpkyn6RZoMoY3oiWUaaLnrMJAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXa105ju/zHP3JVxFdHrYojEoR2mtnXXmDsRasgB6LW/TooOLiQno8luPtFP2csMI
         Nzsqn83/02yyLXWH4TEQZ3GLQz5EztlEnVLho0CAuDp90O7G7jSelCDPhhX/prAeCJ
         Or3dTn/f6yZdceIDUvCzkw8etDcaVyOEMjkATdps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 32/93] fs/jfs: fix potential integer overflow on shift of a int
Date:   Mon,  1 Mar 2021 17:12:44 +0100
Message-Id: <20210301161008.496882817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index 2d514c7affc2a..9ff510a489cb1 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1669,7 +1669,7 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
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



