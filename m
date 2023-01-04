Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C37F65D82E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbjADQMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbjADQLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:11:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CA1DDD9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C715DB81730
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257EFC433F0;
        Wed,  4 Jan 2023 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848671;
        bh=OLjrCg7gU2oIEd4+JZIfSItkyt05E6WU+Zqd4grtruw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4TILi/RD219387Ru8vUnkAGSQ0MsFXChLVOkTmgv6ogTFdNS/8Q3m7wl/L5crzyH
         bnrXT0ragl80YakUsp63ARoUhX0FdTfStus5lhYeMuiJg4IYpMnMhV232DW0dGVTbm
         I5GTMvhtAQ7X5bXcv2g2OxPLhlTYPv1QEsyhYDN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Davidlohr Bueso <dave@stgolabs.net>,
        Dave Jiang <dave.jiang@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.1 028/207] cxl/region: Fix missing probe failure
Date:   Wed,  4 Jan 2023 17:04:46 +0100
Message-Id: <20230104160512.807273692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit bf3e5da8cb43a671b32fc125fa81b8f6a3677192 upstream.

cxl_region_probe() allows for regions not in the 'commit' state to be
enabled. Fail probe when the region is not committed otherwise the
kernel may indicate that an address range is active when none of the
decoders are active.

Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
Cc: <stable@vger.kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct devic
 	 */
 	up_read(&cxl_region_rwsem);
 
+	if (rc)
+		return rc;
+
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);


