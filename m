Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB894F2B92
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbiDEJfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbiDEIOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:14:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288439BAEF;
        Tue,  5 Apr 2022 01:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8978AB81B18;
        Tue,  5 Apr 2022 08:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C551BC385A1;
        Tue,  5 Apr 2022 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145792;
        bh=seiBGHh9QwPdT6SoSG5DhIi5R0FVf3d1hYryzIDXDX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAsBoB94yFeQpt6uslWyXpq78Vcfk6PhO+3SAu++cvAmRndDtFaoKbHryLW+5wf55
         xehN4NvSnLrKbIs3DmuBC0+FjdtXJJ26CT6e0lDiYFr/aYvA9N/HowQHZ+ZggV7UL3
         7yRbXPM6cQdxN+1pNV+FR9QQtw3jNCBA2HsDl4nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0531/1126] tools/testing/cxl: Fix root port to host bridge assignment
Date:   Tue,  5 Apr 2022 09:21:18 +0200
Message-Id: <20220405070423.217388650@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit a4a0ce242fcd7022349212c4e2f795762e6ff050 ]

Mocked root-ports are meant to be round-robin assigned to host-bridges.

Fixes: 67dcdd4d3b83 ("tools/testing/cxl: Introduce a mocked-up CXL port hierarchy")
Link: https://lore.kernel.org/r/164298431629.3018233.14004377108116384485.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/cxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 736d99006fb7..f0a410962af0 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -511,7 +511,7 @@ static __init int cxl_test_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
 		struct platform_device *bridge =
-			cxl_host_bridge[i / NR_CXL_ROOT_PORTS];
+			cxl_host_bridge[i % ARRAY_SIZE(cxl_host_bridge)];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_root_port", i);
-- 
2.34.1



