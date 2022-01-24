Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E595498F25
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351188AbiAXTus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:50:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41458 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345383AbiAXToA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79DFA6153B;
        Mon, 24 Jan 2022 19:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C7FC340E5;
        Mon, 24 Jan 2022 19:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053436;
        bh=UhT0JaI55mgQA7ptyJJ/KmDglLAZ1One7Pak05Uef7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TK6izvzpgciGi1Vdu2gZB9GhUD2roEZ6vMPvWSASP/d8j4ICgK+pTyfC9w5vM/1fi
         JyeHC2SxfcpFYX7RJvtx/cwxCNUPRZ/FsK06OMGUCRZs4W9NxVGh96kMAQBZo8QFF+
         kkwR38F8KCHdduydG4EQ4b1YoOAxEXEd0v2oT0R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/563] mtd: hyperbus: rpc-if: Check return value of rpcif_sw_init()
Date:   Mon, 24 Jan 2022 19:37:08 +0100
Message-Id: <20220124184026.590890267@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 981387ed06b96908223a607f5fba6efa42728fc2 ]

rpcif_sw_init() can fail so make sure we check the return value
of it and on error exit rpcif_hb_probe() callback with error code.

Fixes: 5de15b610f78 ("mtd: hyperbus: add Renesas RPC-IF driver")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20211025205631.21151-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/rpc-if.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index ecb050ba95cdf..367b0d72bf622 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -124,7 +124,9 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 	if (!hyperbus)
 		return -ENOMEM;
 
-	rpcif_sw_init(&hyperbus->rpc, pdev->dev.parent);
+	error = rpcif_sw_init(&hyperbus->rpc, pdev->dev.parent);
+	if (error)
+		return error;
 
 	platform_set_drvdata(pdev, hyperbus);
 
-- 
2.34.1



