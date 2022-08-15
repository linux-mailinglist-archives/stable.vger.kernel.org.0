Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6945936BC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiHOSjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240890AbiHOSix (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:38:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A472F3D59A;
        Mon, 15 Aug 2022 11:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ABE76068D;
        Mon, 15 Aug 2022 18:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED809C433D7;
        Mon, 15 Aug 2022 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587827;
        bh=wxOLwuRbTjTq7t+voomz6BH+XUZah3K8GfdHFh66MGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKsFY2nAIKyAjvpZQYAJusxO5dHlBEoQML3cQsgDNgjoiyMG1D+aCkEFHJ+qXU/o+
         91EY07tirtpcvXkC9Ge4oP/3uTHe/vtzFcKiTIl7LOg67i1sW7Rp9Vp74hcLsfQuBw
         PrikwKwKtAsaoDVCcbXUvo1gWrKlagQvGyf7iFgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jinbao <liujinbao1@xiaomi.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/779] erofs: avoid consecutive detection for Highmem memory
Date:   Mon, 15 Aug 2022 19:57:31 +0200
Message-Id: <20220815180346.123733950@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 448b5a1548d87c246c3d0c3df8480d3c6eb6c11a ]

Currently, vmap()s are avoided if physical addresses are
consecutive for decompressed buffers.

I observed that is very common for 4KiB pclusters since the
numbers of decompressed pages are almost 2 or 3.

However, such detection doesn't work for Highmem pages on
32-bit machines, let's fix it now.

Reported-by: Liu Jinbao <liujinbao1@xiaomi.com>
Fixes: 7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
Link: https://lore.kernel.org/r/20220708101001.21242-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index ad3f31380e6b..8193c14bb111 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -93,14 +93,18 @@ static int z_erofs_lz4_prepare_destpages(struct z_erofs_decompress_req *rq,
 
 		if (page) {
 			__clear_bit(j, bounced);
-			if (kaddr) {
-				if (kaddr + PAGE_SIZE == page_address(page))
+			if (!PageHighMem(page)) {
+				if (!i) {
+					kaddr = page_address(page);
+					continue;
+				}
+				if (kaddr &&
+				    kaddr + PAGE_SIZE == page_address(page)) {
 					kaddr += PAGE_SIZE;
-				else
-					kaddr = NULL;
-			} else if (!i) {
-				kaddr = page_address(page);
+					continue;
+				}
 			}
+			kaddr = NULL;
 			continue;
 		}
 		kaddr = NULL;
-- 
2.35.1



