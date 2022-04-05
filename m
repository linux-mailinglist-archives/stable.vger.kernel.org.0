Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33E14F35A5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiDEKxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346057AbiDEJoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:44:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814C1C6EF5;
        Tue,  5 Apr 2022 02:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB59EB81C9A;
        Tue,  5 Apr 2022 09:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ADBC385A0;
        Tue,  5 Apr 2022 09:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151001;
        bh=/Fq1gwqrLUmliP1W1v3pB/zvWHZ8E/6r9pL/5AHf0sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiNb5h63Lp61rCQ1I/HGh6ER1F8kpbXn3h84/Y5VvTTs35qVED6jaboIXoX5Y/L3F
         j2JCLi9IDDhn3hj0JZ73/9TMBcERaZYYYZvqPNbPe0LtyhMOWwGqePRWFP8Sf2Qa9t
         5JccoTRfBsh/t2k7D/v44TIlu8Sh0scvoMZpu0ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 259/913] btrfs: fix unexpected error path when reflinking an inline extent
Date:   Tue,  5 Apr 2022 09:22:01 +0200
Message-Id: <20220405070347.619409658@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1f4613cdbe7739ce291554b316bff8e551383389 ]

When reflinking an inline extent, we assert that its file offset is 0 and
that its uncompressed length is not greater than the sector size. We then
return an error if one of those conditions is not satisfied. However we
use a return statement, which results in returning from btrfs_clone()
without freeing the path and buffer that were allocated before, as well as
not clearing the flag BTRFS_INODE_NO_DELALLOC_FLUSH for the destination
inode.

Fix that by jumping to the 'out' label instead, and also add a WARN_ON()
for each condition so that in case assertions are disabled, we get to
known which of the unexpected conditions triggered the error.

Fixes: a61e1e0df9f321 ("Btrfs: simplify inline extent handling when doing reflinks")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/reflink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index c71e49782e86..fa60af00ebca 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -505,8 +505,11 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			 */
 			ASSERT(key.offset == 0);
 			ASSERT(datal <= fs_info->sectorsize);
-			if (key.offset != 0 || datal > fs_info->sectorsize)
-				return -EUCLEAN;
+			if (WARN_ON(key.offset != 0) ||
+			    WARN_ON(datal > fs_info->sectorsize)) {
+				ret = -EUCLEAN;
+				goto out;
+			}
 
 			ret = clone_copy_inline_extent(inode, path, &new_key,
 						       drop_start, datal, size,
-- 
2.34.1



