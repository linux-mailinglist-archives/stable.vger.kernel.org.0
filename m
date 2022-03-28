Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F454EA054
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343735AbiC1Tqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343734AbiC1Tpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6430B6832A;
        Mon, 28 Mar 2022 12:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E62612BE;
        Mon, 28 Mar 2022 19:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0842CC36AE7;
        Mon, 28 Mar 2022 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496568;
        bh=MvTTP9R9TXzA2Tfx290JmG7oApwY5spRY7dG7g9GEyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ra/PkaTQdCqeMXVm7cbNKaiAWrqLinUgMNixJ5nqTdP8fduPweLIMeWfOTP3tc61T
         ZEXkPb2umn7w8wZAaclTymthwo6InhyeS1zHkymUx3OmMdq8I0dLjnTLQI2C+UUiBH
         UuSA2az/AeFoNHTDy7LVxZsLvhW3dd08rNWjbNJAscYfkM7pg3C09Gkea3uJyVf0BW
         Rhtn2WqgAqB+T8Xh8eIQGuu6abTsk5pHtnj9EQWdozYlXeYIILdz6ne56AcREOI/zx
         cPtesfHDaS33Lp2ImbAhGbVRVCw6gxkhDDI9IH6VZ5j7e6yx5O81QEkc8mtR+wn4jt
         DEpj3Jke3LsCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Boris Burkov <boris@bur.io>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 13/20] btrfs: make search_csum_tree return 0 if we get -EFBIG
Date:   Mon, 28 Mar 2022 15:42:19 -0400
Message-Id: <20220328194226.1585920-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194226.1585920-1-sashal@kernel.org>
References: <20220328194226.1585920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 03ddb19d2ea745228879b9334f3b550c88acb10a ]

We can either fail to find a csum entry at all and return -ENOENT, or we
can find a range that is close, but return -EFBIG.  In essence these
both mean the same thing when we are doing a lookup for a csum in an
existing range, we didn't find a csum.  We want to treat both of these
errors the same way, complain loudly that there wasn't a csum.  This
currently happens anyway because we do

	count = search_csum_tree();
	if (count <= 0) {
		// reloc and error handling
	}

However it forces us to incorrectly treat EIO or ENOMEM errors as on
disk corruption.  Fix this by returning 0 if we get either -ENOENT or
-EFBIG from btrfs_lookup_csum() so we can do proper error handling.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 8e6ff09f5c36..bddb9c87030b 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -303,7 +303,7 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
 	read_extent_buffer(path->nodes[0], dst, (unsigned long)item,
 			ret * csum_size);
 out:
-	if (ret == -ENOENT)
+	if (ret == -ENOENT || ret == -EFBIG)
 		ret = 0;
 	return ret;
 }
-- 
2.34.1

