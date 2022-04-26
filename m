Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87CC50F478
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345003AbiDZIgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345022AbiDZId7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:33:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694373BBF4;
        Tue, 26 Apr 2022 01:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7635EB81CFA;
        Tue, 26 Apr 2022 08:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C162DC385A0;
        Tue, 26 Apr 2022 08:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961545;
        bh=K/69QxVv7T4FTeKHdSZVJbXT07k+FI7rMWMGgv0/yCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahBUvQFU8Djx1IXRbGVXaLQXlwLdyuPu7f6q4M953GijxiG+U+FZNSpROcSyb+36r
         UMVHq8XPgi98Qmk2Is5UeZCtq++jp9cUMumKk/E3Sm+DR4bE0hBmxvHGGgm5cK39VN
         C3YFgkiBzvsjFmL3fc8Qqj7jwJbetxaoY31J56wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.14 31/43] ext4: fix overhead calculation to account for the reserved gdt blocks
Date:   Tue, 26 Apr 2022 10:21:13 +0200
Message-Id: <20220426081735.434788860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 10b01ee92df52c8d7200afead4d5e5f55a5c58b1 upstream.

The kernel calculation was underestimating the overhead by not taking
into account the reserved gdt blocks.  With this change, the overhead
calculated by the kernel matches the overhead calculation in mke2fs.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3366,9 +3366,11 @@ static int count_overhead(struct super_b
 	ext4_fsblk_t		first_block, last_block, b;
 	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
 	int			s, j, count = 0;
+	int			has_super = ext4_bg_has_super(sb, grp);
 
 	if (!ext4_has_feature_bigalloc(sb))
-		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, grp) +
+		return (has_super + ext4_bg_num_gdb(sb, grp) +
+			(has_super ? le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) : 0) +
 			sbi->s_itb_per_group + 2);
 
 	first_block = le32_to_cpu(sbi->s_es->s_first_data_block) +


