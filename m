Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1FE27C9B5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgI2Lha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbgI2Lh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C348F21D46;
        Tue, 29 Sep 2020 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379208;
        bh=VvOb9MOaCBEjlKScL5k0MHaYmhPul/awoDD2zE/EiUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/VMiGOvJC01blUS6DpXd6yykY7dlDbUgRcWD6jgwL2WimJNYujM3F4gEkXVJKzuz
         ck4QrLn74VJkiaER65qxEzMyEDscI/7K0OdtDT26Q+q20T9NykarRcfXgnyy8x6iYC
         kW7x678PhI9U2NcdpBAFBkdeyUYQGxpxHeipjZVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/388] dax: Fix alloc_dax_region() compile warning
Date:   Tue, 29 Sep 2020 12:56:01 +0200
Message-Id: <20200929110011.945102775@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



