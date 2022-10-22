Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19FF60872A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiJVH45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiJVHy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE6D2CA7E8;
        Sat, 22 Oct 2022 00:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BFF5B82DF6;
        Sat, 22 Oct 2022 07:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D6EC433D6;
        Sat, 22 Oct 2022 07:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424819;
        bh=XGkmMzPTDEeMhMngRVduxRnock1hXej9ySL7e00w6T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6Uoie7nRMhsn181Q8m/3TqZCpalbg4BrsAroshjsmSyppy6Sno3lsRIAZriY4buO
         AaY3nuyyEvBKh1tCzt4vbkbMa8mIUovxI7cYm9edGsn4ng4ilRwJh7XU/p2S6n/T9O
         jMuKzqDw+466V0aXKfIYcWPL81AZeyIm2rD3bEjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 288/717] eth: lan743x: reject extts for non-pci11x1x devices
Date:   Sat, 22 Oct 2022 09:22:47 +0200
Message-Id: <20221022072504.477747120@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

[ Upstream commit cb4b12071a4b68df323c339f60805834246b3e9e ]

Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not support
the PTP-IO Input event triggered timestamping mechanisms added

Fixes: 60942c397af6 ("net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)")
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index 6a11e2ceb013..da3ea905adbb 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -1049,6 +1049,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 					   enum ptp_pin_function func,
 					   unsigned int chan)
 {
+	struct lan743x_ptp *lan_ptp =
+		container_of(ptp, struct lan743x_ptp, ptp_clock_info);
+	struct lan743x_adapter *adapter =
+		container_of(lan_ptp, struct lan743x_adapter, ptp);
 	int result = 0;
 
 	/* Confirm the requested function is supported. Parameter
@@ -1057,7 +1061,10 @@ static int lan743x_ptpci_verify_pin_config(struct ptp_clock_info *ptp,
 	switch (func) {
 	case PTP_PF_NONE:
 	case PTP_PF_PEROUT:
+		break;
 	case PTP_PF_EXTTS:
+		if (!adapter->is_pci11x1x)
+			result = -1;
 		break;
 	case PTP_PF_PHYSYNC:
 	default:
-- 
2.35.1



