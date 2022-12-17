Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD01C64FA13
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiLQPbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLQPa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:30:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF72D15F3C;
        Sat, 17 Dec 2022 07:28:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C196B802C3;
        Sat, 17 Dec 2022 15:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D34C433F0;
        Sat, 17 Dec 2022 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290912;
        bh=QvL08K4TOjV+c1hptRTLJj/aEsioY1Kr+jIUnHrI1AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vK1MEKM17KqyELHMqQ3AIfLMuHJ3NZn+5JKXFWQq/qEnblUgZ7xOR9XCvR4ywWGi1
         XaVVnbLQKIUmT2HT34TRk0oYdq7Ijo9IXuNBVl8dbbkDQP3WGgl5Tpk+ghJFSURlXj
         ob4OS6Y+nyIoeURCkqeeb37lDqLAjm72BEl6B7mS4VINlLTluty4tg4fkvIA8UDhd/
         yEbZpz36j8IXHgfh3uL8adpKkMxi/vty7yo3OAPLOVl92fjcjIP1O5qxyxA1Pxg1J/
         bdQ4uOo+q+IhebsqpZsCEo5af8jlRHndmVLWJRsil9wLycSvFQCj6Q7vI9ZxdTn3K9
         YZCgQ+FVOKRAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoi Pok Wu <wuhoipok@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>, shaggy@kernel.org,
        r33s3n6@gmail.com, mudongliangabcd@gmail.com, paskripkin@gmail.com,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.0 04/16] fs: jfs: fix shift-out-of-bounds in dbDiscardAG
Date:   Sat, 17 Dec 2022 10:28:07 -0500
Message-Id: <20221217152821.98618-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152821.98618-1-sashal@kernel.org>
References: <20221217152821.98618-1-sashal@kernel.org>
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
index e1cbfbb60303..765838578a72 100644
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

