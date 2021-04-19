Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EA03643B9
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbhDSNVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241185AbhDSNUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1A7D613C0;
        Mon, 19 Apr 2021 13:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838152;
        bh=w9tavgDsSOx8Fnj8nGLIvTiLvOElq8xFmgiEzNAtNkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFnB7ByIflrvi0bA+XXuqHX2z5X6feolgvq5V3Nik1iKaaczbbgvyLOuVBoi4+0sb
         9CuSh8SO1weRAgyEzT/xYyAF55+peOWwdvOaUneFN+7sCP2GYjAdWev5Hn9yEeZNEg
         8CRNChQiIYzhXCt0fEWORwd5E70izjfJU4tm42Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shivaprasad G Bhat <sbhat@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 061/103] libnvdimm/region: Fix nvdimm_has_flush() to handle ND_REGION_ASYNC
Date:   Mon, 19 Apr 2021 15:06:12 +0200
Message-Id: <20210419130529.900009923@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

commit a2948b17f6b936fc52f86c0f92c46d2f91928b79 upstream.

In case a platform doesn't provide explicit flush-hints but provides an
explicit flush callback via ND_REGION_ASYNC region flag, then
nvdimm_has_flush() still returns '0' indicating that writes do not
require flushing. This happens on PPC64 with patch at [1] applied, where
'deep_flush' of a region was denied even though an explicit flush
function was provided.

Fix this by adding a condition to nvdimm_has_flush() to test for the
ND_REGION_ASYNC flag on the region and see if a 'region->flush' callback
is assigned.

Link: http://lore.kernel.org/r/161703936121.36.7260632399582101498.stgit@e1fbed493c87 [1]
Fixes: c5d4355d10d4 ("libnvdimm: nd_region flush callback support")
Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Link: https://lore.kernel.org/r/20210402092555.208590-1-vaibhav@linux.ibm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/region_devs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1239,6 +1239,11 @@ int nvdimm_has_flush(struct nd_region *n
 			|| !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
 		return -ENXIO;
 
+	/* Test if an explicit flush function is defined */
+	if (test_bit(ND_REGION_ASYNC, &nd_region->flags) && nd_region->flush)
+		return 1;
+
+	/* Test if any flush hints for the region are available */
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -1249,8 +1254,8 @@ int nvdimm_has_flush(struct nd_region *n
 	}
 
 	/*
-	 * The platform defines dimm devices without hints, assume
-	 * platform persistence mechanism like ADR
+	 * The platform defines dimm devices without hints nor explicit flush,
+	 * assume platform persistence mechanism like ADR
 	 */
 	return 0;
 }


