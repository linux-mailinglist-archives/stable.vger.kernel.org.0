Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5372B6B41CC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjCJN4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjCJN4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:56:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F12112DF0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:56:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 385D36182F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A767C433D2;
        Fri, 10 Mar 2023 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456578;
        bh=e/clle4sniBocbV6pcTXWpCG2LhZMYCTy5zhJhkHGRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLhHQ8GUcmtpRjEVeFXHdppbYp6n5Ps7zufXR8b5Zt9HD19ARCC5EkuZTX9vx5MVy
         JVLkDpvsCiDzxtMrn/77IQBNUPaZ/yUG1LEfpU8hHD6tOmFAtiTrXtagpUFZ/z64tf
         9rVHP+9Bns0bxGDumjhPV4SJMYyOID6XbgZ7t2dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Jianjian <wangjianjian3@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 052/211] ext4: dont show commit interval if it is zero
Date:   Fri, 10 Mar 2023 14:37:12 +0100
Message-Id: <20230310133720.316756816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Jianjian <wangjianjian3@huawei.com>

[ Upstream commit 934b0de1e9fdea93c4c7f2e18915c54fae67bdc6 ]

If commit interval is 0, it means using default value.

Fixes: 6e47a3cc68fc ("ext4: get rid of super block and sbi from handle_mount_ops()")
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
Link: https://lore.kernel.org/r/20221219015128.876717-1-wangjianjian3@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 260c1b3e3ef2c..3b9e30e1afd91 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2146,7 +2146,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		return 0;
 	case Opt_commit:
 		if (result.uint_32 == 0)
-			ctx->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE;
+			result.uint_32 = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		else if (result.uint_32 > INT_MAX / HZ) {
 			ext4_msg(NULL, KERN_ERR,
 				 "Invalid commit interval %d, "
-- 
2.39.2



