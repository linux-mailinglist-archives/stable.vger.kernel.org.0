Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496102A576F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbgKCUzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:55:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731206AbgKCUzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3F4322226;
        Tue,  3 Nov 2020 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436915;
        bh=2krI4vKDGlGHCjoREsfWY8/0uJTjTAT40akVRkQ4d1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpE80jnjsE6x5dJ6bF7M6N7Ke4xICLvxXUg4+hIvmQmlZE2+/Bvqd9SkWxs8SvoZ7
         fVMod09f3qvCp1o9cEgUo+9dH1srshHQtb6i3pzCS2gF7uJX8s061DoyMmLMnDSRUP
         xy5eoiThlL4HhiAtM7Xulxr/Pf0Twc6VNIjzIr/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/214] ACPI: Add out of bounds and numa_off protections to pxm_to_node()
Date:   Tue,  3 Nov 2020 21:35:13 +0100
Message-Id: <20201103203256.474462114@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index eadbf90e65d14..85e01752fbe47 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -31,7 +31,7 @@ int acpi_numa __initdata;
 
 int pxm_to_node(int pxm)
 {
-	if (pxm < 0)
+	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS || numa_off)
 		return NUMA_NO_NODE;
 	return pxm_to_node_map[pxm];
 }
-- 
2.27.0



