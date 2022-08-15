Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA84B5940BE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbiHOUwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346557AbiHOUur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:50:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F74ABB02A;
        Mon, 15 Aug 2022 12:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43CB3B81104;
        Mon, 15 Aug 2022 19:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732DFC433C1;
        Mon, 15 Aug 2022 19:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590582;
        bh=YUgwdv0ha6GfdedNy50XsgnM/nrwLiae3iEawstv30M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPffX3D2H8t0AOsSlaO/ZkQdMTGW/A7lKhH2If9mnZ0tEww6frJld+myYFSi9LHwN
         iM+uroDfbKk4fNsLJa8HYDkKECP2Bthxy6/cfbzg8ouc5pQkBvIfSmCBfbspHHIQH9
         DKv0HRghT3DX0JRJprN1NnLajeSWNaGnd8YlM7Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0306/1095] ath10k: do not enforce interrupt trigger type
Date:   Mon, 15 Aug 2022 19:55:05 +0200
Message-Id: <20220815180442.454980721@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1ee6c5abebd3cacf2ac4378d0ed4f57fd4850421 ]

Interrupt line can be configured on different hardware in different way,
even inverted.  Therefore driver should not enforce specific trigger
type - edge rising - but instead rely on Devicetree to configure it.

All Qualcomm DTSI with WCN3990 define the interrupt type as level high,
so the mismatch between DTSI and driver causes rebind issues:

  $ echo 18800000.wifi > /sys/bus/platform/drivers/ath10k_snoc/unbind
  $ echo 18800000.wifi > /sys/bus/platform/drivers/ath10k_snoc/bind
  [   44.763114] irq: type mismatch, failed to map hwirq-446 for interrupt-controller@17a00000!
  [   44.763130] ath10k_snoc 18800000.wifi: error -ENXIO: IRQ index 0 not found
  [   44.763140] ath10k_snoc 18800000.wifi: failed to initialize resource: -6

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.0.c8-00009-QCAHLSWSC8180XMTPLZ-1
Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

Fixes: c963a683e701 ("ath10k: add resource init and deinit for WCN3990")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220513151516.357549-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 8328966a0471..603dc7bebc0c 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1249,13 +1249,12 @@ static void ath10k_snoc_init_napi(struct ath10k *ar)
 static int ath10k_snoc_request_irq(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
-	int irqflags = IRQF_TRIGGER_RISING;
 	int ret, id;
 
 	for (id = 0; id < CE_COUNT_MAX; id++) {
 		ret = request_irq(ar_snoc->ce_irqs[id].irq_line,
-				  ath10k_snoc_per_engine_handler,
-				  irqflags, ce_name[id], ar);
+				  ath10k_snoc_per_engine_handler, 0,
+				  ce_name[id], ar);
 		if (ret) {
 			ath10k_err(ar,
 				   "failed to register IRQ handler for CE %d: %d\n",
-- 
2.35.1



