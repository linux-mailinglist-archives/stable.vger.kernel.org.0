Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7896C166F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbjCTPGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjCTPFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:05:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EC72B625
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CB5CB80ED1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAF9C433A8;
        Mon, 20 Mar 2023 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324439;
        bh=xCmItfak/Ee3pijQvtPOXKezg1qLH8Yi/tBnF8gDm+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SD/7UOfzqJ7BkwWk0HMveJAK3cVICVCEy0ka70LgfOwk4CnNpUZbo5FnQ317wkoIz
         ukJaZ2Vr+6bO+BRTtQFtf2ghHJJBWs7kWIEAPamGQ39HaOS3xHeilyd6Z4orO7vaI1
         ADVwyzqExoJScK0GWHs/q/89SCMX1hQHE7DczF44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/60] nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
Date:   Mon, 20 Mar 2023 15:54:33 +0100
Message-Id: <20230320145431.924541438@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 5000fe6c27827a61d8250a7e4a1d26c3298ef4f6 ]

This bug influences both st_nci_i2c_remove and st_nci_spi_remove.
Take st_nci_i2c_remove as an example.

In st_nci_i2c_probe, it called ndlc_probe and bound &ndlc->sm_work
with llt_ndlc_sm_work.

When it calls ndlc_recv or timeout handler, it will finally call
schedule_work to start the work.

When we call st_nci_i2c_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in ndlc_remove

CPU0                  CPU1

                    |llt_ndlc_sm_work
st_nci_i2c_remove   |
  ndlc_remove       |
     st_nci_remove  |
     nci_free_device|
     kfree(ndev)    |
//free ndlc->ndev   |
                    |llt_ndlc_rcv_queue
                    |nci_recv_frame
                    |//use ndlc->ndev

Fixes: 35630df68d60 ("NFC: st21nfcb: Add driver for STMicroelectronics ST21NFCB NFC chip")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230312160837.2040857-1-zyytlz.wz@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/ndlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index 5d74c674368a5..8ccf5a86ad1bb 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -286,13 +286,15 @@ EXPORT_SYMBOL(ndlc_probe);
 
 void ndlc_remove(struct llt_ndlc *ndlc)
 {
-	st_nci_remove(ndlc->ndev);
-
 	/* cancel timers */
 	del_timer_sync(&ndlc->t1_timer);
 	del_timer_sync(&ndlc->t2_timer);
 	ndlc->t2_active = false;
 	ndlc->t1_active = false;
+	/* cancel work */
+	cancel_work_sync(&ndlc->sm_work);
+
+	st_nci_remove(ndlc->ndev);
 
 	skb_queue_purge(&ndlc->rcv_q);
 	skb_queue_purge(&ndlc->send_q);
-- 
2.39.2



