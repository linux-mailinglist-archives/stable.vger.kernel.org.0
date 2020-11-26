Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6697B2C5C7C
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 20:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405200AbgKZTL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 14:11:57 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:49537 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405176AbgKZTL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 14:11:57 -0500
X-IronPort-AV: E=Sophos;i="5.78,372,1599490800"; 
   d="scan'208";a="64008832"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 27 Nov 2020 04:11:55 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 85F1440F8AD9;
        Fri, 27 Nov 2020 04:11:53 +0900 (JST)
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
Subject: [PATCH v2 1/5] memory: renesas-rpc-if: Return correct value to the caller of rpcif_manual_xfer()
Date:   Thu, 26 Nov 2020 19:11:42 +0000
Message-Id: <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the error path of rpcif_manual_xfer() the value of ret is overwritten
by value returned by reset_control_reset() function and thus returning
incorrect value to the caller.

This patch makes sure the correct value is returned to the caller of
rpcif_manual_xfer() by dropping the overwrite of ret in error path.
Also now we ignore the value returned by reset_control_reset() in the
error path and instead print a error message when it fails.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
---
 drivers/memory/renesas-rpc-if.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index f2a33a1af836..69f2e2b4cd50 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -508,7 +508,8 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 	return ret;
 
 err_out:
-	ret = reset_control_reset(rpc->rstc);
+	if (reset_control_reset(rpc->rstc))
+		dev_err(rpc->dev, "Failed to reset HW\n");
 	rpcif_hw_init(rpc, rpc->bus_size == 2);
 	goto exit;
 }
-- 
2.25.1

