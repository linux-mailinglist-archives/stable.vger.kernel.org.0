Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC1C59D9E3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbiHWKDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352322AbiHWKBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F127B7B0;
        Tue, 23 Aug 2022 01:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 198046122F;
        Tue, 23 Aug 2022 08:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BEEC433D6;
        Tue, 23 Aug 2022 08:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244559;
        bh=7o9wGdshU5JpHoJS4v5+Ldi10mCK71DBv3aRF5U5Y9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwQr2xjwdwIEDhl0F2/2xg5dVXaQbk46eBmLzkcTZWlaxvDiOuqeAgzW9vGLcSDbG
         CXmj9xL0pyo7Bd9RVE13fbQ6l20Kt8Dl7L2LWRB4QJpbvnhiuZUNnYofc+rm6ljtCi
         w0Y77nlG8fAJrbJ41Ly4Or4Y35Cdzetpdm/aXAjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 4.14 155/229] ext4: update s_overhead_clusters in the superblock during an on-line resize
Date:   Tue, 23 Aug 2022 10:25:16 +0200
Message-Id: <20220823080059.208458416@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit de394a86658ffe4e89e5328fd4993abfe41b7435 upstream.

When doing an online resize, the on-disk superblock on-disk wasn't
updated.  This means that when the file system is unmounted and
remounted, and the on-disk overhead value is non-zero, this would
result in the results of statfs(2) to be incorrect.

This was partially fixed by Commits 10b01ee92df5 ("ext4: fix overhead
calculation to account for the reserved gdt blocks"), 85d825dbf489
("ext4: force overhead calculation if the s_overhead_cluster makes no
sense"), and eb7054212eac ("ext4: update the cached overhead value in
the superblock").

However, since it was too expensive to forcibly recalculate the
overhead for bigalloc file systems at every mount, this didn't fix the
problem for bigalloc file systems.  This commit should address the
problem when resizing file systems with the bigalloc feature enabled.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20220629040026.112371-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/resize.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1456,6 +1456,7 @@ static void ext4_update_super(struct sup
 	 * Update the fs overhead information
 	 */
 	ext4_calculate_overhead(sb);
+	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"


