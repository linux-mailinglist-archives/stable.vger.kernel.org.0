Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9DF621595
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbiKHONU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbiKHONT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F76379
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F5ACB81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77877C433C1;
        Tue,  8 Nov 2022 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916795;
        bh=ajt/UXJ/B/hljgYDlT3L6o9lj1w9KFonQI5EqpLwva4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIOrxLuA0uKHdsdGVNNU66CkD/UwHLRREm0VUgCvpegRccEzUq3M0Tkhcnq+hSZyV
         iyXZb1N9KCzEmIirnGe4jHPFEX7pZa02zdEVvwHOV5KwEmiVVvN0k81TKo+C2jQ6hr
         4OcTthYOdr4U9Wr7clrlfpQ87sQSZjEIVupdA1LM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dave Jiang <dave.jiang@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 136/197] cxl/region: Fix cxl_region leak, cleanup targets at region delete
Date:   Tue,  8 Nov 2022 14:39:34 +0100
Message-Id: <20221108133401.125839891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

commit 0d9e734018d70cecf79e2e4c6082167160a0f13f upstream.

When a region is deleted any targets that have been previously assigned
to that region hold references to it. Trigger those references to
drop by detaching all targets at unregister_region() time.

Otherwise that region object will leak as userspace has lost the ability
to detach targets once region sysfs is torn down.

Cc: <stable@vger.kernel.org>
Fixes: b9686e8c8e39 ("cxl/region: Enable the assignment of endpoint decoders to regions")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166752183055.947915.17681995648556534844.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1556,8 +1556,19 @@ static struct cxl_region *to_cxl_region(
 static void unregister_region(void *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	int i;
 
 	device_del(dev);
+
+	/*
+	 * Now that region sysfs is shutdown, the parameter block is now
+	 * read-only, so no need to hold the region rwsem to access the
+	 * region parameters.
+	 */
+	for (i = 0; i < p->interleave_ways; i++)
+		detach_target(cxlr, i);
+
 	cxl_region_iomem_release(cxlr);
 	put_device(dev);
 }


