Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B1E5938FC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242036AbiHOSoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242039AbiHOSmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF4F2B62E;
        Mon, 15 Aug 2022 11:26:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63AAEB8107B;
        Mon, 15 Aug 2022 18:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4425C433D6;
        Mon, 15 Aug 2022 18:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587984;
        bh=QHdUGgQf2J57RM/QS1DJ+baT8eAIsJdSK29InXdY5X0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uv7jK/glguqTyJJR3pTqlDm8iFLBOSj1Z7lp/XCFX1vE1pFchMHGHmau3WrLGHD3H
         r/FMry3AmwrNMQ8B6tqI20+Tp497Sikk44xWzOKSkP0vJFKS6OUqkNI/er7dK1xyfW
         KcNhhE//LaXOI635UYhqeW2izaH+wH1TZvz9QbtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/779] dm: return early from dm_pr_call() if DM device is suspended
Date:   Mon, 15 Aug 2022 19:57:51 +0200
Message-Id: <20220815180346.997801237@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e120a5f1e78fab6223544e425015f393d90d6f0d ]

Otherwise PR ops may be issued while the broader DM device is being
reconfigured, etc.

Fixes: 9c72bad1f31a ("dm: call PR reserve/unreserve on each underlying device")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 36449422e7e0..41d2e1285c07 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2911,6 +2911,11 @@ static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
 		goto out;
 	ti = dm_table_get_target(table, 0);
 
+	if (dm_suspended_md(md)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
 	ret = -EINVAL;
 	if (!ti->type->iterate_devices)
 		goto out;
-- 
2.35.1



