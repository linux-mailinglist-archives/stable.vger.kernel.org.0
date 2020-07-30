Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D89232D86
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgG3ILb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbgG3ILT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:11:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 117F32070B;
        Thu, 30 Jul 2020 08:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096678;
        bh=FdlwV/CSg0mH3UGAbpypI/3ONIH+hodR1CAgMPCbYs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc2s9GLd445P8uMogOmMsAAIF7OkW7G99i0pD7FIUIBuyEDdR201OhfzTx/4JsdJg
         ffx0UhP7ukT+hOnwuGP6kShpoFRAg/rZhIk3Ib/T8Bl9ui4DFakR6zjeALucme4Obd
         c0ulBby5ujIteCWI4Ukz50SXcPPNqmUjtdpCDvDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Organov <sorganov@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/54] net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration
Date:   Thu, 30 Jul 2020 10:04:58 +0200
Message-Id: <20200730074422.135886848@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
References: <20200730074421.203879987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com>

[ Upstream commit 473309fb8372365ad211f425bca760af800e10a7 ]

>From Documentation/networking/timestamping.txt:

  A driver which supports hardware time stamping shall update the
  struct with the actual, possibly more permissive configuration.

Do update the struct passed when we upscale the requested time
stamping mode.

Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
Signed-off-by: Sergey Organov <sorganov@gmail.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83640.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 847c9fc10f9a9..0da80adc545af 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -1335,6 +1335,7 @@ static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L4;
 		dp83640->version = PTP_CLASS_V1;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
@@ -1342,6 +1343,7 @@ static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L4;
 		dp83640->version = PTP_CLASS_V2;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
@@ -1349,6 +1351,7 @@ static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L2;
 		dp83640->version = PTP_CLASS_V2;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
@@ -1356,6 +1359,7 @@ static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 		dp83640->hwts_rx_en = 1;
 		dp83640->layer = PTP_CLASS_L4 | PTP_CLASS_L2;
 		dp83640->version = PTP_CLASS_V2;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 		break;
 	default:
 		return -ERANGE;
-- 
2.25.1



