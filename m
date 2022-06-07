Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40EC541B6A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378733AbiFGVrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381972AbiFGVpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AEB235252;
        Tue,  7 Jun 2022 12:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6241EB823B2;
        Tue,  7 Jun 2022 19:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3764C385A2;
        Tue,  7 Jun 2022 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628855;
        bh=p/vWRLsXaxn69jFFiFCh3tIbEqu+F8JroeQeTdsr9i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NttA6XJRqA7iWrcCM2eTtwyNY6NZSa9N0C/Hf7FMf+4rux+7c4nfohjkMrNGlSUyP
         mXeQH+avgnW0cp1pbhGuj2QYBTGhh5cHOwmTxwabSeRQkfmZwoXExRj4vUiq/fZjBw
         HvbhszrCDrFo7LTao4mCz0uJA98LMJ/CUFNFZqnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yue Hu <huyue2@coolpad.com>,
        Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 480/879] erofs: fix buffer copy overflow of ztailpacking feature
Date:   Tue,  7 Jun 2022 18:59:58 +0200
Message-Id: <20220607165016.809309386@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit dcbe6803fffd387f72b48c2373b5f5ed12a5804b ]

I got some KASAN report as below:

[   46.959738] ==================================================================
[   46.960430] BUG: KASAN: use-after-free in z_erofs_shifted_transform+0x2bd/0x370
[   46.960430] Read of size 4074 at addr ffff8880300c2f8e by task fssum/188
...
[   46.960430] Call Trace:
[   46.960430]  <TASK>
[   46.960430]  dump_stack_lvl+0x41/0x5e
[   46.960430]  print_report.cold+0xb2/0x6b7
[   46.960430]  ? z_erofs_shifted_transform+0x2bd/0x370
[   46.960430]  kasan_report+0x8a/0x140
[   46.960430]  ? z_erofs_shifted_transform+0x2bd/0x370
[   46.960430]  kasan_check_range+0x14d/0x1d0
[   46.960430]  memcpy+0x20/0x60
[   46.960430]  z_erofs_shifted_transform+0x2bd/0x370
[   46.960430]  z_erofs_decompress_pcluster+0xaae/0x1080

The root cause is that the tail pcluster won't be a complete filesystem
block anymore. So if ztailpacking is used, the second part of an
uncompressed tail pcluster may not be ``rq->pageofs_out``.

Fixes: ab749badf9f4 ("erofs: support unaligned data decompression")
Fixes: cecf864d3d76 ("erofs: support inline data decompression")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20220512115833.24175-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 3efa686c7644..0e0d1fc0f130 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -322,6 +322,7 @@ static int z_erofs_shifted_transform(struct z_erofs_decompress_req *rq,
 		PAGE_ALIGN(rq->pageofs_out + rq->outputsize) >> PAGE_SHIFT;
 	const unsigned int righthalf = min_t(unsigned int, rq->outputsize,
 					     PAGE_SIZE - rq->pageofs_out);
+	const unsigned int lefthalf = rq->outputsize - righthalf;
 	unsigned char *src, *dst;
 
 	if (nrpages_out > 2) {
@@ -344,10 +345,10 @@ static int z_erofs_shifted_transform(struct z_erofs_decompress_req *rq,
 	if (nrpages_out == 2) {
 		DBG_BUGON(!rq->out[1]);
 		if (rq->out[1] == *rq->in) {
-			memmove(src, src + righthalf, rq->pageofs_out);
+			memmove(src, src + righthalf, lefthalf);
 		} else {
 			dst = kmap_atomic(rq->out[1]);
-			memcpy(dst, src + righthalf, rq->pageofs_out);
+			memcpy(dst, src + righthalf, lefthalf);
 			kunmap_atomic(dst);
 		}
 	}
-- 
2.35.1



