Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1893C65B0EA
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbjABL3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235853AbjABL2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD016646B
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33CFF60F55
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4137DC433EF;
        Mon,  2 Jan 2023 11:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658880;
        bh=CUQgeZL9o7LKBweE0IFNpVS6PXCPvaJi16THmXaz4Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzRLPBvffnOn9kFV4s6d8KOB8qcWlAG29u2EdaduJgSwi4O8TUd6/gqg1TbaK2uBR
         T4CEexEYLHtFGMfQUn0pyu+hspO//OFRlsxxpKm5Sv2TGukHvsEif/K5cfeFCh8t7A
         LwPOqI7njYfTh7t/tx9SiSk3D8Wn7+AyYzlIptJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Andreas Herrmann <aherrmann@suse.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 04/74] blk-cgroup: remove open coded blkg_lookup instances
Date:   Mon,  2 Jan 2023 12:21:37 +0100
Message-Id: <20230102110552.245592859@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 79fcc5be93e5b17a2a5d36553f7a5c1ad9e953b6 ]

Use blkg_lookup instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 6 +++---
 block/blk-cgroup.h | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 11f256214928..ee48b6f4d5d4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -324,7 +324,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
-		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
+		blkg->parent = blkg_lookup(blkcg_parent(blkcg), q);
 		if (WARN_ON_ONCE(!blkg->parent)) {
 			ret = -ENODEV;
 			goto err_put_css;
@@ -412,7 +412,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct blkcg_gq *ret_blkg = q->root_blkg;
 
 		while (parent) {
-			blkg = __blkg_lookup(parent, q, false);
+			blkg = blkg_lookup(parent, q);
 			if (blkg) {
 				/* remember closest blkg */
 				ret_blkg = blkg;
@@ -724,7 +724,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
-		while (parent && !__blkg_lookup(parent, q, false)) {
+		while (parent && !blkg_lookup(parent, q)) {
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index c1fb00a1dfc0..30396cad50e9 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -362,8 +362,8 @@ static inline void blkg_put(struct blkcg_gq *blkg)
  */
 #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_pre((pos_css), &(p_blkg)->blkcg->css)	\
-		if (((d_blkg) = __blkg_lookup(css_to_blkcg(pos_css),	\
-					      (p_blkg)->q, false)))
+		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
+					    (p_blkg)->q)))
 
 /**
  * blkg_for_each_descendant_post - post-order walk of a blkg's descendants
@@ -377,8 +377,8 @@ static inline void blkg_put(struct blkcg_gq *blkg)
  */
 #define blkg_for_each_descendant_post(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_post((pos_css), &(p_blkg)->blkcg->css)	\
-		if (((d_blkg) = __blkg_lookup(css_to_blkcg(pos_css),	\
-					      (p_blkg)->q, false)))
+		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
+					    (p_blkg)->q)))
 
 bool __blkcg_punt_bio_submit(struct bio *bio);
 
-- 
2.35.1



