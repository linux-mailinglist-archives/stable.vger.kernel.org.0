Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FCA2C2411
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 12:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbgKXL0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 06:26:10 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:44147 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732658AbgKXL0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 06:26:09 -0500
X-IronPort-AV: E=Sophos;i="5.78,366,1599490800"; 
   d="scan'208";a="63718439"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 24 Nov 2020 20:26:08 +0900
Received: from localhost.localdomain (unknown [10.226.36.204])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 6AE444362273;
        Tue, 24 Nov 2020 20:26:06 +0900 (JST)
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
Subject: [PATCH 1/5] memory: renesas-rpc-if: Return correct value to the caller of rpcif_manual_xfer()
Date:   Tue, 24 Nov 2020 11:25:48 +0000
Message-Id: <20201124112552.26377-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201124112552.26377-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20201124112552.26377-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
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
2.17.1

