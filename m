Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4126677D5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbjALOtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240077AbjALOsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:48:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD56422
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E26DCB81E7B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8B6C433EF;
        Thu, 12 Jan 2023 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534163;
        bh=+Xgvel0DB2e8XxUZBurMAiK5uaFTJ4+VuRWgVfNj1i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r53weChRKl4w1GU45C6h71uBq+EmROH2UfaMOvNRZvZSNav9X659oHsjTx8rzBpjH
         rVIjDbwvtlsRYPHK8tx6h3lO7tZdUah+hsLKvJ5WMhHi1I27r71M6wFKxYITUXihtw
         L7dDCgx5rehnBnzkArOljyLKVWEjlKP4DSf/8C8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuqi Zhang <zhangshuqi3@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 716/783] ext4: use kmemdup() to replace kmalloc + memcpy
Date:   Thu, 12 Jan 2023 14:57:12 +0100
Message-Id: <20230112135557.568284987@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuqi Zhang <zhangshuqi3@huawei.com>

[ Upstream commit 4efd9f0d120c55b08852ee5605dbb02a77089a5d ]

Replace kmalloc + memcpy with kmemdup()

Signed-off-by: Shuqi Zhang <zhangshuqi3@huawei.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220525030120.803330-1-zhangshuqi3@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 74d045b426dd..0b682c92bfe9 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1890,11 +1890,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 			unlock_buffer(bs->bh);
 			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
+			s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
 			error = -ENOMEM;
 			if (s->base == NULL)
 				goto cleanup;
-			memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
 			s->first = ENTRY(header(s->base)+1);
 			header(s->base)->h_refcount = cpu_to_le32(1);
 			s->here = ENTRY(s->base + offset);
-- 
2.35.1



