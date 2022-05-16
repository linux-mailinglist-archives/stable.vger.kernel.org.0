Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1508529008
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346707AbiEPULu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347415AbiEPUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACF547576;
        Mon, 16 May 2022 12:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7498360F83;
        Mon, 16 May 2022 19:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ACAC34100;
        Mon, 16 May 2022 19:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731053;
        bh=cT2tFWx4y6h1jKST9Xbxf3XHUjKuhrR4MsISZKADkV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLorxxBqCMJj5NkHjrZn3fJ+HccMKkVv4+d9+bcMioF1e5NgJRWEsKLdGcOlNGSNS
         tFOp7B4P2Fx4QY26SbLN39y1KLbq1uo8QCuO/gC1caWMunOJckEt+bj7285AXyxnCj
         Z2GsSdAy/drNWbcyWsEqVC3FWF3y7taJ0hN17we4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 048/114] gfs2: Fix filesystem block deallocation for short writes
Date:   Mon, 16 May 2022 21:36:22 +0200
Message-Id: <20220516193626.873661114@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit d031a8866e709c9d1ee5537a321b6192b4d2dc5b ]

When a write cannot be carried out in full, gfs2_iomap_end() releases
blocks that have been allocated for this write but haven't been used.

To compute the end of the allocation, gfs2_iomap_end() incorrectly
rounded the end of the attempted write down to the next block boundary
to arrive at the end of the allocation.  It would have to round up, but
the end of the allocation is also available as iomap->offset +
iomap->length, so just use that instead.

In addition, use round_up() for computing the start of the unused range.

Fixes: 64bc06bb32ee ("gfs2: iomap buffered write support")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index fbdb7a30470a..f785af2aa23c 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1154,13 +1154,12 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
-		loff_t blockmask = i_blocksize(inode) - 1;
-		loff_t end = (pos + length) & ~blockmask;
+		loff_t hstart = round_up(pos + written, i_blocksize(inode));
+		loff_t hend = iomap->offset + iomap->length;
 
-		pos = (pos + written + blockmask) & ~blockmask;
-		if (pos < end) {
-			truncate_pagecache_range(inode, pos, end - 1);
-			punch_hole(ip, pos, end - pos);
+		if (hstart < hend) {
+			truncate_pagecache_range(inode, hstart, hend - 1);
+			punch_hole(ip, hstart, hend - hstart);
 		}
 	}
 
-- 
2.35.1



