Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9359DC56
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355714AbiHWKoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356485AbiHWKmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:42:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8789CA99C0;
        Tue, 23 Aug 2022 02:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2172D6092E;
        Tue, 23 Aug 2022 09:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1132EC433C1;
        Tue, 23 Aug 2022 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245790;
        bh=ueeu1O7WxTB5W7eT1aqQvjP1jaD0aS1iXFRsRpMLeAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8Eb69Ikdeit69U/bGdwIAfb1r6sQrpwqWon8t5g1LNk1kSBFvPs66DX9NAN/MIY0
         rbUfa8651ExyUZjSU5V93YFu2SqozH8KutlbJTNQw6FhWuNtksucjFbEntBAXA5j71
         2tg6K5uhsVubA84gEkc80uu9XZWG5NBYHBD6vbj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 4.19 190/287] ext4: update s_overhead_clusters in the superblock during an on-line resize
Date:   Tue, 23 Aug 2022 10:25:59 +0200
Message-Id: <20220823080107.211177549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
@@ -1483,6 +1483,7 @@ static void ext4_update_super(struct sup
 	 * Update the fs overhead information
 	 */
 	ext4_calculate_overhead(sb);
+	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"


