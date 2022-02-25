Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F504C51F4
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 00:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbiBYXO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 18:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiBYXO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 18:14:56 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375AE199D74
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645830864; x=1677366864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ytu+QcjtppYEy8kkU9ah/HdFDSFEgni4rTrKUJ9n/6M=;
  b=i+ytY2FP+02zULME7UeaDj/KsZpszolO58mV86Q5svL8pCr8s3DBqu12
   1G2+C1H6CrCyOiQhO01JwvuxQAyyD8UmYAhUdq8pV1/H53sMIymgbAMan
   5jEUB1uaBBVgAOVpNwngvwOfMCPxfU5Dhj3jKgt3fJiaiq953m+P+5QxO
   APL3uYujpRfdkSnMRCSIQShAQGugBhAzjOCI7yBZpOGp3ldvlbXhOL4yG
   86FLj1rU6Hwkp51goyUhNXlA/FAHY4oO8SL7BxBbZMcGJiAE3h6cKL7R2
   /2D3hh4XwM7fgFhRAdKPnHnh67fY25y5f3N6hwIbzuRse/RzHq4djYQQe
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10269"; a="250179675"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="250179675"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 15:14:24 -0800
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="544195989"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 15:14:19 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id B72E4204B1;
        Sat, 26 Feb 2022 01:14:17 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.94.2)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1nNjnY-00B80d-2Z; Sat, 26 Feb 2022 01:14:52 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-drivers-review@eclists.intel.com
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        rafael.j.wysocki@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 01/18] ACPI: property: Always return -ENOENT if there are no more references
Date:   Sat, 26 Feb 2022 01:14:34 +0200
Message-Id: <20220225231451.2652330-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225231451.2652330-1-sakari.ailus@linux.intel.com>
References: <20220225231451.2652330-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__acpi_node_get_property_reference() is documented to return -ENOENT if
the caller requests a property reference at an index that does not exist,
not -EINVAL which it actually does.

Fix this by returning -ENOENT consistenly, independently of whether the
property value is a plain reference or a package.

Fixes: c343bc2ce2c6 ("ACPI: properties: Align return codes of __acpi_node_get_property_reference()")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/acpi/property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index d0986bda29640..3fceb4681ec9f 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -685,7 +685,7 @@ int __acpi_node_get_property_reference(const struct fwnode_handle *fwnode,
 	 */
 	if (obj->type == ACPI_TYPE_LOCAL_REFERENCE) {
 		if (index)
-			return -EINVAL;
+			return -ENOENT;
 
 		device = acpi_fetch_acpi_dev(obj->reference.handle);
 		if (!device)
-- 
2.30.2

