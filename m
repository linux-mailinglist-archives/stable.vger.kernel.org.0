Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2765C1A5A68
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgDKXnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbgDKXGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0945B20787;
        Sat, 11 Apr 2020 23:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646383;
        bh=omF1iRanyQ8S752QBPEFo8RD9YAGvCRHuHarTQ18A/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+/xfnI//Bviwv2jNw5METQDwSP8SKssENYMu/w0MR+j4xIVldJb8AcbygwYrzDZm
         XZkWpQ3U2LVeYANcTbzaHtjoKo6Y37/ykbK/4y6xA01rl3chK0G9fqrQkt/GiGNUg+
         vL4yA6OUs86szeqBPvsaemfk9h9NI3xk3te0nOIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Daly <pdaly@codeaurora.org>,
        "Isaac J . Manjarres" <isaacm@codeaurora.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 124/149] of: of_reserved_mem: Increase limit on number of reserved regions
Date:   Sat, 11 Apr 2020 19:03:21 -0400
Message-Id: <20200411230347.22371-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
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
index 6bd610ee2cd73..1a84bc0d5fa80 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 
-#define MAX_RESERVED_REGIONS	32
+#define MAX_RESERVED_REGIONS	64
 static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
 static int reserved_mem_count;
 
-- 
2.20.1

