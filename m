Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8964594742
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbiHOXR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353416AbiHOXQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774E81481E9;
        Mon, 15 Aug 2022 13:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 544A3B81145;
        Mon, 15 Aug 2022 20:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C24C433D6;
        Mon, 15 Aug 2022 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593790;
        bh=IlsTSu6kQK1W/fpZxKV4UfY/eYMvYpK9w43YyHcTS5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6Q8uDjzEJ1qy8TFVnewFKhaYMu0HHQAMJjHwzfGoiRq1tZuoVxcbEoB80yv8Eaav
         DDyMxDyXWfuXPCbU5PgjIBjhAUDyZkkajYJCsEWYRgD3lyDrBXE1fixkxdN0Dk+tgG
         cHaMd+PY3TaQeFXl4iU7gLDuI5ozABrtvSyEvliQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0326/1157] ath11k: fix IRQ affinity warning on shutdown
Date:   Mon, 15 Aug 2022 19:54:42 +0200
Message-Id: <20220815180452.690231330@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 3bd0c69653ac636eae8872aacdcd4156f772f928 ]

Make sure to clear the IRQ affinity hint also on shutdown to avoid
triggering a WARN_ON_ONCE() in __free_irq() when stopping MHI while
using a single MSI vector.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Fixes: e94b07493da3 ("ath11k: Set IRQ affinity to CPU0 in case of one MSI vector")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220523143258.24818-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index dedf1b88ddf6..487a303b3077 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -920,7 +920,9 @@ static void ath11k_pci_remove(struct pci_dev *pdev)
 static void ath11k_pci_shutdown(struct pci_dev *pdev)
 {
 	struct ath11k_base *ab = pci_get_drvdata(pdev);
+	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 
+	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
 	ath11k_pci_power_down(ab);
 }
 
-- 
2.35.1



