Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059E745C4AF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351995AbhKXNuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354231AbhKXNtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684C261A02;
        Wed, 24 Nov 2021 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758972;
        bh=gjUG6+LBHjMZ1Kr7edkSf0qs+90PlyljuxOKpiXbHnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU9cvFihgXA4EkuzpwQwweQswKQYjQn+MC4gIkwUXDldQjYiMAI2KwRgYd0ydEEoj
         mGNDAI92jED7etDjP1mH78gEnPs/uGSqozrhfG8pB5GzY8ykJlYUeMOEXoYAFceex6
         qer4ap6Rzs6dil76D0ozFtN8oVob3rQ57/XxxcXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eero Tamminen <eero.t.tamminen@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/279] iommu/vt-d: Do not falsely log intel_iommu is unsupported kernel option
Date:   Wed, 24 Nov 2021 12:55:45 +0100
Message-Id: <20211124115720.723838198@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit 5240aed2cd2594fb392239f11b9681e5e1591619 ]

Handling of intel_iommu kernel command line option should return "true" to
indicate option is valid and so avoid logging it as unknown by the core
parsing code.

Also log unknown sub-options at the notice level to let user know of
potential typos or similar.

Reported-by: Eero Tamminen <eero.t.tamminen@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://lore.kernel.org/r/20210831112947.310080-1-tvrtko.ursulin@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20211014053839.727419-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d75f59ae28e6e..9a356075d3450 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -412,6 +412,7 @@ static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
 		return -EINVAL;
+
 	while (*str) {
 		if (!strncmp(str, "on", 2)) {
 			dmar_disabled = 0;
@@ -441,13 +442,16 @@ static int __init intel_iommu_setup(char *str)
 		} else if (!strncmp(str, "tboot_noforce", 13)) {
 			pr_info("Intel-IOMMU: not forcing on after tboot. This could expose security risk for tboot\n");
 			intel_iommu_tboot_noforce = 1;
+		} else {
+			pr_notice("Unknown option - '%s'\n", str);
 		}
 
 		str += strcspn(str, ",");
 		while (*str == ',')
 			str++;
 	}
-	return 0;
+
+	return 1;
 }
 __setup("intel_iommu=", intel_iommu_setup);
 
-- 
2.33.0



