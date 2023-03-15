Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217CB6BB16A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjCOM1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjCOM0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE0097B59
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C274E61D73
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9515C4339B;
        Wed, 15 Mar 2023 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883127;
        bh=Edrase2a+V9ntO5dtbFDUhndC+P8208cBlG9RBWJynE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koQnfU+16NdbcX3S3O0InsEctgWua9xe5UMcLREfGJRtLTgSFbfnMsrRCOD/koOon
         kPRQ58gQ6fijMxmPhc4Unaqa37rpGyV483Xmnh6WK9ET2bvFY+cqoAs8Cf6giEVFEp
         WjEC5VqDdfWk/c+5AvASSIMRXhdojfmfRJ9st/i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/145] f2fs: avoid down_write on nat_tree_lock during checkpoint
Date:   Wed, 15 Mar 2023 13:11:31 +0100
Message-Id: <20230315115739.868011504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0df035c7208c5e3e2ae7685548353ae536a19015 ]

Let's cache nat entry if there's no lock contention only.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 3aa51c61cb4a ("f2fs: retry to update the inode page given data corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f810c6bbeff02..7f00f3004a665 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -430,6 +430,10 @@ static void cache_nat_entry(struct f2fs_sb_info *sbi, nid_t nid,
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct nat_entry *new, *e;
 
+	/* Let's mitigate lock contention of nat_tree_lock during checkpoint */
+	if (rwsem_is_locked(&sbi->cp_global_sem))
+		return;
+
 	new = __alloc_nat_entry(sbi, nid, false);
 	if (!new)
 		return;
-- 
2.39.2



