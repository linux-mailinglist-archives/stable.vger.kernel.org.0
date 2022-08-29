Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964695A491B
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiH2LUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiH2LTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21543754B9;
        Mon, 29 Aug 2022 04:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF896611DD;
        Mon, 29 Aug 2022 11:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B996FC433C1;
        Mon, 29 Aug 2022 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771588;
        bh=eENv8UcVfNOwQo2gHGwHRC5eNFSdrkUeTqEzT+bnqJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=At8y6NToDdcFR/bKng7KTx14PAoLah1VlFsijHvYV1j0g3klIzuipY+bGLFqM5wtg
         mdOK2s365DiB5917qEa1/hHs/dLFbv2kqtoFAwQ98DWDEujF/kMCGKD50CdFzHYnA/
         4S5vCDmM7cZ8kBrkf4cbjDpnxWyv5HGkWo8/ZGSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 095/136] btrfs: fix silent failure when deleting root reference
Date:   Mon, 29 Aug 2022 12:59:22 +0200
Message-Id: <20220829105808.561184572@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
@@ -351,9 +351,10 @@ int btrfs_del_root_ref(struct btrfs_tran
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


