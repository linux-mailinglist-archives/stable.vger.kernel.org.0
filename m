Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0B26F43C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIRCBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgIRCBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88C9521734;
        Fri, 18 Sep 2020 02:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394509;
        bh=VvOb9MOaCBEjlKScL5k0MHaYmhPul/awoDD2zE/EiUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkEOqIetbTswIJm2poc3JLoyMk2HxNJTuRWMTsosTRtgkgYFqqV0W2DklOyqUDBLw
         KA+pvIS/sFD9ErP2xP0cnw108h0bs8KusRHb8xK4zbVcRpgmCg3Pu8cmbo0PLTpfZn
         7suagIJ/jndfQDhlEW9kwf2rEGs+BZ79jkI7IPt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 032/330] dax: Fix alloc_dax_region() compile warning
Date:   Thu, 17 Sep 2020 21:56:12 -0400
Message-Id: <20200918020110.2063155-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 460370ab20b6cc174256e46e192adf01e730faf6 ]

PFN flags are (unsigned long long), fix the alloc_dax_region() calling
convention to fix warnings of the form:

>> include/linux/pfn_t.h:18:17: warning: large integer implicitly truncated to unsigned type [-Woverflow]
    #define PFN_DEV (1ULL << (BITS_PER_LONG_LONG - 3))

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/bus.c         | 2 +-
 drivers/dax/bus.h         | 2 +-
 drivers/dax/dax-private.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 8fafbeab510a8..eccdda1f7b71b 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -227,7 +227,7 @@ static void dax_region_unregister(void *region)
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct resource *res, int target_node, unsigned int align,
-		unsigned long pfn_flags)
+		unsigned long long pfn_flags)
 {
 	struct dax_region *dax_region;
 
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 8619e32999436..9e4eba67e8b98 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -11,7 +11,7 @@ struct dax_region;
 void dax_region_put(struct dax_region *dax_region);
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct resource *res, int target_node, unsigned int align,
-		unsigned long flags);
+		unsigned long long flags);
 
 enum dev_dax_subsys {
 	DEV_DAX_BUS,
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 6ccca3b890d6f..3107ce80e8090 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -32,7 +32,7 @@ struct dax_region {
 	struct device *dev;
 	unsigned int align;
 	struct resource res;
-	unsigned long pfn_flags;
+	unsigned long long pfn_flags;
 };
 
 /**
-- 
2.25.1

