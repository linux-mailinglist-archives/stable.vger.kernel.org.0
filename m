Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D41169492B
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBMO44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjBMO4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:56:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E051D93E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29DDDB81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E92C433EF;
        Mon, 13 Feb 2023 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300160;
        bh=piY5C0SW0QwhKhFd4bdTsT8zzgB32Iprq2BzyF8qr34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wP05ylQ9M1mCFZJQJ90nLjOCcPg7F95uzLGWp87MjiVPN5W0zDNgG3LzK1Q+qR6r1
         nf0SFhgNIGSrwhUZdOCtvI6lCaJnxouqNjgDaboUm7BttiGubc1NFtyxhgmSKECh7/
         afnVs0vclP2h0QE4eVEjhP51KpFjXDXkC8n3uQvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fan Ni <fan.ni@samsung.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dave Jiang <dave.jiang@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gregory Price <gregory.price@memverge.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.1 087/114] cxl/region: Fix null pointer dereference for resetting decoder
Date:   Mon, 13 Feb 2023 15:48:42 +0100
Message-Id: <20230213144746.649020816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Fan Ni <fan.ni@samsung.com>

commit 4fa4302d6dc7de7e8e74dc7405611a2efb4bf54b upstream.

Not all decoders have a reset callback.

The CXL specification allows a host bridge with a single root port to
have no explicit HDM decoders. Currently the region driver assumes there
are none.  As such the CXL core creates a special pass through decoder
instance without a commit/reset callback.

Prior to this patch, the ->reset() callback was called unconditionally when
calling cxl_region_decode_reset. Thus a configuration with 1 Host Bridge,
1 Root Port, and one directly attached CXL type 3 device or multiple CXL
type 3 devices attached to downstream ports of a switch can cause a null
pointer dereference.

Before the fix, a kernel crash was observed when we destroy the region, and
a pass through decoder is reset.

The issue can be reproduced as below,
    1) create a region with a CXL setup which includes a HB with a
    single root port under which a memdev is attached directly.
    2) destroy the region with cxl destroy-region regionX -f.

Fixes: 176baefb2eb5 ("cxl/hdm: Commit decoder state to hardware")
Cc: <stable@vger.kernel.org>
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Gregory Price <gregory.price@memverge.com>
Reviewed-by: Gregory Price <gregory.price@memverge.com>
Link: https://lore.kernel.org/r/20221215170909.2650271-1-fan.ni@samsung.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 02f28da519e3..02275e6b621b 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -131,7 +131,7 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 		struct cxl_port *iter = cxled_to_port(cxled);
 		struct cxl_ep *ep;
-		int rc;
+		int rc = 0;
 
 		while (!is_cxl_root(to_cxl_port(iter->dev.parent)))
 			iter = to_cxl_port(iter->dev.parent);
@@ -143,7 +143,8 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 
 			cxl_rr = cxl_rr_load(iter, cxlr);
 			cxld = cxl_rr->decoder;
-			rc = cxld->reset(cxld);
+			if (cxld->reset)
+				rc = cxld->reset(cxld);
 			if (rc)
 				return rc;
 		}
@@ -186,7 +187,8 @@ static int cxl_region_decode_commit(struct cxl_region *cxlr)
 			     iter = ep->next, ep = cxl_ep_load(iter, cxlmd)) {
 				cxl_rr = cxl_rr_load(iter, cxlr);
 				cxld = cxl_rr->decoder;
-				cxld->reset(cxld);
+				if (cxld->reset)
+					cxld->reset(cxld);
 			}
 
 			cxled->cxld.reset(&cxled->cxld);
-- 
2.39.1



