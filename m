Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE1E59A47B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353856AbiHSQqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353969AbiHSQpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E2B12A1D5;
        Fri, 19 Aug 2022 09:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13384B82813;
        Fri, 19 Aug 2022 16:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76290C433C1;
        Fri, 19 Aug 2022 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925452;
        bh=6hT71x1CMkbmOqJo9ddsM1RTrpcc699lUdE2v4Z5kVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lc2Fd/1M2c8DOJ0jEGOlc/mfEm7JVBgqFr7qeAuo4NJcREAgnuZ5t2FueN52aOB3P
         78qU06q6u2Sqe5fWgA3Qsp3iAwONtfvIcfTwVEVyXSsraUy3UBX/g39h4K6oADArbs
         IfA23HU2FBj7Ml7IC53DYUXNJRUbDPR6LWj7kbqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/545] btrfs: reset block group chunk force if we have to wait
Date:   Fri, 19 Aug 2022 17:44:25 +0200
Message-Id: <20220819153851.622425343@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index e351f5319950..889a598b17f6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3126,6 +3126,7 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			 * attempt.
 			 */
 			wait_for_alloc = true;
+			force = CHUNK_ALLOC_NO_FORCE;
 			spin_unlock(&space_info->lock);
 			mutex_lock(&fs_info->chunk_mutex);
 			mutex_unlock(&fs_info->chunk_mutex);
-- 
2.35.1



