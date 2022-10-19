Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE1160418A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiJSKpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiJSKo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBA5FF252;
        Wed, 19 Oct 2022 03:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 880CBB8244B;
        Wed, 19 Oct 2022 08:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4F8C433D6;
        Wed, 19 Oct 2022 08:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169980;
        bh=lngLkwhkCFJkeSEPKAQ6CC6D23gJ44NNGtDeFpeiMj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqHoEAJ0zo9zQzy9jp4RcGSe/qDMcJFKQ11wRO7Kj80fDcNX4Gf02ySR1IfWaZ6G4
         /pWmegeYpbvJkHIrrIZZaX1FjsUNUc/3xFpl2C7CjieLE3x9vC/8B+mWTqDwRd0dT/
         sv3+cYdSMjMINmIgaOflHnl2FA/mfOtB4gZdVLhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 449/862] ext4: dont run ext4lazyinit for read-only filesystems
Date:   Wed, 19 Oct 2022 10:28:56 +0200
Message-Id: <20221019083309.812535519@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

[ Upstream commit 426d15ad11419066f7042ffa8fbf1b5c21a1ecbe ]

On a read-only filesystem, we won't invoke the block allocator, so we
don't need to prefetch the block bitmaps.

This avoids starting and running the ext4lazyinit thread at all on a
system with no read-write ext4 filesystems (for instance, a container VM
with read-only filesystems underneath an overlayfs).

Fixes: 21175ca434c5 ("ext4: make prefetch_block_bitmaps default")
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Link: https://lore.kernel.org/r/48b41da1498fcac3287e2e06b660680646c1c050.1659323972.git.josh@joshtriplett.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 323dbcfd285c..091db733834e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3962,9 +3962,9 @@ int ext4_register_li_request(struct super_block *sb,
 		goto out;
 	}
 
-	if (test_opt(sb, NO_PREFETCH_BLOCK_BITMAPS) &&
-	    (first_not_zeroed == ngroups || sb_rdonly(sb) ||
-	     !test_opt(sb, INIT_INODE_TABLE)))
+	if (sb_rdonly(sb) ||
+	    (test_opt(sb, NO_PREFETCH_BLOCK_BITMAPS) &&
+	     (first_not_zeroed == ngroups || !test_opt(sb, INIT_INODE_TABLE))))
 		goto out;
 
 	elr = ext4_li_request_new(sb, first_not_zeroed);
-- 
2.35.1



