Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BB56677C3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbjALOsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239913AbjALOrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:47:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D4D63F50
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B911162026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B661BC433EF;
        Thu, 12 Jan 2023 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534122;
        bh=n4ktbHRAOycijrh7XLcJ8CtW2kCvNN7FxNOxNZ7SncA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJgZ4+E2TG81CDZXKhY6yPXHC/wUCx//FMM450r6zqkbsEHwrtXxHZb+RFLcQAZ4t
         9js+JpVD8DVH+xmySlhpHOHKyL+Gs6OMI1dLHTFE9MwfS3I2K37fyQvpxR8lsKo2dl
         9IAOrQLaAEg08B17cRixsSzAvSwKoN3wQ8DeOWA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 672/783] ext4: fix undefined behavior in bit shift for ext4_check_flag_values
Date:   Thu, 12 Jan 2023 14:56:28 +0100
Message-Id: <20230112135555.490953990@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -553,7 +553,7 @@ enum {
  *
  * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
  */
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
+#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1U << EXT4_INODE_##FLAG))
 #define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
 
 static inline void ext4_check_flag_values(void)


