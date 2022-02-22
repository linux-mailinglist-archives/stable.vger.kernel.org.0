Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDF34BF08A
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbiBVDcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:32:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239804AbiBVDcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:32:01 -0500
Received: from eu-shark2.inbox.eu (eu-shark2.inbox.eu [195.216.236.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518EE22B24;
        Mon, 21 Feb 2022 19:31:37 -0800 (PST)
Received: from eu-shark2.inbox.eu (localhost [127.0.0.1])
        by eu-shark2-out.inbox.eu (Postfix) with ESMTP id 793D61E005D4;
        Tue, 22 Feb 2022 05:31:35 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.eu; s=20140211;
        t=1645500695; bh=NtnJyKpV9k1yEsAnVj3J9ygtvI8iiW+8ZEQ9ZdLU7E0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:X-ESPOL:
         from:date:to:cc;
        b=BuJh/2nOqhBa1KJG7jnTOQzdg3QgyjTW9WBltTCbmMZGV6sH9hZW8WGWdNRpHf7Yn
         /QBkmoqrSnsOZwrh5QOxFVE0yQWVAGuLTVvBBk+aCJHhRD+2l5m5gX+E+fk0k+Vc7a
         WEnUOXeIPbpUOvklWUtkTXGYKkLkbkYn5Z4G4lsY=
Received: from localhost (localhost [127.0.0.1])
        by eu-shark2-in.inbox.eu (Postfix) with ESMTP id 6FBCE1E005C0;
        Tue, 22 Feb 2022 05:31:35 +0200 (EET)
Received: from eu-shark2.inbox.eu ([127.0.0.1])
        by localhost (eu-shark2.inbox.eu [127.0.0.1]) (spamfilter, port 35)
        with ESMTP id 2knqZhcgJOfx; Tue, 22 Feb 2022 05:31:35 +0200 (EET)
Received: from mail.inbox.eu (eu-pop1 [127.0.0.1])
        by eu-shark2-in.inbox.eu (Postfix) with ESMTP id E77EF1E00044;
        Tue, 22 Feb 2022 05:31:34 +0200 (EET)
From:   Su Yue <l@damenly.su>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Su Yue <l@damenly.su>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH stable 5.10.y 2/2] btrfs: tree-checker: check item_size for dev_item
Date:   Tue, 22 Feb 2022 11:31:17 +0800
Message-Id: <20220222033117.1421286-3-l@damenly.su>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220222033117.1421286-1-l@damenly.su>
References: <20220222033117.1421286-1-l@damenly.su>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: OK
X-ESPOL: 885mlYpNBD+giECgR3rABwY+s1k3Ua26u/vYpBBYmnv7MyaHf0wLTHLEkGhqPg+1xF8X
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d ]

Check item size before accessing the device item to avoid out of bound
access, similar to inode_item check.

Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-checker.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 692d372a54cd..51382d2be3d4 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -965,6 +965,7 @@ static int check_dev_item(struct extent_buffer *leaf,
 			  struct btrfs_key *key, int slot)
 {
 	struct btrfs_dev_item *ditem;
+	const u32 item_size = btrfs_item_size_nr(leaf, slot);
 
 	if (unlikely(key->objectid != BTRFS_DEV_ITEMS_OBJECTID)) {
 		dev_item_err(leaf, slot,
@@ -972,6 +973,13 @@ static int check_dev_item(struct extent_buffer *leaf,
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
 	if (unlikely(btrfs_device_id(leaf, ditem) != key->offset)) {
 		dev_item_err(leaf, slot,
-- 
2.34.1

