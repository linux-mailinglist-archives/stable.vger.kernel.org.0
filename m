Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5467666CD90
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbjAPRhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjAPRhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:37:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86734344F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5496A61050
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65027C433D2;
        Mon, 16 Jan 2023 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889205;
        bh=A4pp+r6/V6ky3pUu0YdldaYWodUd5Ty0d+OyLrTHC+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNgk1YtFqEhiJamck/3H2QZ+SrSMsBYVbxl/Jt8uXsnshvPIMG8Oq+GcyvsuttX7s
         Ew/h3KMPkwHLcf7s0xRnWMKi7RulLPLO92uEj2lq3sgBuMEsH3H1cQiCc2QDMmWYq4
         p6iZIZoT+tAaltk9mdhzmMZ2+9J7w+U6enehTVeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 298/338] ext4: fix undefined behavior in bit shift for ext4_check_flag_values
Date:   Mon, 16 Jan 2023 16:52:51 +0100
Message-Id: <20230116154834.096778110@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 3bf678a0f9c017c9ba7c581541dbc8453452a7ae upstream.

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in fs/ext4/ext4.h:591:2
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 ext4_init_fs+0x5a/0x277
 do_one_initcall+0x76/0x430
 kernel_init_freeable+0x3b3/0x422
 kernel_init+0x24/0x1e0
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 9a4c80194713 ("ext4: ensure Inode flags consistency are checked at build time")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221031055833.3966222-1-cuigaosheng1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -486,7 +486,7 @@ enum {
  *
  * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
  */
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
+#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1U << EXT4_INODE_##FLAG))
 #define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
 
 static inline void ext4_check_flag_values(void)


