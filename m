Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956A16D4A45
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbjDCOpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjDCOpn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:45:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCE918253
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7649B81D45
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224BFC433D2;
        Mon,  3 Apr 2023 14:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533113;
        bh=DV0cOeSX8PNOFn5ooCFW/+sKVpj7bKAX1Y/CH1juOtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSQ439UuOqvdvKQQUG97Ex0MbN0qJwQ8V6jjZeyVxq9ehpwuD1LDvFa+ykeM1bgc+
         /nnpQFDbCLprOq2VsgZ+Rd46chxsxkrxvkZ4T1qBk1iKxJQl2oN2YMxW7aUR3ikmNb
         aWYW1QF0i8ZNoyERKoWE2HOWPV5lNTtp8ZuNtMc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 060/187] btrfs: fix uninitialized variable warning in btrfs_update_block_group
Date:   Mon,  3 Apr 2023 16:08:25 +0200
Message-Id: <20230403140417.935627566@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit efbf35a102b20246cfe4409c6ae92e72ecb67ab8 ]

reclaim isn't set in the alloc case, however we only care about
reclaim in the !alloc case.  This isn't an actual problem, however
-Wmaybe-uninitialized will complain, so initialize reclaim to quiet the
compiler.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: df384da5a49c ("btrfs: use temporary variable for space_info in btrfs_update_block_group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8eb625318e785..f40e56d44276d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3336,7 +3336,7 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 	spin_unlock(&info->delalloc_root_lock);
 
 	while (total) {
-		bool reclaim;
+		bool reclaim = false;
 
 		cache = btrfs_lookup_block_group(info, bytenr);
 		if (!cache) {
-- 
2.39.2



