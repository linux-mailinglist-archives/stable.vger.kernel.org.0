Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB5657898
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiL1Owp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiL1OwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7FE11808
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C65261551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4DCC433D2;
        Wed, 28 Dec 2022 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239122;
        bh=uhp8QcyG8Cu3yjOSy+2bjMgySNFqU1Xu8QtI5cx4k/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAhpbbcuyRjdGkR2jIJtjTplBNQqHBsK34DAc1qfEaZoj29ZDBTjAdeYBF1n0ivqd
         lF/NUhCTzM8kBEFSK8PGLBHYveZlUh34rGRCumuVN3U5hhoHlzaj++KzKHMGXUa1B2
         Dm1NkuSLHJhqO4bNT63iI7Fl02hDGfFr5D7rvFrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Qilong <zhangqilong3@huawei.com>,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Sha Zhengju <handai.szj@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/731] eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
Date:   Wed, 28 Dec 2022 15:34:03 +0100
Message-Id: <20221228144300.490626263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit fd4e60bf0ef8eb9edcfa12dda39e8b6ee9060492 ]

Commit ee62c6b2dc93 ("eventfd: change int to __u64 in eventfd_signal()")
forgot to change int to __u64 in the CONFIG_EVENTFD=n stub function.

Link: https://lkml.kernel.org/r/20221124140154.104680-1-zhangqilong3@huawei.com
Fixes: ee62c6b2dc93 ("eventfd: change int to __u64 in eventfd_signal()")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/eventfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 30eb30d6909b..3cd202d3eefb 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -61,7 +61,7 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
+static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	return -ENOSYS;
 }
-- 
2.35.1



