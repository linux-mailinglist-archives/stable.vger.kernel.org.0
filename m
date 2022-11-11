Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA30625096
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiKKChB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiKKCgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112A67F48;
        Thu, 10 Nov 2022 18:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4647B823CA;
        Fri, 11 Nov 2022 02:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9A4C433C1;
        Fri, 11 Nov 2022 02:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134109;
        bh=TY/QL7RZPjYhDXIfImiAIztPqnnDlUBUe8/9nBwgU7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXUnLYSoZ1Cqi5+POp0zgcoO8jLdgOa6qTAysqAoiWAkA2wz0xpaboxwqv+L9JvE6
         jxBbQu7vqVa7i2ETNK4HAn1E8mx08V2bvgCSHfLf0P2jsw69Sjf3h2P4v4qpje6nTc
         nBq0xWHR1MGp4nF4Tscl3ALdHcp/nvitzGQSm4EI2nag23Miq30gHrE8kGsAjsNy+L
         9JhzlNbAI7bUzFimf3KkgvQ6PNeqUjsWWtTZvibo+jUNeQSNFtjMwnLKACfXmsx3Px
         1J2L4hLRov9uwgFrcyKs6Zw78NxPgb3tDXM/mXEQqIXKnweFE8lc16YG9rvI+w2TnZ
         6dbmxKA6YRwGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>, Jonathan.Cameron@huawei.com,
        bwidawsk@kernel.org, rafael.j.wysocki@intel.com,
        alison.schofield@intel.com
Subject: [PATCH AUTOSEL 6.0 29/30] tools/testing/cxl: Fix some error exits
Date:   Thu, 10 Nov 2022 21:33:37 -0500
Message-Id: <20221111023340.227279-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 86e86c3cb63325c12ea99fbce2cc5bafba86bb40 ]

Fix a few typos where 'goto err_port' was used rather than the object
specific cleanup.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166752184255.947915.16163477849330181425.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index a072b2d3e726..133e4c73d370 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -695,7 +695,7 @@ static __init int cxl_test_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_uport", i);
 		if (!pdev)
-			goto err_port;
+			goto err_uport;
 		pdev->dev.parent = &root_port->dev;
 
 		rc = platform_device_add(pdev);
@@ -713,7 +713,7 @@ static __init int cxl_test_init(void)
 
 		pdev = platform_device_alloc("cxl_switch_dport", i);
 		if (!pdev)
-			goto err_port;
+			goto err_dport;
 		pdev->dev.parent = &uport->dev;
 
 		rc = platform_device_add(pdev);
-- 
2.35.1

