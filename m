Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D55594C5E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244209AbiHPA7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345249AbiHPA4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:56:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4CEDAA3C;
        Mon, 15 Aug 2022 13:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECB6861255;
        Mon, 15 Aug 2022 20:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB1EC433C1;
        Mon, 15 Aug 2022 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596500;
        bh=4BnIrXYRqN01St2n7dxsaGgN/+3PG5oNAtHvK8qvYCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rds2EpvM5ANOqpbKz3Rm2cJ/kgRDKeiftgohLRlX7xgPqfv6Mb1tl3I0XGwooBNNH
         UFbAFxj0s14AWu0sYT3HIBeOgmHtF95OoAzfkUlCXS3bebTY5CuZowdacnt5z5W8bO
         t3G/2jcynM2po4E9fwxkca720RyQgJ7F5lpwcZA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1082/1157] btrfs: reset block group chunk force if we have to wait
Date:   Mon, 15 Aug 2022 20:07:18 +0200
Message-Id: <20220815180523.442276351@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index ede389f2602d..13358fbc1629 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3761,6 +3761,7 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			 * attempt.
 			 */
 			wait_for_alloc = true;
+			force = CHUNK_ALLOC_NO_FORCE;
 			spin_unlock(&space_info->lock);
 			mutex_lock(&fs_info->chunk_mutex);
 			mutex_unlock(&fs_info->chunk_mutex);
-- 
2.35.1



