Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972C8657FDC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiL1QLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiL1QKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:10:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794271AA00
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:09:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E267961579
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AB0C433EF;
        Wed, 28 Dec 2022 16:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243739;
        bh=b0mLw23YEEGO5QtvlzuDhKg7RuVactZgpj4TokLm3RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbDVnAxHdNcHfFS4Oc+WTatsrPiyZK1YMqyVUa2tBrg1BKxRz3SJC4uP59vkG7suy
         PObpAhdbawAkrCkDbYEtnm+kJhP9eWNPWd7oq5wMZtReKE6HUeGJZBDTYN+tXsBEif
         XoDrxcLGz0W1oml1CrNmPsMGDlz6FSYmjo4kWPuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dongdong Zhang <zhangdongdong1@oppo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0580/1073] f2fs: fix normal discard process
Date:   Wed, 28 Dec 2022 15:36:08 +0100
Message-Id: <20221228144343.803060388@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 10d8bc81cff7..27690f757913 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1449,7 +1449,7 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 		if (i + 1 < dpolicy->granularity)
 			break;
 
-		if (i < DEFAULT_DISCARD_GRANULARITY && dpolicy->ordered)
+		if (i + 1 < DEFAULT_DISCARD_GRANULARITY && dpolicy->ordered)
 			return __issue_discard_cmd_orderly(sbi, dpolicy);
 
 		pend_list = &dcc->pend_list[i];
-- 
2.35.1



