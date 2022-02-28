Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7784C75BC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbiB1R4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240781AbiB1Ryo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCBE52E70;
        Mon, 28 Feb 2022 09:43:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3813BB815B4;
        Mon, 28 Feb 2022 17:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913D0C340E7;
        Mon, 28 Feb 2022 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070196;
        bh=iFga6YH+/J5P1F70DLuXYIdRRbydZYEXgQ/zFZRibA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+abLN+aHn1vmAyJ/AhciN1UxaOGYjr9r7rtNGC8I4Pyb5AmlSmIVf+8D1riD8ImO
         Kus9VKY9A6x0/GnmWLP/85RzBGeAcf8PptEnyeofcYifzNJ3MT6a+6vHGtISg36Ett
         7M1lNwepswaNTUErvZ2gu5uiQ1cjgxESiRZBngtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <l@damenly.su>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 005/164] btrfs: tree-checker: check item_size for dev_item
Date:   Mon, 28 Feb 2022 18:22:47 +0100
Message-Id: <20220228172400.168572315@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <l@damenly.su>

commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d upstream.

Check item size before accessing the device item to avoid out of bound
access, similar to inode_item check.

Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -965,6 +965,7 @@ static int check_dev_item(struct extent_
 			  struct btrfs_key *key, int slot)
 {
 	struct btrfs_dev_item *ditem;
+	const u32 item_size = btrfs_item_size_nr(leaf, slot);
 
 	if (unlikely(key->objectid != BTRFS_DEV_ITEMS_OBJECTID)) {
 		dev_item_err(leaf, slot,
@@ -972,6 +973,13 @@ static int check_dev_item(struct extent_
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


