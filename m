Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58963567F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiKWJbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiKWJau (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AD88B111
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6181F619F9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14544C433C1;
        Wed, 23 Nov 2022 09:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195754;
        bh=QxUeB5WV+GSnRxYS4vTC0gkrV3wabEgLbnL4EVSYrEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTAhEZX4IgnV0Zv/fzPw794P2YqAl4BMLwJUgCWqKDITNv+5X6Bxw6Pv/siT++i6x
         yx9PgXHDZ4yo+i+i5iB8zf+Z/0IRd72z8n1rl40SnaJY4O8NM4HyH098VXBzSXs1Ir
         4oVGSLmsxRgofGN0nOgpnM/2xQsNxgSbhAcFrExM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/181] btrfs: raid56: properly handle the error when unable to find the missing stripe
Date:   Wed, 23 Nov 2022 09:49:46 +0100
Message-Id: <20221123084603.442992073@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit f15fb2cd979a07fbfc666e2f04b8b30ec9233b2a ]

In raid56_alloc_missing_rbio(), if we can not determine where the
missing device is inside the full stripe, we just BUG_ON().

This is not necessary especially the only caller inside scrub.c is
already properly checking the return value, and will treat it as a
memory allocation failure.

Fix the error handling by:

- Add an extra warning for the reason
  Although personally speaking it may be better to be an ASSERT().

- Properly free the allocated rbio

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid56.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 3157a26ddf7e..5b27c289139a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2728,8 +2728,10 @@ raid56_alloc_missing_rbio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
-		BUG();
-		kfree(rbio);
+		btrfs_warn_rl(fs_info,
+	"can not determine the failed stripe number for full stripe %llu",
+			      bioc->raid_map[0]);
+		__free_raid_bio(rbio);
 		return NULL;
 	}
 
-- 
2.35.1



