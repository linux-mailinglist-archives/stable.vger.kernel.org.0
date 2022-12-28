Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545FF657D5C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbiL1Pml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbiL1PmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD351706D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AADCC6156F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4AAC433D2;
        Wed, 28 Dec 2022 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242138;
        bh=YhdJUr/yiDtp6hcz22L6YBYwTibof4XunRJF0UhvGyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhXpWjJqjxRs8O6ZqhYrA4gukLWm1tJQ8FssmFm2LcHsAvI+dkaNh9XzkuGY8bj3S
         6v0bq3FPy9u3scUIuHNIDdh9CxK0JoeNrvULjDcRVJfHDr1blw5pb0NHxqlF9bqNmF
         kGC7VRH66qzc+SYn+hiXFFsWJdEYK89RAUvP8w54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 567/731] remoteproc: qcom: q6v5: Fix potential null-ptr-deref in q6v5_wcss_init_mmio()
Date:   Wed, 28 Dec 2022 15:41:14 +0100
Message-Id: <20221228144312.993823752@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit f360e2b275efbb745ba0af8b47d9ef44221be586 ]

q6v5_wcss_init_mmio() will call platform_get_resource_byname() that may
fail and return NULL. devm_ioremap() will use res->start as input, which
may causes null-ptr-deref. Check the ret value of
platform_get_resource_byname() to avoid the null-ptr-deref.

Fixes: 0af65b9b915e ("remoteproc: qcom: wcss: Add non pas wcss Q6 support for QCS404")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221125021641.29392-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_wcss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_wcss.c b/drivers/remoteproc/qcom_q6v5_wcss.c
index 20d50ec7eff1..9e67e323a55a 100644
--- a/drivers/remoteproc/qcom_q6v5_wcss.c
+++ b/drivers/remoteproc/qcom_q6v5_wcss.c
@@ -827,6 +827,9 @@ static int q6v5_wcss_init_mmio(struct q6v5_wcss *wcss,
 	int ret;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "qdsp6");
+	if (!res)
+		return -EINVAL;
+
 	wcss->reg_base = devm_ioremap(&pdev->dev, res->start,
 				      resource_size(res));
 	if (!wcss->reg_base)
-- 
2.35.1



