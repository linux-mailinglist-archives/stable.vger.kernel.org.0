Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB61F59D554
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbiHWIhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345531AbiHWIfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207B5FD5;
        Tue, 23 Aug 2022 01:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 152BD61238;
        Tue, 23 Aug 2022 08:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47994C433D6;
        Tue, 23 Aug 2022 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242609;
        bh=6cr4M4z5xfYkh3alHhyViMwcrjvTki6YRE8U0y4xRyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wk6TE89zhZQyl5pSrwl/oK8/VBzG/4rcBuMZA+O6L0L/Us7CGHFF88q1+2E9Bm7tF
         8/bc5yIWuK/X6HVwJpgnfzDNhpA6Pmm+5jqNdbkaLVwRtgwb64dO7l4eFJpyWthIIt
         ygvGI9C0xgQcruD60EPzSk0mZrKkIJQwQqUiyr9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.19 144/365] tools/testing/cxl: Fix cxl_hdm_decode_init() calling convention
Date:   Tue, 23 Aug 2022 10:00:45 +0200
Message-Id: <20220823080124.254773216@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

commit 863fdccdc5ed1e187a30a4a103340be4569904c8 upstream.

This failing signature:

[    8.392669] cxl_bus_probe: cxl_port endpoint2: probe: 970997760
[    8.392670] cxl_port: probe of endpoint2 failed with error 970997760
[    8.392719] create_endpoint: cxl_mem mem0: add: endpoint2
[    8.392721] cxl_mem mem0: endpoint2 failed probe
[    8.392725] cxl_bus_probe: cxl_mem mem0: probe: -6

...shows cxl_hdm_decode_init() resulting in a return code ("970997760")
that looks like stack corruption. The problem goes away if
cxl_hdm_decode_init() is not mocked via __wrap_cxl_hdm_decode_init().

The corruption results from the mismatch that the calling convention for
cxl_hdm_decode_init() is:

int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)

...and __wrap_cxl_hdm_decode_init() is:

bool __wrap_cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm)

...i.e. an int is expected but __wrap_hdm_decode_init() returns bool.

Fix the convention and cleanup the organization to match
__wrap_cxl_await_media_ready() as the difference was a red herring that
distracted from finding the bug.

Fixes: 92804edb11f0 ("cxl/pci: Drop @info argument to cxl_hdm_decode_init()")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Link: https://lore.kernel.org/r/165603870776.551046.8709990108936497723.stgit@dwillia2-xfh
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/cxl/test/mock.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index f1f8c40948c5..bce6a21df0d5 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -208,13 +208,15 @@ int __wrap_cxl_await_media_ready(struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_cxl_await_media_ready, CXL);
 
-bool __wrap_cxl_hdm_decode_init(struct cxl_dev_state *cxlds,
-				struct cxl_hdm *cxlhdm)
+int __wrap_cxl_hdm_decode_init(struct cxl_dev_state *cxlds,
+			       struct cxl_hdm *cxlhdm)
 {
 	int rc = 0, index;
 	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
 
-	if (!ops || !ops->is_mock_dev(cxlds->dev))
+	if (ops && ops->is_mock_dev(cxlds->dev))
+		rc = 0;
+	else
 		rc = cxl_hdm_decode_init(cxlds, cxlhdm);
 	put_cxl_mock_ops(index);
 
-- 
2.37.2



