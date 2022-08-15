Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38F6593DAC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbiHOTys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243301AbiHOTx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0824507A;
        Mon, 15 Aug 2022 11:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02927611D6;
        Mon, 15 Aug 2022 18:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84A8C433C1;
        Mon, 15 Aug 2022 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589494;
        bh=KgM26IDDNeoeGPt3vo1EHsfuuNWehWz9F9mk5GOilFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDY5cRNggENnN4/U10hQqt0RxcOQaK9Fl7IDPlBbXbna+UOgsFJWA2ko/pgqfkoVF
         BRFpAWu5Dg1bT7TgyfItWng4YHF3hwAvWzw0Rleo4ApSsR3IHEF0cH8Pa99VKCXvPI
         PlwtWzE3BcIZUu3TZHLwT8X4cfR4SN/ENUaHrmR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 728/779] btrfs: reset block group chunk force if we have to wait
Date:   Mon, 15 Aug 2022 20:06:12 +0200
Message-Id: <20220815180408.573445546@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1314ca78b2c35d3e7d0f097268a2ee6dc0d369ef ]

If you try to force a chunk allocation, but you race with another chunk
allocation, you will end up waiting on the chunk allocation that just
occurred and then allocate another chunk.  If you have many threads all
doing this at once you can way over-allocate chunks.

Fix this by resetting force to NO_FORCE, that way if we think we need to
allocate we can, otherwise we don't force another chunk allocation if
one is already happening.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c6c5a22ff6e8..4b2282aa274e 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3632,6 +3632,7 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			 * attempt.
 			 */
 			wait_for_alloc = true;
+			force = CHUNK_ALLOC_NO_FORCE;
 			spin_unlock(&space_info->lock);
 			mutex_lock(&fs_info->chunk_mutex);
 			mutex_unlock(&fs_info->chunk_mutex);
-- 
2.35.1



