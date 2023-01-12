Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2586675A0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbjALOXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbjALOWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:22:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6EA5953B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:14:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08C4A62035
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9247C433EF;
        Thu, 12 Jan 2023 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532853;
        bh=33i9jpgUJCJN0ik87Hgh4dsO65XJQYDoLdjaHuny+Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3XNCPuuecsuOpR9wyeeKZXDyGgq+uphlsXcY4RmqvgGIHUk4odFF0c4CoobCPyHG
         dWACRMtRkrOtMzI1CMKHgCHXslN37CHVzKJbF0bH2OSKKftbeVqstmhROxFZWDO7cr
         8pOl7EGSwHzF1J2iRJpsTVvR0xRgSI8Ultg89zZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dongdong Zhang <zhangdongdong1@oppo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/783] f2fs: fix normal discard process
Date:   Thu, 12 Jan 2023 14:50:13 +0100
Message-Id: <20230112135538.096362674@linuxfoundation.org>
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

From: Dongdong Zhang <zhangdongdong1@oppo.com>

[ Upstream commit b5f1a218ae5e4339130d6e733f0e63d623e09a2c ]

In the DPOLICY_BG mode, there is a conflict between
the two conditions "i + 1 < dpolicy->granularity" and
"i < DEFAULT_DISCARD_GRANULARITY". If i = 15, the first
condition is false, it will enter the second condition
and dispatch all small granularity discards in function
 __issue_discard_cmd_orderly. The restrictive effect
of the first condition to small discards will be
invalidated. These two conditions should align.

Fixes: 20ee4382322c ("f2fs: issue small discard by LBA order")
Signed-off-by: Dongdong Zhang <zhangdongdong1@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 68774d6198a5..7c90d93f4e43 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1532,7 +1532,7 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 		if (i + 1 < dpolicy->granularity)
 			break;
 
-		if (i < DEFAULT_DISCARD_GRANULARITY && dpolicy->ordered)
+		if (i + 1 < DEFAULT_DISCARD_GRANULARITY && dpolicy->ordered)
 			return __issue_discard_cmd_orderly(sbi, dpolicy);
 
 		pend_list = &dcc->pend_list[i];
-- 
2.35.1



