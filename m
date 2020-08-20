Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A0624B811
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgHTKKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730864AbgHTKKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEEA5206DA;
        Thu, 20 Aug 2020 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918206;
        bh=ty18EZHzNNsdgv8w9u5VplsWbIv4nX7VRyU0h2WE+W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvZOkW3G8SUCgvx43RUT0G3AGDeYRIzA/xSDv+EpJ0FVOyP5TU4J3yNBa2ZTzSPgG
         Ko8Mdy2LqiuofukFXhqaICtAsloo5QBxoGcJqUkuhdCYvtpL04pGQgUrMHLowtNO5X
         vBjkePJ1Wxex7YwVjWKjWQ0udZ4GPejQ9C2s5iek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/228] ARM: socfpga: PM: add missing put_device() call in socfpga_setup_ocram_self_refresh()
Date:   Thu, 20 Aug 2020 11:20:34 +0200
Message-Id: <20200820091610.556262041@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 3ad7b4e8f89d6bcc9887ca701cf2745a6aedb1a0 ]

if of_find_device_by_node() succeed, socfpga_setup_ocram_self_refresh
doesn't have a corresponding put_device(). Thus add a jump target to
fix the exception handling for this function implementation.

Fixes: 44fd8c7d4005 ("ARM: socfpga: support suspend to ram")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-socfpga/pm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-socfpga/pm.c b/arch/arm/mach-socfpga/pm.c
index c378ab0c24317..93f2245c97750 100644
--- a/arch/arm/mach-socfpga/pm.c
+++ b/arch/arm/mach-socfpga/pm.c
@@ -60,14 +60,14 @@ static int socfpga_setup_ocram_self_refresh(void)
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
-		goto put_node;
+		goto put_device;
 	}
 
 	ocram_base = gen_pool_alloc(ocram_pool, socfpga_sdram_self_refresh_sz);
 	if (!ocram_base) {
 		pr_warn("%s: unable to alloc ocram!\n", __func__);
 		ret = -ENOMEM;
-		goto put_node;
+		goto put_device;
 	}
 
 	ocram_pbase = gen_pool_virt_to_phys(ocram_pool, ocram_base);
@@ -78,7 +78,7 @@ static int socfpga_setup_ocram_self_refresh(void)
 	if (!suspend_ocram_base) {
 		pr_warn("%s: __arm_ioremap_exec failed!\n", __func__);
 		ret = -ENOMEM;
-		goto put_node;
+		goto put_device;
 	}
 
 	/* Copy the code that puts DDR in self refresh to ocram */
@@ -92,6 +92,8 @@ static int socfpga_setup_ocram_self_refresh(void)
 	if (!socfpga_sdram_self_refresh_in_ocram)
 		ret = -EFAULT;
 
+put_device:
+	put_device(&pdev->dev);
 put_node:
 	of_node_put(np);
 
-- 
2.25.1



