Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C583594738
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiHOXWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245066AbiHOXUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A830F14A1F4;
        Mon, 15 Aug 2022 13:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44E68612E8;
        Mon, 15 Aug 2022 20:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC46C433D6;
        Mon, 15 Aug 2022 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593846;
        bh=PTZjMZz3dY7nGwXr/zmNJG3phN1LRfO3lK1lVY9wDPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypWxWOvwn4gDr8s0uDyhRPlRAlaEa9s4G08qS26f2msANaR28armkDKCXPbvR3/Xm
         3imAiZjZ78lmTcLB8Pxj40mbdsvU8x4qCnGIDJWtEzaA714f3hgc8FcYrONr75jpDT
         9QZviPRj6KIuAmtZkcqNSkLlZQaiViIKsDybkRUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1015/1095] btrfs: reset block group chunk force if we have to wait
Date:   Mon, 15 Aug 2022 20:06:54 +0200
Message-Id: <20220815180511.083835595@linuxfoundation.org>
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
index 667b7025d503..1deca5164c23 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3724,6 +3724,7 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			 * attempt.
 			 */
 			wait_for_alloc = true;
+			force = CHUNK_ALLOC_NO_FORCE;
 			spin_unlock(&space_info->lock);
 			mutex_lock(&fs_info->chunk_mutex);
 			mutex_unlock(&fs_info->chunk_mutex);
-- 
2.35.1



