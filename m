Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5242ABB03
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbgKINSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387649AbgKINS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BAD3206D8;
        Mon,  9 Nov 2020 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927909;
        bh=OU2REBTymBiaQUJHxq52DegKgS6ELtvhPUV+ia+tcxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/1H1oftlc0I5BNB/hEXqEbxEw3J2mjPxVqyD0cANNM5QCm1wJl5qgaB+xViL2JRn
         Tu4a325E32689KRheBe7xO1bTM44XhJCX6YBv0fbFCv/Mrf2/qkVjeq2n2C12GjUge
         +qpN+YfoSN8bYaUYg+s5fj/TqT9ellyLQnjJPLR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 032/133] net: ethernet: ti: cpsw: disable PTPv1 hw timestamping advertisement
Date:   Mon,  9 Nov 2020 13:54:54 +0100
Message-Id: <20201109125032.257676957@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 0a26ba0603d637eb6673a2ea79808cc73909ef3a ]

The TI CPTS does not natively support PTPv1, only PTPv2. But, as it
happens, the CPTS can provide HW timestamp for PTPv1 Sync messages, because
CPTS HW parser looks for PTP messageType id in PTP message octet 0 which
value is 0 for PTPv1. As result, CPTS HW can detect Sync messages for PTPv1
and PTPv2 (Sync messageType = 0 for both), but it fails for any other PTPv1
messages (Delay_req/resp) and will return PTP messageType id 0 for them.

The commit e9523a5a32a1 ("net: ethernet: ti: cpsw: enable
HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter") added PTPv1 hw timestamping
advertisement by mistake, only to make Linux Kernel "timestamping" utility
work, and this causes issues with only PTPv1 compatible HW/SW - Sync HW
timestamped, but Delay_req/resp are not.

Hence, fix it disabling PTPv1 hw timestamping advertisement, so only PTPv1
compatible HW/SW can properly roll back to SW timestamping.

Fixes: e9523a5a32a1 ("net: ethernet: ti: cpsw: enable HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20201029190910.30789-1-grygorii.strashko@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_ethtool.c |    1 -
 drivers/net/ethernet/ti/cpsw_priv.c    |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -727,7 +727,6 @@ int cpsw_get_ts_info(struct net_device *
 		(1 << HWTSTAMP_TX_ON);
 	info->rx_filters =
 		(1 << HWTSTAMP_FILTER_NONE) |
-		(1 << HWTSTAMP_FILTER_PTP_V1_L4_EVENT) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
 	return 0;
 }
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -639,13 +639,10 @@ static int cpsw_hwtstamp_set(struct net_
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_NTP_ALL:
-		return -ERANGE;
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
-		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		break;
+		return -ERANGE;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:


