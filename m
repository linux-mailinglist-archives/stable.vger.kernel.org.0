Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9A6085F9
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiJVHmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJVHlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:41:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF55EF5B6;
        Sat, 22 Oct 2022 00:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E18AB82E01;
        Sat, 22 Oct 2022 07:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87438C433D6;
        Sat, 22 Oct 2022 07:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424356;
        bh=LUCqnL0CpNQQy7m2QqQFuPp6xdW28Ne5xn1QZwADrrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlhTD63GR/dN/saezdaWREv9yiwUnHW3BSxEmj1lur/TJG0J6X0xCnyTj7jMM9Qr5
         dTTPjea/6ykYVQtq3O7z83+epPzz2F9i25aUKd2CTqbfF6rDPn7K53XRRVehjFOsiJ
         HK/m7F2dUvNWOgzAcsad26POhjCUpKQVvRdaKZ4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aran Dalton <arda@allwinnertech.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.19 115/717] f2fs: increase the limit for reserve_root
Date:   Sat, 22 Oct 2022 09:19:54 +0200
Message-Id: <20221022072435.740997775@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit da35fe96d12d15779f3cb74929b7ed03941cf983 upstream.

This patch increases the threshold that limits the reserved root space from 0.2%
to 12.5% by using simple shift operation.

Typically Android sets 128MB, but if the storage capacity is 32GB, 0.2% which is
around 64MB becomes too small. Let's relax it.

Cc: stable@vger.kernel.org
Reported-by: Aran Dalton <arda@allwinnertech.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -298,10 +298,10 @@ static void f2fs_destroy_casefold_cache(
 
 static inline void limit_reserve_root(struct f2fs_sb_info *sbi)
 {
-	block_t limit = min((sbi->user_block_count << 1) / 1000,
+	block_t limit = min((sbi->user_block_count >> 3),
 			sbi->user_block_count - sbi->reserved_blocks);
 
-	/* limit is 0.2% */
+	/* limit is 12.5% */
 	if (test_opt(sbi, RESERVE_ROOT) &&
 			F2FS_OPTION(sbi).root_reserved_blocks > limit) {
 		F2FS_OPTION(sbi).root_reserved_blocks = limit;


