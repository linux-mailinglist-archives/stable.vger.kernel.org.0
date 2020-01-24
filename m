Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9361A148899
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390795AbgAXO3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392053AbgAXOUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E313218AC;
        Fri, 24 Jan 2020 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875651;
        bh=0ef1BWJcFDjFGtlT09zlYGPAEVc9MTH5OEySSi1l4b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SljaRYiePPAcPd24+3dPjzViDiatPCugD3exhYfLcS5z6l3lSI9DrQD4qkvHdQ9xB
         cDUwkVRZVcb2W+DO8FOgaSx3XOksdxN/AfwBmMVju332RBqJnDr1lJ+fBvGVv3oq5X
         up/wzcj5vI/yB/rn9uekD26CqJkVQFIShxXOqnsU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 33/56] parisc: Use proper printk format for resource_size_t
Date:   Fri, 24 Jan 2020 09:19:49 -0500
Message-Id: <20200124142012.29752-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 4f80b70e1953cb846dbdd1ce72cb17333d4c8d11 ]

resource_size_t should be printed with its own size-independent format
to fix warnings when compiling on 64-bit platform (e.g. with
COMPILE_TEST):

    arch/parisc/kernel/drivers.c: In function 'print_parisc_device':
    arch/parisc/kernel/drivers.c:892:9: warning:
        format '%p' expects argument of type 'void *',
        but argument 4 has type 'resource_size_t {aka unsigned int}' [-Wformat=]

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/drivers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index a1a5e4c59e6b2..4d5ad9cb0f692 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -868,8 +868,8 @@ static void print_parisc_device(struct parisc_device *dev)
 	static int count;
 
 	print_pa_hwpath(dev, hw_path);
-	pr_info("%d. %s at 0x%px [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-		++count, dev->name, (void*) dev->hpa.start, hw_path, dev->id.hw_type,
+	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
+		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
 		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
 
 	if (dev->num_addrs) {
-- 
2.20.1

