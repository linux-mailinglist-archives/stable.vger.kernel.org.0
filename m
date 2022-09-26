Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4C5EA489
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiIZLrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiIZLpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EA874CF4;
        Mon, 26 Sep 2022 03:47:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA4660B6A;
        Mon, 26 Sep 2022 10:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD4BC433C1;
        Mon, 26 Sep 2022 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189245;
        bh=5pzVapFewRf8dhts3wO4wAqPZZ8cp8qrxhoG9oAqP6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/bA145+XMfKKB4f30s5M94WBJnKhmy4Z+rLBCP44LJgaxRnnbIRQ6gTNzsbLG4r9
         CHd9U5+Czkz3eWk4HT13cmdLS+8LGAWYG319PFlkGj4IHmvY2yRO0WprptQzY0xH3i
         IF6y1tgLMp+1A3QVM56xeEJgB2buknz0SwPJ1tMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 121/207] bnxt_en: fix flags to check for supported fw version
Date:   Mon, 26 Sep 2022 12:11:50 +0200
Message-Id: <20220926100811.984660365@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit ae8ffba8baad651af706538e8c47d0a049d406c6 ]

The warning message of unsupported FW appears every time RX timestamps
are disabled on the interface. The patch fixes the flags to correct set
for the check.

Fixes: 66ed81dcedc6 ("bnxt_en: Enable packet timestamping for all RX packets")
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220915234932.25497-1-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 7f3c0875b6f5..8e316367f6ce 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -317,9 +317,9 @@ void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp)
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_RX_ALL_PKT_TS) && (ptp->tstamp_filters &
 	    (PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE |
-	     PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE))) {
+	     PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_DISABLE))) {
 		ptp->tstamp_filters &= ~(PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE |
-					 PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE);
+					 PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_DISABLE);
 		netdev_warn(bp->dev, "Unsupported FW for all RX pkts timestamp filter\n");
 	}
 
-- 
2.35.1



