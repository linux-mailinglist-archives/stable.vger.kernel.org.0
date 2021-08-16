Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BED3ED60D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhHPNQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240280AbhHPNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0D9D632E2;
        Mon, 16 Aug 2021 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119531;
        bh=3RId6V6zYYDi/pccIHEi8K4ryD1TjyY/slvsIX9t4is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rh8dpDAjV7tXeOUZTGEzLmxNxJPEj0T0hvzruuAvAR9x8xez/M55Pm5T1gNYZ9kXY
         wywBcUtgYo6bqt+RXCCS7uyuWivTW5OXORLV9G60RlKQ+v3Z6yd067vEcxoV/IoQYi
         npdKhOxNe512T/gCDf+5xRYn1bkbIE6ct1cu6X+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kensicki <krzysztof.kensicki@intel.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.13 029/151] libnvdimm/region: Fix label activation vs errors
Date:   Mon, 16 Aug 2021 15:00:59 +0200
Message-Id: <20210816125445.036282214@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit d9cee9f85b22fab88d2b76d2e92b18e3d0e6aa8c upstream.

There are a few scenarios where init_active_labels() can return without
registering deactivate_labels() to run when the region is disabled. In
particular label error injection creates scenarios where a DIMM is
disabled, but labels on other DIMMs in the region become activated.

Arrange for init_active_labels() to always register deactivate_labels().

Reported-by: Krzysztof Kensicki <krzysztof.kensicki@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation.")
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/162766356450.3223041.1183118139023841447.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/namespace_devs.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2527,7 +2527,7 @@ static void deactivate_labels(void *regi
 
 static int init_active_labels(struct nd_region *nd_region)
 {
-	int i;
+	int i, rc = 0;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
@@ -2546,13 +2546,14 @@ static int init_active_labels(struct nd_
 			else if (test_bit(NDD_LABELING, &nvdimm->flags))
 				/* fail, labels needed to disambiguate dpa */;
 			else
-				return 0;
+				continue;
 
 			dev_err(&nd_region->dev, "%s: is %s, failing probe\n",
 					dev_name(&nd_mapping->nvdimm->dev),
 					test_bit(NDD_LOCKED, &nvdimm->flags)
 					? "locked" : "disabled");
-			return -ENXIO;
+			rc = -ENXIO;
+			goto out;
 		}
 		nd_mapping->ndd = ndd;
 		atomic_inc(&nvdimm->busy);
@@ -2586,13 +2587,17 @@ static int init_active_labels(struct nd_
 			break;
 	}
 
-	if (i < nd_region->ndr_mappings) {
+	if (i < nd_region->ndr_mappings)
+		rc = -ENOMEM;
+
+out:
+	if (rc) {
 		deactivate_labels(nd_region);
-		return -ENOMEM;
+		return rc;
 	}
 
 	return devm_add_action_or_reset(&nd_region->dev, deactivate_labels,
-			nd_region);
+					nd_region);
 }
 
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err)


