Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756C36357B3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbiKWJpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiKWJoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:44:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4403511092D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E081AB81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA6CC433C1;
        Wed, 23 Nov 2022 09:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196542;
        bh=TY/QL7RZPjYhDXIfImiAIztPqnnDlUBUe8/9nBwgU7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vaG+xXssMPyB8mDgRso4ceH0o6swDZ3QApC7n0ktOvYvInJEVZ7gnhxtUTsVRQEhO
         NFgv1rmDffApGdeOJzjdtQqVYC8tyW4U3+fzcI5ychkU9kQXIsC4mQGpYn5nCvygf1
         iWNqP1PIzhl0NnDpHmMrYuLTfoOIVA1AurqjCQXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/314] tools/testing/cxl: Fix some error exits
Date:   Wed, 23 Nov 2022 09:48:25 +0100
Message-Id: <20221123084628.203073675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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



