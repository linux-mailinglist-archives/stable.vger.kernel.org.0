Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA6C66769B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbjALOdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237719AbjALOdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:33:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08435F487
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92F1AB81E67
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC700C433EF;
        Thu, 12 Jan 2023 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533475;
        bh=RYss35YBiSHYW6jia5CXq5W9mcuo/MeIPKr5eUkyKZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5Zhd6sV9ZavA54kX7WJd5DkfFeY64f7pgXbwS+WIxlpH2b0SejA9Fwkq5wYtwZsO
         fzZOSbZbkPd20dYJYbOU9wMVglZkZi+i5CCOwpZL0cjTIX/lS4B8M2aPX+Dpp94Pag
         72YiTxY3Kc+mAX0dPKVbpnUaKdhOHBqi11P869QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hoi Pok Wu <wuhoipok@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/783] fs: jfs: fix shift-out-of-bounds in dbDiscardAG
Date:   Thu, 12 Jan 2023 14:53:26 +0100
Message-Id: <20230112135546.908120893@linuxfoundation.org>
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



