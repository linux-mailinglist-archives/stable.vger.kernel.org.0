Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA086299F29
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388587AbgJ0AFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438009AbgJ0AE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:04:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11FEF217A0;
        Tue, 27 Oct 2020 00:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757097;
        bh=enY7JVLpF4ILTIjaBugz5o/RjfpPcWGkpgiAfoxAgw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrnRy7NnH8f4ajDhztlh20Ma1Hh1QgtIsille8xI/uBQOpCb89jVBc/+8s2MjWrg6
         FrCCu3xiULC4Pt7CzjipM+iRHlmbiYUlqedUbMFtP08lG5U7Kr72hxow43sfw2EkpD
         a1oPExGWO+clgRrcy7qYzO6Mexl6tke3rnx1IMpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/60] ACPI: Add out of bounds and numa_off protections to pxm_to_node()
Date:   Mon, 26 Oct 2020 20:03:50 -0400
Message-Id: <20201027000415.1026364-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 8a3decac087aa897df5af04358c2089e52e70ac4 ]

The function should check the validity of the pxm value before using
it to index the pxm_to_node_map[] array.

Whilst hardening this code may be good in general, the main intent
here is to enable following patches that use this function to replace
acpi_map_pxm_to_node() for non SRAT usecases which should return
NO_NUMA_NODE for PXM entries not matching with those in SRAT.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 0da58f0bf7e59..a28ff3cfbc296 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -46,7 +46,7 @@ int acpi_numa __initdata;
 
 int pxm_to_node(int pxm)
 {
-	if (pxm < 0)
+	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS || numa_off)
 		return NUMA_NO_NODE;
 	return pxm_to_node_map[pxm];
 }
-- 
2.25.1

