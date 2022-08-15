Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC80594753
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346690AbiHOXh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353690AbiHOXf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:35:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A7815176D;
        Mon, 15 Aug 2022 13:09:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67EB0CE1262;
        Mon, 15 Aug 2022 20:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E2EC433C1;
        Mon, 15 Aug 2022 20:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594151;
        bh=Ohh3paW8dP4iCobD3rCYKby9TRKkA45xwCV8Vho5sgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGtIFwRZh5BOUO7rnukeY/16OOfNmT89JqoNjCHqKJMzv/RPoz4CxCd/G5ddzYbi8
         4m6c2X5h4X+WAanO0Lld3wv/brHCxV0Kr6ULuQzjEWDdfuKC5Q0iLDLeHHF0hPHbUB
         vNBMukOmAmy4CZxp3aYjH0Exyq1gmNSOnKH7zrVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuqi Zhang <zhangshuqi3@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1064/1095] ext4: use kmemdup() to replace kmalloc + memcpy
Date:   Mon, 15 Aug 2022 20:07:43 +0200
Message-Id: <20220815180513.053676857@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Shuqi Zhang <zhangshuqi3@huawei.com>

[ Upstream commit 4efd9f0d120c55b08852ee5605dbb02a77089a5d ]

Replace kmalloc + memcpy with kmemdup()

Signed-off-by: Shuqi Zhang <zhangshuqi3@huawei.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220525030120.803330-1-zhangshuqi3@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b57fd07fbdba..d92d50de5a01 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1887,11 +1887,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
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



