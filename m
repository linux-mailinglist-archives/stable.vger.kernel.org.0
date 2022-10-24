Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A8E60A854
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiJXNE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiJXNC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:02:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C29C3FA36;
        Mon, 24 Oct 2022 05:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03E7F612CF;
        Mon, 24 Oct 2022 12:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184C3C433D6;
        Mon, 24 Oct 2022 12:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613955;
        bh=MQ4sZieayU4xazipjvklwUwGMXXkKmbKgFkPDFPU528=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=192WOMK6b8TKUJOkSXrRMyROdBUERiTmk69cX1y1yOdIo0JHlvS04vVr2QDq3ixq7
         vU/g1zzbzT3X6OEOb5peK/IEWu400ZoXgbyJw/1xGB1RaKhstg75AizGQAXo2NrL3b
         pAOTi2a8NkkdYqbHMK2YB4MhqAmyVRtgnsYxbDpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aran Dalton <arda@allwinnertech.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 050/390] f2fs: increase the limit for reserve_root
Date:   Mon, 24 Oct 2022 13:27:27 +0200
Message-Id: <20221024113024.763778817@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -267,10 +267,10 @@ static int f2fs_sb_read_encoding(const s
 
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


