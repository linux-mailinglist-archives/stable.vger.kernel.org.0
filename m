Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8449C469B72
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351227AbhLFPRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33612 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348609AbhLFPNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:13:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F2A261322;
        Mon,  6 Dec 2021 15:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC44C341C2;
        Mon,  6 Dec 2021 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803379;
        bh=H0d5Y8z+TF/XRdKSWQ78s5VksBAwR20gQd7Ac13ow4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLja/JLOXcK9rVlGq3hbmJCpSHz5fkS1Uf0NXL0HHDvSl4UYHLIr01PoB96+IWll4
         j+OJaAtpqKfBiaq7wMF5y5xPJgpteFR5ZKqTd5/1LW6oXcMd5wCMdNEoDXolBLmQG+
         FKoSGHE2rXC7BZo0Tja8XRF8u5p3pjRoEezleqao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/48] gfs2: Fix length of holes reported at end-of-file
Date:   Mon,  6 Dec 2021 15:56:21 +0100
Message-Id: <20211206145549.004450031@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit f3506eee81d1f700d9ee2d2f4a88fddb669ec032 ]

Fix the length of holes reported at the end of a file: the length is
relative to the beginning of the extent, not the seek position which is
rounded down to the filesystem block size.

This bug went unnoticed for some time, but is now caught by the
following assertion in iomap_iter_done():

  WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 43f53020553b5..53ba5019ad063 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -943,7 +943,7 @@ static int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 		else if (height == ip->i_height)
 			ret = gfs2_hole_size(inode, lblock, len, mp, iomap);
 		else
-			iomap->length = size - pos;
+			iomap->length = size - iomap->offset;
 	} else if (flags & IOMAP_WRITE) {
 		u64 alloc_size;
 
-- 
2.33.0



