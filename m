Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1D42C241E
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 12:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgKXL0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 06:26:19 -0500
Received: from relmlor2.renesas.com ([210.160.252.172]:10210 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732791AbgKXL0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 06:26:19 -0500
X-IronPort-AV: E=Sophos;i="5.78,366,1599490800"; 
   d="scan'208";a="63502464"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 24 Nov 2020 20:26:18 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 3F9774362272;
        Tue, 24 Nov 2020 20:26:16 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/5] memory: renesas-rpc-if: Fix a reference leak in rpcif_probe()
Date:   Tue, 24 Nov 2020 11:25:52 +0000
Message-Id: <20201124112552.26377-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124112552.26377-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20201124112552.26377-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Release the node reference by calling of_node_put(flash) in the probe.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: stable@vger.kernel.org
---
 drivers/memory/renesas-rpc-if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index f5cbc762fda7..99633986ffda 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -548,9 +548,11 @@ static int rpcif_probe(struct platform_device *pdev)
 	} else if (of_device_is_compatible(flash, "cfi-flash")) {
 		name = "rpc-if-hyperflash";
 	} else	{
+		of_node_put(flash);
 		dev_warn(&pdev->dev, "unknown flash type\n");
 		return -ENODEV;
 	}
+	of_node_put(flash);
 
 	vdev = platform_device_alloc(name, pdev->id);
 	if (!vdev)
-- 
2.17.1

