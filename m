Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EA44AFB82
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbiBISr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241232AbiBISqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:46:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157ABC033245;
        Wed,  9 Feb 2022 10:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFBCE61194;
        Wed,  9 Feb 2022 18:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF2C340EE;
        Wed,  9 Feb 2022 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432227;
        bh=rU+l+UW0khed3sG8o6fuTidWsmMBuScY+PYN/6e420o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsaSEqsWOpQXpcAb1qinAvsWLBGH1WwcCtefctxtloAfw5Uv2QpUEDnBcx4tjP3Xu
         lXztN9AE4C0DBoMpFeOHvKT4xdnQNT0TZ8u8GjCJ6NzglhhSvQg3+43N9Jj6lOdrB8
         9yCdTBGvlfvvcEQdz9xpFWwowdfbh77ppB3yyo3V6XbKC2XSpOkdU6LwVoq/XQQmk1
         Z73u55cSPHblzPhiNY7IlRsiQ7G7AeDytrnTMnc+maW5tUUgrcAi5b9R/3jXIjsUSW
         yN0dVNlBr3epSvj7FZsi0WxcQMDwYgs6NDcj7R7J99BXPgUjRr4SPU9SMfEvfDWDAq
         HrdexQqU6imng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/15] btrfs: tree-checker: check item_size for dev_item
Date:   Wed,  9 Feb 2022 13:42:56 -0500
Message-Id: <20220209184305.47983-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184305.47983-1-sashal@kernel.org>
References: <20220209184305.47983-1-sashal@kernel.org>
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

From: Su Yue <l@damenly.su>

[ Upstream commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d ]

Check item size before accessing the device item to avoid out of bound
access, similar to inode_item check.

Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 368c43c6cbd08..d6e0eeb82fa9e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -764,6 +764,7 @@ static int check_dev_item(struct extent_buffer *leaf,
 			  struct btrfs_key *key, int slot)
 {
 	struct btrfs_dev_item *ditem;
+	const u32 item_size = btrfs_item_size(leaf, slot);
 
 	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
 		dev_item_err(leaf, slot,
@@ -771,6 +772,13 @@ static int check_dev_item(struct extent_buffer *leaf,
 			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
 		return -EUCLEAN;
 	}
+
+	if (unlikely(item_size != sizeof(*ditem))) {
+		dev_item_err(leaf, slot, "invalid item size: has %u expect %zu",
+			     item_size, sizeof(*ditem));
+		return -EUCLEAN;
+	}
+
 	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
 	if (btrfs_device_id(leaf, ditem) != key->offset) {
 		dev_item_err(leaf, slot,
-- 
2.34.1

