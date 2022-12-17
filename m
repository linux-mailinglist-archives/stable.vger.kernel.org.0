Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB60164FA68
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiLQPfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiLQPfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:35:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED291C434;
        Sat, 17 Dec 2022 07:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BDE8B802C8;
        Sat, 17 Dec 2022 15:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E32C433EF;
        Sat, 17 Dec 2022 15:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290975;
        bh=RYss35YBiSHYW6jia5CXq5W9mcuo/MeIPKr5eUkyKZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP8r3ip71/8Zr5++7sXQf4Cvx5RKVYgZq+lUjZBQkNPc02gfH4oIbs0Dc6NVFG3sx
         AiuTnUOs3PptF3ofeycD2/pDoyMIHA8pL/UGgNhvxE1x3hnIqHLYMMB5s8rg5mTAx9
         PZuUfMdS15W5Uv34R8/Zx5gGJlDz5VOO0PMLUlSLsVpt/FJW1WKhp8YLGv4SObCZaN
         AvzGxe+gKe+/9bi6h8YrT86zp0lNOAC9JeNt7d42vLsUPTjVLGdqdeDRqjWWmBUdsi
         JAYAlF6typJrJF7COxPXIQBWBicwGmh/Y2Os+3NWCXJB7g3ZbHGOmDGCNIxh+r+lC8
         0gxGk3cddppIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoi Pok Wu <wuhoipok@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>, shaggy@kernel.org,
        paskripkin@gmail.com, mudongliangabcd@gmail.com, r33s3n6@gmail.com,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 3/9] fs: jfs: fix shift-out-of-bounds in dbDiscardAG
Date:   Sat, 17 Dec 2022 10:29:20 -0500
Message-Id: <20221217152927.99012-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152927.99012-1-sashal@kernel.org>
References: <20221217152927.99012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoi Pok Wu <wuhoipok@gmail.com>

[ Upstream commit 25e70c6162f207828dd405b432d8f2a98dbf7082 ]

This should be applied to most URSAN bugs found recently by syzbot,
by guarding the dbMount. As syzbot feeding rubbish into the bmap
descriptor.

Signed-off-by: Hoi Pok Wu <wuhoipok@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index b0a65aaed43e..2c9493011aec 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -198,6 +198,11 @@ int dbMount(struct inode *ipbmap)
 		goto err_release_metapage;
 	}
 
+	if (((bmp->db_mapsize - 1) >> bmp->db_agl2size) > MAXAG) {
+		err = -EINVAL;
+		goto err_release_metapage;
+	}
+
 	for (i = 0; i < MAXAG; i++)
 		bmp->db_agfree[i] = le64_to_cpu(dbmp_le->dn_agfree[i]);
 	bmp->db_agsize = le64_to_cpu(dbmp_le->dn_agsize);
-- 
2.35.1

