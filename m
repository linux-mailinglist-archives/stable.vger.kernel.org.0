Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A306B42E0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjCJOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjCJOH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:07:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492B1116C27
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:07:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C11AB822C3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D78AC433D2;
        Fri, 10 Mar 2023 14:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457241;
        bh=8lY5SP0eMFjUYMDwZ22966vW7MGBnjlSuuYs2z0LYfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjaddWNxHeAtAPzOU6IFXIW2WGC5ODfHLMt+Ez+3AKSDq+H6sYEEdIuSKE1pqa+6g
         EuO5NL0Dh9IRrukgORVsyhMtOJfAzCSJT0/hXPrOw3bDevYc/c8i71chfhea4c0uWk
         XG9ARVcgxBg9ZEsDfE/uLLSk8St9ZwHDAANBBmSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/200] ubifs: dirty_cow_znode: Fix memleak in error handling path
Date:   Fri, 10 Mar 2023 14:37:24 +0100
Message-Id: <20230310133718.190673390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

[ Upstream commit 122deabfe1428bffe95e2bf364ff8a5059bdf089 ]

Following process will cause a memleak for copied up znode:

dirty_cow_znode
  zn = copy_znode(c, znode);
  err = insert_old_idx(c, zbr->lnum, zbr->offs);
  if (unlikely(err))
     return ERR_PTR(err);   // No one refers to zn.

Fix it by adding copied znode back to tnc, then it will be freed
by ubifs_destroy_tnc_subtree() while closing tnc.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216705
Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 2df56bbc68657..2469f72eeaabb 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -267,11 +267,18 @@ static struct ubifs_znode *dirty_cow_znode(struct ubifs_info *c,
 	if (zbr->len) {
 		err = insert_old_idx(c, zbr->lnum, zbr->offs);
 		if (unlikely(err))
-			return ERR_PTR(err);
+			/*
+			 * Obsolete znodes will be freed by tnc_destroy_cnext()
+			 * or free_obsolete_znodes(), copied up znodes should
+			 * be added back to tnc and freed by
+			 * ubifs_destroy_tnc_subtree().
+			 */
+			goto out;
 		err = add_idx_dirt(c, zbr->lnum, zbr->len);
 	} else
 		err = 0;
 
+out:
 	zbr->znode = zn;
 	zbr->lnum = 0;
 	zbr->offs = 0;
-- 
2.39.2



