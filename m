Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E871A5618
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgDKXOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729121AbgDKXOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:14:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B981720CC7;
        Sat, 11 Apr 2020 23:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646845;
        bh=ZdMmlu8rq6FnZHNvz1fx4gohu8sKPOucgZZcA5ktuyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYWgS0EsFnmmr5/0derzhgchageuw0Rcoz1xiwcAwkLQngGBiMTDurb8HSGygYYkd
         Xh0X9OPc9xguE9oVC9ecG2HCWaAfjNEhhJDI1VMvlms7dDBnvCILRXQKHycJ0F0Cdl
         8VHLIPMDhpoKFx6Ml2fLYccZQHCPj7Vc104ZuN2I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Daly <pdaly@codeaurora.org>,
        "Isaac J . Manjarres" <isaacm@codeaurora.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/37] of: of_reserved_mem: Increase limit on number of reserved regions
Date:   Sat, 11 Apr 2020 19:13:21 -0400
Message-Id: <20200411231327.26550-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231327.26550-1-sashal@kernel.org>
References: <20200411231327.26550-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Daly <pdaly@codeaurora.org>

[ Upstream commit 632c99084052aef1c9dcfe43d2720306026d6d21 ]

Certain SoCs need to support a large amount of reserved memory
regions. For example, Qualcomm's SM8150 SoC requires that 20
regions of memory be reserved for a variety of reasons (e.g.
loading a peripheral subsystem's firmware image into a
particular space).

When adding more reserved memory regions to cater to different
usecases, the remaining number of reserved memory regions--12
to be exact--becomes too small. Thus, double the existing
limit of reserved memory regions.

Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 32771c2ced7bb..fd89159bf5162 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -25,7 +25,7 @@
 #include <linux/sort.h>
 #include <linux/slab.h>
 
-#define MAX_RESERVED_REGIONS	32
+#define MAX_RESERVED_REGIONS	64
 static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
 static int reserved_mem_count;
 
-- 
2.20.1

