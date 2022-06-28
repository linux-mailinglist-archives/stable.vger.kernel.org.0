Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5155D082
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244064AbiF1CWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbiF1CVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3172724BD5;
        Mon, 27 Jun 2022 19:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C21366182E;
        Tue, 28 Jun 2022 02:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACC8C341CA;
        Tue, 28 Jun 2022 02:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382873;
        bh=TQfJaG9zC/M0UUZXEsftYKwm0ELB1QXHFP+12hN3PJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q7Iuf1MDcxz52+zmMPg5Lc5pG/NjEjpys1RVGBxyh9Zks27x7+FKnA0ZHw5Fuplw+
         CP/ChgFPD7OjtIM648SymAxsc+jRN2bP3gfwooRiFTYvMoh7pnixvoKe/SRysQD271
         n3/wJUv0pL5mr7ya1d9NLzVtaAtxyhX0OLh9NB0ezig/k2a6+aBnQe6g+baA+JjODc
         H02edtMb+8DTAq0hEVspJDd3T+q4zefSkBwc69XXHVP2w7KTunI0dYtt6TOATpW76f
         fvdkeGwhsi8G/wwra5br3wjVqcrRD4gpxs13D8LQs1zGXA97Jmqz7LC5CNd6CghNoq
         5j9BUtVpqXGgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 06/41] bus: bt1-apb: Don't print error on -EPROBE_DEFER
Date:   Mon, 27 Jun 2022 22:20:25 -0400
Message-Id: <20220628022100.595243-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit be5cddef05f519a321a543906f255ac247246074 ]

The Baikal-T1 APB bus driver correctly handles the deferred probe
situation, but still pollutes the system log with a misleading error
message. Let's fix that by using the dev_err_probe() method to print the
log message in case of the clocks/resets request errors.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20220610104030.28399-1-Sergey.Semin@baikalelectronics.ru'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/bt1-apb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/bus/bt1-apb.c b/drivers/bus/bt1-apb.c
index b25ff941e7c7..63b1b4a76671 100644
--- a/drivers/bus/bt1-apb.c
+++ b/drivers/bus/bt1-apb.c
@@ -175,10 +175,9 @@ static int bt1_apb_request_rst(struct bt1_apb *apb)
 	int ret;
 
 	apb->prst = devm_reset_control_get_optional_exclusive(apb->dev, "prst");
-	if (IS_ERR(apb->prst)) {
-		dev_warn(apb->dev, "Couldn't get reset control line\n");
-		return PTR_ERR(apb->prst);
-	}
+	if (IS_ERR(apb->prst))
+		return dev_err_probe(apb->dev, PTR_ERR(apb->prst),
+				     "Couldn't get reset control line\n");
 
 	ret = reset_control_deassert(apb->prst);
 	if (ret)
@@ -199,10 +198,9 @@ static int bt1_apb_request_clk(struct bt1_apb *apb)
 	int ret;
 
 	apb->pclk = devm_clk_get(apb->dev, "pclk");
-	if (IS_ERR(apb->pclk)) {
-		dev_err(apb->dev, "Couldn't get APB clock descriptor\n");
-		return PTR_ERR(apb->pclk);
-	}
+	if (IS_ERR(apb->pclk))
+		return dev_err_probe(apb->dev, PTR_ERR(apb->pclk),
+				     "Couldn't get APB clock descriptor\n");
 
 	ret = clk_prepare_enable(apb->pclk);
 	if (ret) {
-- 
2.35.1

