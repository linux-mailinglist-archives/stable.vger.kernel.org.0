Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3975EA031
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiIZKfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiIZKdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57A449B51;
        Mon, 26 Sep 2022 03:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE92A60B60;
        Mon, 26 Sep 2022 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C434CC433C1;
        Mon, 26 Sep 2022 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187618;
        bh=olcYasHuW7BIezTv9Mi3hwjM/yjhD8t6eRgTA7tM4sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGhFBKmepNeOn6Pfss/nHnlVZ09w2W8+3LVRP498kKB0LJXHmMfQXt3NdCKJilzR6
         rY1GkzYggcf9H7STJyRe2f/M8SEb85sMkcF2Exbu4maoqvZDx8fU1DYzr5d/RixDqJ
         IuJu8K/f087LhnENsReCGk4ZRAMwNNFOzrtSKAsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>, stable@kernel.org,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 57/58] ext4: make directory inode spreading reflect flexbg size
Date:   Mon, 26 Sep 2022 12:12:16 +0200
Message-Id: <20220926100743.569623445@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 613c5a85898d1cd44e68f28d65eccf64a8ace9cf upstream.

Currently the Orlov inode allocator searches for free inodes for a
directory only in flex block groups with at most inodes_per_group/16
more directory inodes than average per flex block group. However with
growing size of flex block group this becomes unnecessarily strict.
Scale allowed difference from average directory count per flex block
group with flex block group size as we do with other metrics.

Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/all/0d81a7c2-46b7-6010-62a4-3e6cfc1628d6@i2se.com/
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220908092136.11770-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -505,7 +505,7 @@ static int find_group_orlov(struct super
 		goto fallback;
 	}
 
-	max_dirs = ndirs / ngroups + inodes_per_group / 16;
+	max_dirs = ndirs / ngroups + inodes_per_group*flex_size / 16;
 	min_inodes = avefreei - inodes_per_group*flex_size / 4;
 	if (min_inodes < 1)
 		min_inodes = 1;


