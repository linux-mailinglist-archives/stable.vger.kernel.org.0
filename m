Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89C59E108
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357671AbiHWLma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352185AbiHWLi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:38:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C58AE5D;
        Tue, 23 Aug 2022 02:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E85C5B81C97;
        Tue, 23 Aug 2022 09:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245F6C433C1;
        Tue, 23 Aug 2022 09:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246902;
        bh=K+xC2B7yXHKQSBu1Ps72dpcme431uHzv0qF71KFVKdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMU4OTsTQyv2UGvuvhdPEF7+BUmWBlVnXcYdxZ+wRAiLeaUt5F4Wt07YkP3f8WQQO
         smc/5u7uC7Sy6edzG7hKrugAlGFnxIXyARz2w2Blov12j2cM98zNR7x8ajX25VkdAt
         8lZDPVpe9pKAs0vf5++5Ip09BzKuZi6C1OnvOXGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 256/389] btrfs: reset block group chunk force if we have to wait
Date:   Tue, 23 Aug 2022 10:25:34 +0200
Message-Id: <20220823080126.299999279@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

commit 1314ca78b2c35d3e7d0f097268a2ee6dc0d369ef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2938,6 +2938,7 @@ int btrfs_chunk_alloc(struct btrfs_trans
 			 * attempt.
 			 */
 			wait_for_alloc = true;
+			force = CHUNK_ALLOC_NO_FORCE;
 			spin_unlock(&space_info->lock);
 			mutex_lock(&fs_info->chunk_mutex);
 			mutex_unlock(&fs_info->chunk_mutex);


