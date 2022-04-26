Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE150F3BE
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244325AbiDZI1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344709AbiDZI1C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:27:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8957E3DA67;
        Tue, 26 Apr 2022 01:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E773E6179E;
        Tue, 26 Apr 2022 08:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC605C385A4;
        Tue, 26 Apr 2022 08:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961399;
        bh=0XxiZn4mWg4KSzNOvpLn5V0WlMZAF0KIEYiJ+q4stq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRMFlzuhXkI9xzasZco843Kw1LIF1x2HV4m1k8K+OjlLWZ+//gGkYrLzdGDHmttUZ
         9zrQyZb+SJw6EssIrxmTYd97YZauGEN5o2Yd1KkM2CRalUbiLEclsBopwOerKQxi1b
         B6ZPE2sc15so6akjKvmCeeM2Yo2D29ID72g0BV8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.9 22/24] ext4: fix overhead calculation to account for the reserved gdt blocks
Date:   Tue, 26 Apr 2022 10:21:16 +0200
Message-Id: <20220426081732.028630377@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
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
@@ -3241,9 +3241,11 @@ static int count_overhead(struct super_b
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


