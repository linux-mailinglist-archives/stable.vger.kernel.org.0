Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0731D5942A3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350353AbiHOVwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350586AbiHOVvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53FD106FB3;
        Mon, 15 Aug 2022 12:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E14C960FB9;
        Mon, 15 Aug 2022 19:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B440C433D6;
        Mon, 15 Aug 2022 19:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591989;
        bh=8O+aw44hiz3gQ+R3zmwagrKbzLPzdYibj+A58m4ChMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qupxr4FQ59hXqUMVt4lNhtKeBGAVS8TtDm3MFPKVeNOrD7muqwhvjGVXe+how6/vT
         EPYf1N2mvc+d2bw/xCzVX16mpFZNFIuZ2Nl0mXLE4wOszALX7BnuCjl99NCSOWzu16
         lNVAy3pbfw7uioespEoAaY5z1hKaZC6Y/XTaLkmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yushan Zhou <katrinzhou@tencent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0714/1095] kernfs: fix potential NULL dereference in __kernfs_remove
Date:   Mon, 15 Aug 2022 20:01:53 +0200
Message-Id: <20220815180458.935428494@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yushan Zhou <katrinzhou@tencent.com>

[ Upstream commit 72b5d5aef246a0387cefa23121dd90901c7a691a ]

When lockdep is enabled, lockdep_assert_held_write would
cause potential NULL pointer dereference.

Fix the following smatch warnings:

fs/kernfs/dir.c:1353 __kernfs_remove() warn: variable dereferenced before check 'kn' (see line 1346)

Fixes: 393c3714081a ("kernfs: switch global kernfs_rwsem lock to per-fs lock")
Signed-off-by: Yushan Zhou <katrinzhou@tencent.com>
Link: https://lore.kernel.org/r/20220630082512.3482581-1-zys.zljxml@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 6eca72cfa1f2..1cc88ba6de90 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1343,14 +1343,17 @@ static void __kernfs_remove(struct kernfs_node *kn)
 {
 	struct kernfs_node *pos;
 
+	/* Short-circuit if non-root @kn has already finished removal. */
+	if (!kn)
+		return;
+
 	lockdep_assert_held_write(&kernfs_root(kn)->kernfs_rwsem);
 
 	/*
-	 * Short-circuit if non-root @kn has already finished removal.
 	 * This is for kernfs_remove_self() which plays with active ref
 	 * after removal.
 	 */
-	if (!kn || (kn->parent && RB_EMPTY_NODE(&kn->rb)))
+	if (kn->parent && RB_EMPTY_NODE(&kn->rb))
 		return;
 
 	pr_debug("kernfs %s: removing\n", kn->name);
-- 
2.35.1



