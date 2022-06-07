Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5EB541D19
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348215AbiFGWIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378993AbiFGWGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D616252C34;
        Tue,  7 Jun 2022 12:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25F3EB82368;
        Tue,  7 Jun 2022 19:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41EC385A2;
        Tue,  7 Jun 2022 19:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629350;
        bh=01He/KFgvD4tNb1M5YjiCDrEOHhj2tr2PdBfy8O1o2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJBdxVLlHKjJPtsjcT7/nCGrRUodXg+r2TNgjU6Wvjz/X5eRPRd6OKKOq9tFAfZbl
         ks98MwZ6LY3NKDzaJ4B0oyUi5CXD9A8SCTmTxnZmmUA82IQaKtGBSVpc/4n4v7s46P
         JYsVcOZhwpLl2A6LtV3Gq+MHcPV7+dt3oSSc7gks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 633/879] cxl/mem: Drop mem_enabled check from wait_for_media()
Date:   Tue,  7 Jun 2022 19:02:31 +0200
Message-Id: <20220607165021.221735935@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 2bcf3bbd348fc10260aa6243ff6a22a1882b5b35 ]

Media ready is asserted by the device independent of whether mem_enabled
was ever set. Drop this check to allow for dropping wait_for_media() in
favor of ->wait_media_ready().

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/165291685501.1426646.10372821863672431074.stgit@dwillia2-xfh
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/mem.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 49a4b1c47299..44e899f06094 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -27,12 +27,8 @@
 static int wait_for_media(struct cxl_memdev *cxlmd)
 {
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_endpoint_dvsec_info *info = &cxlds->info;
 	int rc;
 
-	if (!info->mem_enabled)
-		return -EBUSY;
-
 	rc = cxlds->wait_media_ready(cxlds);
 	if (rc)
 		return rc;
-- 
2.35.1



