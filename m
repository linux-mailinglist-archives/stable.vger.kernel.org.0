Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A9657AC7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiL1PPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiL1POp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:14:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A978A13F03
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479B261551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6ABC433D2;
        Wed, 28 Dec 2022 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240483;
        bh=gSgm6LQQfsEO2y8HppxXCNE+XplTED457Yy7BzqRfgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BGh+ZhkTdKsM5vpgbfTjC/ExOAklt4MMxUGzRMht0X6yldH9kacI29XwoJa1JJbg
         rSJSFwNjfA0DQ9a3Qk+N1Tn0pKvdC7rEqunLDo2YPcVd36yjkn0uQquilmrDUwusK+
         +GDHZ3YiTQQlp2r+aqQy6+AHXdS0DJSfCtlLe4tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+6f8cd9a0155b366d227f@syzkaller.appspotmail.com,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yue Hu <huyue2@coolpad.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0166/1073] erofs: Fix pcluster memleak when its block address is zero
Date:   Wed, 28 Dec 2022 15:29:14 +0100
Message-Id: <20221228144332.524276437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit c42c0ffe81176940bd5dead474216b7198d77675 ]

syzkaller reported a memleak:
https://syzkaller.appspot.com/bug?id=62f37ff612f0021641eda5b17f056f1668aa9aed

unreferenced object 0xffff88811009c7f8 (size 136):
  ...
  backtrace:
    [<ffffffff821db19b>] z_erofs_do_read_page+0x99b/0x1740
    [<ffffffff821dee9e>] z_erofs_readahead+0x24e/0x580
    [<ffffffff814bc0d6>] read_pages+0x86/0x3d0
    ...

syzkaller constructed a case: in z_erofs_register_pcluster(),
ztailpacking = false and map->m_pa = zero. This makes pcl->obj.index be
zero although pcl is not a inline pcluster.

Then following path adds refcount for grp, but the refcount won't be put
because pcl is inline.

z_erofs_readahead()
  z_erofs_do_read_page() # for another page
    z_erofs_collector_begin()
      erofs_find_workgroup()
        erofs_workgroup_get()

Since it's illegal for the block address of a non-inlined pcluster to
be zero, add check here to avoid registering the pcluster which would
be leaked.

Fixes: cecf864d3d76 ("erofs: support inline data decompression")
Reported-by: syzbot+6f8cd9a0155b366d227f@syzkaller.appspotmail.com
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/Y42Kz6sVkf+XqJRB@debian
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index c7511b431776..f19875d96cc1 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -487,7 +487,8 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 	struct erofs_workgroup *grp;
 	int err;
 
-	if (!(map->m_flags & EROFS_MAP_ENCODED)) {
+	if (!(map->m_flags & EROFS_MAP_ENCODED) ||
+	    (!ztailpacking && !(map->m_pa >> PAGE_SHIFT))) {
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
 	}
-- 
2.35.1



