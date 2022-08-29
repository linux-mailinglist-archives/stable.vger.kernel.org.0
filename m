Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3E45A48FA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiH2LTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiH2LRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:17:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1F26CD07;
        Mon, 29 Aug 2022 04:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B41D611F6;
        Mon, 29 Aug 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F0CC433B5;
        Mon, 29 Aug 2022 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771410;
        bh=7UuEqefdwYEn11rNs3iQTPMDUVdZcXGP+H423jBrBT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xt1a9xSrRTaCMAMMsg2/KyTWWP59nFhbsD1HiFhIQClrcn5vUbO/Fm+0oNV18IBVy
         4N0ui6ntMN5Sk1RiNUfhXR0msrRPXtPN52ztUfxq+5nCRmlAeJjYQ6d4QI8B0+w7eg
         Hf6imUoiQHJ2CXyd504hFogOvtGwZOp+TGMJAVHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 64/86] btrfs: fix silent failure when deleting root reference
Date:   Mon, 29 Aug 2022 12:59:30 +0200
Message-Id: <20220829105759.164105549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 47bf225a8d2cccb15f7e8d4a1ed9b757dd86afd7 upstream.

At btrfs_del_root_ref(), if btrfs_search_slot() returns an error, we end
up returning from the function with a value of 0 (success). This happens
because the function returns the value stored in the variable 'err',
which is 0, while the error value we got from btrfs_search_slot() is
stored in the 'ret' variable.

So fix it by setting 'err' with the error value.

Fixes: 8289ed9f93bef2 ("btrfs: replace the BUG_ON in btrfs_del_root_ref with proper error handling")
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/root-tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -336,9 +336,10 @@ int btrfs_del_root_ref(struct btrfs_tran
 	key.offset = ref_id;
 again:
 	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		err = ret;
 		goto out;
-	if (ret == 0) {
+	} else if (ret == 0) {
 		leaf = path->nodes[0];
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_root_ref);


