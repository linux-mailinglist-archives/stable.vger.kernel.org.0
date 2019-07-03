Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6DDA5DC30
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfGCCVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbfGCCQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6882187F;
        Wed,  3 Jul 2019 02:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120189;
        bh=Q9xGE9S4674mQZc11CtxVVU6MEbdl6REXUoTXVQ4/KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lz6S4g2Bsgz1eXuoCWXHo9o/tasHKowCyCJN1IGfg1/s7w/9iKQ1jgHpSyquB7WWI
         fJdS5G/0le5IouoDnMQyBecFkCnHkeux/YS2m+NTC1eb3f6qYaCx9SdjOTUczYCT8+
         epnDE/BO3nVrkliIc8sLQuVgDnLyEA5i+oV0XOXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/26] efi/bgrt: Drop BGRT status field reserved bits check
Date:   Tue,  2 Jul 2019 22:16:02 -0400
Message-Id: <20190703021625.18116-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a483fcab38b43fb34a7f12ab1daadd3907f150e2 ]

Starting with ACPI 6.2 bits 1 and 2 of the BGRT status field are no longer
reserved. These bits are now used to indicate if the image needs to be
rotated before being displayed.

The first device using these bits has now shown up (the GPD MicroPC) and
the reserved bits check causes us to reject the valid BGRT table on this
device.

Rather then changing the reserved bits check, allowing only the 2 new bits,
instead just completely remove it so that we do not end up with a similar
problem when more bits are added in the future.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi-bgrt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index b22ccfb0c991..2bf4d31f4967 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -50,11 +50,6 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 		       bgrt->version);
 		goto out;
 	}
-	if (bgrt->status & 0xfe) {
-		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
-		       bgrt->status);
-		goto out;
-	}
 	if (bgrt->image_type != 0) {
 		pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
 		       bgrt->image_type);
-- 
2.20.1

