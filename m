Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128E54F2F8B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbiDEJg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiDEJAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:00:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C9C26AEC;
        Tue,  5 Apr 2022 01:53:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A320B81C69;
        Tue,  5 Apr 2022 08:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E177BC385A0;
        Tue,  5 Apr 2022 08:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148810;
        bh=ko2SpRfNjpELYGxgdaGx9p3UeCcclOfeq8wiIuIytGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM7cgR+Ro6iNSWChwYbgplT1GF+AKFD9BinkULpu1fJ3pvhXPxyUdEGoyyhCckaVa
         Oyf0iP09j7p3Q/mMtXRIoAxn/plHh9ypLQRsJ44BuxGLYO+rQmkm9P9fhGbWfWQ7Kr
         /pqY4TDRvmISqQBuI+KdqlEvYSDRgGs0zH5mnMPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0489/1017] tools/testing/cxl: Fix root port to host bridge assignment
Date:   Tue,  5 Apr 2022 09:23:22 +0200
Message-Id: <20220405070408.814606454@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index cb32f9e27d5d..5a39b3fdcac4 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -488,7 +488,7 @@ static __init int cxl_test_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
 		struct platform_device *bridge =
-			cxl_host_bridge[i / NR_CXL_ROOT_PORTS];
+			cxl_host_bridge[i % ARRAY_SIZE(cxl_host_bridge)];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_root_port", i);
-- 
2.34.1



