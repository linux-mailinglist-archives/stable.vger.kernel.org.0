Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B18C60A921
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiJXNPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiJXNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D68A2A8D;
        Mon, 24 Oct 2022 05:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFE1612D2;
        Mon, 24 Oct 2022 12:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFC2C433D6;
        Mon, 24 Oct 2022 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614315;
        bh=zmCdnqZhVJQJyc3EsuY4FxJn+vF7xfP1KOgUoH30fl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b00ZQz3hdyF0TjtPu60oGS8NZIXBkxI8YlMcQp0Y+ahE7B2OsYekEUQmPtHUC87Gg
         RRob5q5cdfyNEq3oJNQ1lHmZIwl/I5VwbFr6DVukerNPB2KtnUZXj3RL83QUWgdwD5
         sShIrSnrDWRAJi5U9rRKi83TUwHp6srA57H4CQ5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xu Yilun <yilun.xu@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/390] fpga: prevent integer overflow in dfl_feature_ioctl_set_irq()
Date:   Mon, 24 Oct 2022 13:30:10 +0200
Message-Id: <20221024113031.867017383@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 939bc5453b8cbdde9f1e5110ce8309aedb1b501a ]

The "hdr.count * sizeof(s32)" multiplication can overflow on 32 bit
systems leading to memory corruption.  Use array_size() to fix that.

Fixes: 322b598be4d9 ("fpga: dfl: introduce interrupt trigger setting API")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/YxBAtYCM38dM7yzI@kili
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index b450870b75ed..eb8a6e329af9 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -1857,7 +1857,7 @@ long dfl_feature_ioctl_set_irq(struct platform_device *pdev,
 		return -EINVAL;
 
 	fds = memdup_user((void __user *)(arg + sizeof(hdr)),
-			  hdr.count * sizeof(s32));
+			  array_size(hdr.count, sizeof(s32)));
 	if (IS_ERR(fds))
 		return PTR_ERR(fds);
 
-- 
2.35.1



