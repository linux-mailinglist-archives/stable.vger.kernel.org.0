Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478B95B83B8
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiINJC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiINJCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1329B75CE8;
        Wed, 14 Sep 2022 02:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D788961993;
        Wed, 14 Sep 2022 09:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A391C4314D;
        Wed, 14 Sep 2022 09:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146106;
        bh=JdMp0tL/WYz7aMI5W+ok4n61pyN20Xzjsnk/FLBASgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyjfQpSAvD/IWHSyAWr7/j/GYA5c4fp0AGgKdN9TYD+Cl4w+xNikoSzXIWybwBPw0
         AYyB6zboa0WCQaql7CwjdxiRioMl4q59NaA8qb+PCZJDWjpGnNXksqAy+uxtlB+0H8
         8aflC3A/5fGKnzAKBMor4DvZI6BfAhOH3Cotk5ACxQ5WAitSRBlcqGFYnllIJVAKri
         EQo1Ds+qctSYFulECyU83x2He36rEC5VPfJwUohKlgcHXjn73AnGEG5zkbcdotOv2D
         wavkK6Hi1ZHb4KjM+G8nGajcLlv9U/swv12iKwIshNk2EkepO2h/flIyIgdZHnwuX8
         L5L+QmbEefU4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yue Hu <huyue2@coolpad.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>,
        xiang@kernel.org, linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 12/22] erofs: avoid the potentially wrong m_plen for big pcluster
Date:   Wed, 14 Sep 2022 05:00:53 -0400
Message-Id: <20220914090103.470630-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yue Hu <huyue2@coolpad.com>

[ Upstream commit ea0b7b0d59e81a9c1bc03f8696bb04851bc2ad22 ]

Actually, 'compressedlcs' stores compressed block count rather than
lcluster count. Therefore, the number of bits for shifting the count
should be 'LOG_BLOCK_SIZE' rather than 'lclusterbits' although current
lcluster size is 4K.

The value of 'm_plen' will be wrong once we enable the non 4K-sized
lcluster.

Signed-off-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20220812060150.8510-1-huyue2@coolpad.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 572f0b8151ba8..d58549ca1df9b 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -141,7 +141,7 @@ struct z_erofs_maprecorder {
 	u8  type, headtype;
 	u16 clusterofs;
 	u16 delta[2];
-	erofs_blk_t pblk, compressedlcs;
+	erofs_blk_t pblk, compressedblks;
 	erofs_off_t nextpackoff;
 };
 
@@ -192,7 +192,7 @@ static int legacy_load_cluster_from_disk(struct z_erofs_maprecorder *m,
 				DBG_BUGON(1);
 				return -EFSCORRUPTED;
 			}
-			m->compressedlcs = m->delta[0] &
+			m->compressedblks = m->delta[0] &
 				~Z_EROFS_VLE_DI_D0_CBLKCNT;
 			m->delta[0] = 1;
 		}
@@ -293,7 +293,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 				DBG_BUGON(1);
 				return -EFSCORRUPTED;
 			}
-			m->compressedlcs = lo & ~Z_EROFS_VLE_DI_D0_CBLKCNT;
+			m->compressedblks = lo & ~Z_EROFS_VLE_DI_D0_CBLKCNT;
 			m->delta[0] = 1;
 			return 0;
 		} else if (i + 1 != (int)vcnt) {
@@ -497,7 +497,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 		return 0;
 	}
 	lcn = m->lcn + 1;
-	if (m->compressedlcs)
+	if (m->compressedblks)
 		goto out;
 
 	err = z_erofs_load_cluster_from_disk(m, lcn, false);
@@ -506,7 +506,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 
 	/*
 	 * If the 1st NONHEAD lcluster has already been handled initially w/o
-	 * valid compressedlcs, which means at least it mustn't be CBLKCNT, or
+	 * valid compressedblks, which means at least it mustn't be CBLKCNT, or
 	 * an internal implemenatation error is detected.
 	 *
 	 * The following code can also handle it properly anyway, but let's
@@ -523,12 +523,12 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 		 * if the 1st NONHEAD lcluster is actually PLAIN or HEAD type
 		 * rather than CBLKCNT, it's a 1 lcluster-sized pcluster.
 		 */
-		m->compressedlcs = 1;
+		m->compressedblks = 1 << (lclusterbits - LOG_BLOCK_SIZE);
 		break;
 	case Z_EROFS_VLE_CLUSTER_TYPE_NONHEAD:
 		if (m->delta[0] != 1)
 			goto err_bonus_cblkcnt;
-		if (m->compressedlcs)
+		if (m->compressedblks)
 			break;
 		fallthrough;
 	default:
@@ -539,7 +539,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 		return -EFSCORRUPTED;
 	}
 out:
-	map->m_plen = (u64)m->compressedlcs << lclusterbits;
+	map->m_plen = (u64)m->compressedblks << LOG_BLOCK_SIZE;
 	return 0;
 err_bonus_cblkcnt:
 	erofs_err(m->inode->i_sb,
-- 
2.35.1

