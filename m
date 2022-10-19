Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C526044DD
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiJSMRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiJSMQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:16:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5BF192D94;
        Wed, 19 Oct 2022 04:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 867FDB822EE;
        Wed, 19 Oct 2022 08:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB737C433D6;
        Wed, 19 Oct 2022 08:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169001;
        bh=ENqjI30oM3X1HTevosEQ8wfvgkE/7JDm0ZpMwQO+m1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOEu3WtBj0F6qrTwxAcQQnGb3MpUwoobjeM0TjPHuaGhPcLYbuV7DnSlPQkqPKFq5
         3ArQMclZ7kvMBViBzr9KKuTXNrp0838mA5250FRgJr+NbEuNWfvPQ0C0VZlYmOSkd+
         8JpGyzHvoCSVDOsY0VrRnynM7c9sNXJlGeHfNhS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aran Dalton <arda@allwinnertech.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.0 126/862] f2fs: increase the limit for reserve_root
Date:   Wed, 19 Oct 2022 10:23:33 +0200
Message-Id: <20221019083255.521198948@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -301,10 +301,10 @@ static void f2fs_destroy_casefold_cache(
 
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


