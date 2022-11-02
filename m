Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9EE615832
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKBCrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiKBCq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C02127C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C70B617A9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5005C433D6;
        Wed,  2 Nov 2022 02:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357217;
        bh=3iRPv9sDsGHVAQKdp04DjmJ8yH54S8JE/K/aYoE6Nnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqN6NdTwCgUbdNXQhfFrRRrbXIkkkuCZJOUljzBmihN+jVw4P3er2YuZHZTZrhN1d
         Ef/xH/4gCCQ/xUCVI4Or4M7d2JAa2o2qVagns6w1BSIpaXr+6tvmb3mzNm3H73PS5T
         pv18/5zHM1TZ40GtXC6VjpUQ2Qx6x8JCAcJPlOhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yue Hu <huyue2@coolpad.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 133/240] erofs: fix illegal unmapped accesses in z_erofs_fill_inode_lazy()
Date:   Wed,  2 Nov 2022 03:31:48 +0100
Message-Id: <20221102022114.389015809@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yue Hu <huyue2@coolpad.com>

[ Upstream commit 664609e49f1c84fc97987b2bf64544e586b8849c ]

Note that we are still accessing 'h_idata_size' and 'h_fragmentoff'
after calling erofs_put_metabuf(), that is not correct. Fix it.

Fixes: ab92184ff8f1 ("erofs: add on-disk compressed tail-packing inline support")
Fixes: b15b2e307c3a ("erofs: support on-disk compressed fragments data")
Signed-off-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221005013528.62977-1-zbestahu@163.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index d58549ca1df9..63fd2f146026 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -61,8 +61,7 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 
 	pos = ALIGN(iloc(EROFS_SB(sb), vi->nid) + vi->inode_isize +
 		    vi->xattr_isize, 8);
-	kaddr = erofs_read_metabuf(&buf, sb, erofs_blknr(pos),
-				   EROFS_KMAP_ATOMIC);
+	kaddr = erofs_read_metabuf(&buf, sb, erofs_blknr(pos), EROFS_KMAP);
 	if (IS_ERR(kaddr)) {
 		err = PTR_ERR(kaddr);
 		goto out_unlock;
@@ -79,7 +78,7 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
 			  headnr + 1, vi->z_algorithmtype[headnr], vi->nid);
 		err = -EOPNOTSUPP;
-		goto unmap_done;
+		goto out_put_metabuf;
 	}
 
 	vi->z_logical_clusterbits = LOG_BLOCK_SIZE + (h->h_clusterbits & 7);
@@ -89,7 +88,7 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		erofs_err(sb, "per-inode big pcluster without sb feature for nid %llu",
 			  vi->nid);
 		err = -EFSCORRUPTED;
-		goto unmap_done;
+		goto out_put_metabuf;
 	}
 	if (vi->datalayout == EROFS_INODE_FLAT_COMPRESSION &&
 	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1) ^
@@ -97,12 +96,8 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		erofs_err(sb, "big pcluster head1/2 of compact indexes should be consistent for nid %llu",
 			  vi->nid);
 		err = -EFSCORRUPTED;
-		goto unmap_done;
+		goto out_put_metabuf;
 	}
-unmap_done:
-	erofs_put_metabuf(&buf);
-	if (err)
-		goto out_unlock;
 
 	if (vi->z_advise & Z_EROFS_ADVISE_INLINE_PCLUSTER) {
 		struct erofs_map_blocks map = {
@@ -121,11 +116,13 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 			err = -EFSCORRUPTED;
 		}
 		if (err < 0)
-			goto out_unlock;
+			goto out_put_metabuf;
 	}
 	/* paired with smp_mb() at the beginning of the function */
 	smp_mb();
 	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
+out_put_metabuf:
+	erofs_put_metabuf(&buf);
 out_unlock:
 	clear_and_wake_up_bit(EROFS_I_BL_Z_BIT, &vi->flags);
 	return err;
-- 
2.35.1



