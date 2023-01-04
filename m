Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817C065D964
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjADQZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbjADQYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:24:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7631B33D56
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEFF7B817B7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C71C433F0;
        Wed,  4 Jan 2023 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849422;
        bh=J++P1H09X2udYvUD4P/p1cK3nWwqkgNwItMeS6xQL40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1HjupyuyQBrn3AKtqz2UGuaMO1oRfqVuEjv3ndNrEM9QFV9S+djOqEpWwTBqC0t3
         byoKOla2PU0FcC1fWMFM2IG5npVStogQYiLNozQHBzBb9iIxQxAm3D3OfuIst9PZh9
         PpmEj1ENLUDqGqB66mqjHUw5UOMJ4O9AiI83UNr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.1 185/207] ext4: fix delayed allocation bug in ext4_clu_mapped for bigalloc + inline
Date:   Wed,  4 Jan 2023 17:07:23 +0100
Message-Id: <20230104160517.750797497@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Eric Whitney <enwlinux@gmail.com>

commit 131294c35ed6f777bd4e79d42af13b5c41bf2775 upstream.

When converting files with inline data to extents, delayed allocations
made on a file system created with both the bigalloc and inline options
can result in invalid extent status cache content, incorrect reserved
cluster counts, kernel memory leaks, and potential kernel panics.

With bigalloc, the code that determines whether a block must be
delayed allocated searches the extent tree to see if that block maps
to a previously allocated cluster.  If not, the block is delayed
allocated, and otherwise, it isn't.  However, if the inline option is
also used, and if the file containing the block is marked as able to
store data inline, there isn't a valid extent tree associated with
the file.  The current code in ext4_clu_mapped() calls
ext4_find_extent() to search the non-existent tree for a previously
allocated cluster anyway, which typically finds nothing, as desired.
However, a side effect of the search can be to cache invalid content
from the non-existent tree (garbage) in the extent status tree,
including bogus entries in the pending reservation tree.

To fix this, avoid searching the extent tree when allocating blocks
for bigalloc + inline files that are being converted from inline to
extent mapped.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20221117152207.2424-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5799,6 +5799,14 @@ int ext4_clu_mapped(struct inode *inode,
 	struct ext4_extent *extent;
 	ext4_lblk_t first_lblk, first_lclu, last_lclu;
 
+	/*
+	 * if data can be stored inline, the logical cluster isn't
+	 * mapped - no physical clusters have been allocated, and the
+	 * file has no extents
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return 0;
+
 	/* search for the extent closest to the first block in the cluster */
 	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
 	if (IS_ERR(path)) {


