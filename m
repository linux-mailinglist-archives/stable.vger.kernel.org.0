Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3769C2C5C82
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 20:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405221AbgKZTMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 14:12:02 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:49537 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405176AbgKZTMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 14:12:02 -0500
X-IronPort-AV: E=Sophos;i="5.78,372,1599490800"; 
   d="scan'208";a="64008835"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Nov 2020 04:12:01 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1E57E40F8AE0;
        Fri, 27 Nov 2020 04:11:58 +0900 (JST)
From:   Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/5] memory: renesas-rpc-if: Fix a reference leak in rpcif_probe()
Date:   Thu, 26 Nov 2020 19:11:44 +0000
Message-Id: <20201126191146.8753-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Release the node reference by calling of_node_put(flash) in the probe.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
 drivers/memory/renesas-rpc-if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index a8d0ba368625..da0fdb4c7595 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -561,9 +561,11 @@ static int rpcif_probe(struct platform_device *pdev)
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
2.25.1

