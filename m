Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9894F3903
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377484AbiDEL30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350939AbiDEKA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BB86B0B1;
        Tue,  5 Apr 2022 02:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E562661673;
        Tue,  5 Apr 2022 09:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED77DC385A1;
        Tue,  5 Apr 2022 09:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152280;
        bh=vmE0bnZ75a6VCIE9JhhC32nXIyUw3NHWkpsNVT7HH9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrHHyqXc9RkOhaWaviGyk4AjRkF3p4/ZqTo0wL+Jy04FCrfZAA2YnU+LPbBrRp9SO
         VqeyTxgTws4tFXHz70sqVZ5S5bo15P2/Ec9SrLFTWlVHjBV1a+SQZDT3c2s1+z6YtV
         q45ZrGVOvA2THiQVwci/fyltJSH2rGxmriPDjwvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 720/913] btrfs: make search_csum_tree return 0 if we get -EFBIG
Date:   Tue,  5 Apr 2022 09:29:42 +0200
Message-Id: <20220405070401.415544732@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 03ddb19d2ea745228879b9334f3b550c88acb10a ]

We can either fail to find a csum entry at all and return -ENOENT, or we
can find a range that is close, but return -EFBIG.  In essence these
both mean the same thing when we are doing a lookup for a csum in an
existing range, we didn't find a csum.  We want to treat both of these
errors the same way, complain loudly that there wasn't a csum.  This
currently happens anyway because we do

	count = search_csum_tree();
	if (count <= 0) {
		// reloc and error handling
	}

However it forces us to incorrectly treat EIO or ENOMEM errors as on
disk corruption.  Fix this by returning 0 if we get either -ENOENT or
-EFBIG from btrfs_lookup_csum() so we can do proper error handling.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 0b9401a5afd3..161a69d7e117 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -303,7 +303,7 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
 	read_extent_buffer(path->nodes[0], dst, (unsigned long)item,
 			ret * csum_size);
 out:
-	if (ret == -ENOENT)
+	if (ret == -ENOENT || ret == -EFBIG)
 		ret = 0;
 	return ret;
 }
-- 
2.34.1



