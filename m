Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ACE3EC914
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhHOMl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhHOMl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E3561106;
        Sun, 15 Aug 2021 12:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629031259;
        bh=maHJl6sMSnBU3zFcuh0XHDSaALoeFh/oMtA7+FdDOQw=;
        h=Subject:To:Cc:From:Date:From;
        b=PUdpf132MT5A6hndJxs94tKxBeJdrDuUSVuOaMl0VPjD4DmM6+ZY8zwF6v4107Iw2
         JlcqSiaCvsnYZtSZySxVL+KtjwAS6NV41KPAvfw+cWBqlfPWZDGA8iCfIsyb+UhwtR
         dtTEPfoTLb7tAICUh84B3R5VaAQnCRxLJ5MqwTlw=
Subject: FAILED: patch "[PATCH] libnvdimm/region: Fix label activation vs errors" failed to apply to 4.4-stable tree
To:     dan.j.williams@intel.com, jmoyer@redhat.com,
        krzysztof.kensicki@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Aug 2021 14:40:56 +0200
Message-ID: <1629031256146111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d9cee9f85b22fab88d2b76d2e92b18e3d0e6aa8c Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jul 2021 09:46:04 -0700
Subject: [PATCH] libnvdimm/region: Fix label activation vs errors

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

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 2403b71b601e..745478213ff2 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2527,7 +2527,7 @@ static void deactivate_labels(void *region)
 
 static int init_active_labels(struct nd_region *nd_region)
 {
-	int i;
+	int i, rc = 0;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
@@ -2546,13 +2546,14 @@ static int init_active_labels(struct nd_region *nd_region)
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
@@ -2586,13 +2587,17 @@ static int init_active_labels(struct nd_region *nd_region)
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

