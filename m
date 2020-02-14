Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EF015E69F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404892AbgBNQtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405223AbgBNQUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:20:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899F02473C;
        Fri, 14 Feb 2020 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697231;
        bh=3lggvye2TNtsXGcR8Lo/AZGOvArFDvKoC+VW/0FRLvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+M4TG/R/sb931uK5/I25zn6jU6TREP4gJJJVLvcZfEcNVSR/ns3/BfKbCNKSGqxO
         YCLKrmuUUhjnr0FgDffYr1D7PGIt2sX9o12vaC52+g1ZDCBtCZQsKmyciOch8mTK2v
         d20WgBS5bFqmowirPVqCXPXnQdwbOEio7vz5Lej0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 153/186] platform/x86: intel_mid_powerbtn: Take a copy of ddata
Date:   Fri, 14 Feb 2020 11:16:42 -0500
Message-Id: <20200214161715.18113-153-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 5e0c94d3aeeecc68c573033f08d9678fecf253bd ]

The driver gets driver_data from memory that is marked as const (which
is probably put to read-only memory) and it then modifies it. This
likely causes some sort of fault to happen.

Fix this by taking a copy of the structure.

Fixes: c94a8ff14de3 ("platform/x86: intel_mid_powerbtn: make mid_pb_ddata const")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_mid_powerbtn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index 5ad44204a9c3c..10dbd6cac48ae 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -158,9 +158,10 @@ static int mid_pb_probe(struct platform_device *pdev)
 
 	input_set_capability(input, EV_KEY, KEY_POWER);
 
-	ddata = (struct mid_pb_ddata *)id->driver_data;
+	ddata = devm_kmemdup(&pdev->dev, (void *)id->driver_data,
+			     sizeof(*ddata), GFP_KERNEL);
 	if (!ddata)
-		return -ENODATA;
+		return -ENOMEM;
 
 	ddata->dev = &pdev->dev;
 	ddata->irq = irq;
-- 
2.20.1

