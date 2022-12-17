Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D01164FA5E
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiLQPiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiLQPhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:37:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B786F27DFE;
        Sat, 17 Dec 2022 07:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9F2A60C16;
        Sat, 17 Dec 2022 15:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C44C433EF;
        Sat, 17 Dec 2022 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671291019;
        bh=zEGb/aldPGaiODtUOb3D9loCCQlygfE6QPnqFRzjij8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPLX1xqyrXPDpwY5LOG0Irp6HUXNBy5Nx8wBciecdLjz2AxEtc+BJpe/1TBHyglEj
         4Hq704L69d0Wu9lI1KlSP4YerXJecOHlA71uGSr8ymk9fY6Er5+ApYFmMvTbMLmX7W
         RoXMV2O5daJo1i2f5873pqeDXD+pB/uzt9XzOhOqobYOWs32+Ib3C8fEJXz79ouwQ9
         iaa4EdBGqOYdn6VPEqQBheMvblJ4X+m4t0yRSsODmz+YWeMkUifvYXJOy87pQ1y33r
         2M14wZL6hqZ/q8MXevU8EkHicDpJ0EL2XL2wkDeg823BFQDoZKuT0EmXyeqDm1DSea
         gijoqn8DMmCqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoi Pok Wu <wuhoipok@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>, shaggy@kernel.org,
        mudongliangabcd@gmail.com, r33s3n6@gmail.com, paskripkin@gmail.com,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 3/8] fs: jfs: fix shift-out-of-bounds in dbDiscardAG
Date:   Sat, 17 Dec 2022 10:30:05 -0500
Message-Id: <20221217153012.99273-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217153012.99273-1-sashal@kernel.org>
References: <20221217153012.99273-1-sashal@kernel.org>
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
index 4f72f7dee78b..f06796cad9aa 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -211,6 +211,11 @@ int dbMount(struct inode *ipbmap)
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

