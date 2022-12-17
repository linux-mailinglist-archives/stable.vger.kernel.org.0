Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F91364FAC5
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiLQPgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiLQPfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:35:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C10421E21;
        Sat, 17 Dec 2022 07:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03A14B801C0;
        Sat, 17 Dec 2022 15:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DA9C433EF;
        Sat, 17 Dec 2022 15:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290996;
        bh=6TcQBBX1CzeR/LzibstlHVzvK58/kuduSl11CldcE7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwhE6+JlaILyrArQIRV5HPgd4PJY++uE0UNa2b3xv4GhIAqmHiDM6xGfa9vO8JFCX
         lggPZns2FmJs2ofhR+Gu6JaMr+fr3eGGkzOGHevtWT7ob1rwOaHFAQRUyY0To1ovs7
         kpv+YZoc55OoHzXZ2J78rzVUsr5uyxPywdnUm0uchifXQdgdWXviHGmoJhZk4YKbSP
         h7xjMJa2IgBeyiFsJ19kT0Kv5wLiYwxee/hhXYcjm0PRqQ8Emee7wu69Wsn4XZkCI3
         R+EDU/pKQjFRN1Ro111Z4kRUBXN3PR9AT271/ga9cy1mvvlf5/lx0+TbNbPJg0Qw2q
         KXEaL5dzSrWiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoi Pok Wu <wuhoipok@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>, shaggy@kernel.org,
        r33s3n6@gmail.com, mudongliangabcd@gmail.com, paskripkin@gmail.com,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 3/9] fs: jfs: fix shift-out-of-bounds in dbDiscardAG
Date:   Sat, 17 Dec 2022 10:29:41 -0500
Message-Id: <20221217152949.99146-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152949.99146-1-sashal@kernel.org>
References: <20221217152949.99146-1-sashal@kernel.org>
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
index 3bcf98d01733..aa4643854f94 100644
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

