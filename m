Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11856B415B
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjCJNwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCJNv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:51:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B7B1116A2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80F7A618A8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633AAC433D2;
        Fri, 10 Mar 2023 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456315;
        bh=xj7+IUNj00YQqf7ddH622Mt0DjvvaInE3oAXYD0Sh6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/ntKexiK5Tv800jrLwz1KVj6+2xkZkPddz8i6Xlh0jLBjjt0YJjXQHt1vzClEZsX
         k+vRizctYhwXgYc5c3bjVzvD/QGmZPEj/jxAdmkgtn2z6ddTVnZx3ELxHh1qdiJa1f
         azahFCd8aOlUqEQsNIBzRF61KfkwShlsmDA6w5YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 154/193] ubifs: Fix wrong dirty space budget for dirty inode
Date:   Fri, 10 Mar 2023 14:38:56 +0100
Message-Id: <20230310133716.318527746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit b248eaf049d9cdc5eb76b59399e4d3de233f02ac ]

Each dirty inode should reserve 'c->bi.inode_budget' bytes in space
budget calculation. Currently, space budget for dirty inode reports
more space than what UBIFS actually needs to write.

Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/budget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 11a11b32a2a90..e6b5d61a4e203 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -415,7 +415,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
 	dd_growth = req->dirtied_page ? c->bi.page_budget : 0;
 
 	if (req->dirtied_ino)
-		dd_growth += c->bi.inode_budget << (req->dirtied_ino - 1);
+		dd_growth += c->bi.inode_budget * req->dirtied_ino;
 	if (req->mod_dent)
 		dd_growth += c->bi.dent_budget;
 	dd_growth += req->dirtied_ino_d;
-- 
2.39.2



