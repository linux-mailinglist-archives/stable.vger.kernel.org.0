Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE9450F473
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiDZIgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345539AbiDZIen (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC3D78FE9;
        Tue, 26 Apr 2022 01:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 167CC617AE;
        Tue, 26 Apr 2022 08:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA9AC385A4;
        Tue, 26 Apr 2022 08:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961657;
        bh=rXwXAidvJq3nMv+8q5ENQBIe/PH5KIoFhtL2h7Zp24k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrS9RghNiCzeqdSiD3mZOwVeJgb+kSRzSoFYLUdqOrEzJm8YS3u1mNl1uhqBC/qEs
         Pfe2tdLfRsN12sSTrPhFifbfqbgLk1thM9GIut+sDgVjy6QdQoIXEK9O3NWt3FLi2Y
         ROfBeoB5O8X5272acS3i9SEtuAUfxnD3s9PJZWgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.19 41/53] ext4: fix overhead calculation to account for the reserved gdt blocks
Date:   Tue, 26 Apr 2022 10:21:21 +0200
Message-Id: <20220426081736.852399741@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
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
@@ -3440,9 +3440,11 @@ static int count_overhead(struct super_b
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


