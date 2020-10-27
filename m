Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3F429C340
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902232AbgJ0Obh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897378AbgJ0Obf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAD2206DC;
        Tue, 27 Oct 2020 14:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809094;
        bh=5PeYcanFkuDfqhc8YhOoYXsGarkvnJEjS9L5CZOjriU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLDSoaKuCEQfUjCGpfqNFUoBSS40gEl5rL1PuShrmoIpZP+A10JGw4MNA1L1C/Mx4
         RL1Dmydu/s+PRzZmHDSxl/nDXN9MdWEC0ZitYRZbGXMCAGxjd+iAfN5lLDPruU0ouC
         5fEgOdsqPdZ+ozSxWjedxQx037nbmlmAompu7eBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/408] media: ov5640: Correct Bit Div register in clock tree diagram
Date:   Tue, 27 Oct 2020 14:50:11 +0100
Message-Id: <20201027135458.448099198@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 4c85f628f6639e3e3e0a7788416154f28dfcae4f ]

Although the code is correct and doing the right thing, the clock diagram
showed the wrong register for the bit divider, which had me doubting the
understanding of the tree. Fix this to avoid doubts in the future.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Fixes: aa2882481cada ("media: ov5640: Adjust the clock based on the expected rate")
Acked-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 266e947572c1e..b21ddbd514465 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -740,7 +740,7 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
  *               +->| PLL Root Div | - reg 0x3037, bit 4
  *                  +-+------------+
  *                    |  +---------+
- *                    +->| Bit Div | - reg 0x3035, bits 0-3
+ *                    +->| Bit Div | - reg 0x3034, bits 0-3
  *                       +-+-------+
  *                         |  +-------------+
  *                         +->| SCLK Div    | - reg 0x3108, bits 0-1
-- 
2.25.1



