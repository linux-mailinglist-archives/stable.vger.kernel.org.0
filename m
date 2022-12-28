Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE933657B69
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiL1PVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiL1PVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:21:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA06214033
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:21:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D9A3B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DB8C433EF;
        Wed, 28 Dec 2022 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240874;
        bh=oAFmwgTa0iWjrNoNZpBerzG958B+wbIs72xunWuwJbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/I6xU0mSbNVI70Uqg3Rrbsou48mAnIpXf5i60r+Tj/ALkDd3eD1tLYgbXvjvzqmW
         270Rs+TcmaYDtCfuckV7TquMmKVWwdC7gw7dtyUx3/OzNYSFWgew692hj8EodAWFcA
         laRcq69mw4pm5xJoi04+/tGt71+rZOu1Mf140YkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2ae90e873e97f1faf6f2@syzkaller.appspotmail.com,
        Chao Yu <chao@kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0177/1146] erofs: validate the extent length for uncompressed pclusters
Date:   Wed, 28 Dec 2022 15:28:36 +0100
Message-Id: <20221228144334.963687449@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit c505feba4c0d76084e56ec498ce819f02a7043ae ]

syzkaller reported a KASAN use-after-free:
https://syzkaller.appspot.com/bug?extid=2ae90e873e97f1faf6f2

The referenced fuzzed image actually has two issues:
 - m_pa == 0 as a non-inlined pcluster;
 - The logical length is longer than its physical length.

The first issue has already been addressed.  This patch addresses
the second issue by checking the extent length validity.

Reported-by: syzbot+2ae90e873e97f1faf6f2@syzkaller.appspotmail.com
Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221205150050.47784-2-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index f49295b9f2e1..e6d5d7a18fb0 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -698,6 +698,11 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_PLAIN) {
+		if (map->m_llen > map->m_plen) {
+			DBG_BUGON(1);
+			err = -EFSCORRUPTED;
+			goto unmap_out;
+		}
 		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
 			map->m_algorithmformat =
 				Z_EROFS_COMPRESSION_INTERLACED;
-- 
2.35.1



