Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E673A01
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390579AbfGXTqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390672AbfGXTqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:46:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE5C2083B;
        Wed, 24 Jul 2019 19:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997564;
        bh=MK2R2rPOeCr9nONFoatxszOMXFDiMjCww6jnLMbXkVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOK/IQID4Hiw1QEPuZm1dJaCe6QGI2ufH9mER+xXLFp1+E55tMXA4CC//GzxdZg8H
         8TNbKz0mHPm0DXXhcQ3stJ1NaC4/yj1vBYdkQNam8aLX/zmye0ehscwIV1AxfymqaF
         gt2sNEfzGo1V6t560+YsS5e+MqvLUBsc+WoCse8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biao Huang <biao.huang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 065/371] net: stmmac: modify default value of tx-frames
Date:   Wed, 24 Jul 2019 21:16:57 +0200
Message-Id: <20190724191729.787667008@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d2facb4b3983425f6776c24dd678a82dbe673773 ]

the default value of tx-frames is 25, it's too late when
passing tstamp to stack, then the ptp4l will fail:

ptp4l -i eth0 -f gPTP.cfg -m
ptp4l: selected /dev/ptp0 as PTP clock
ptp4l: port 1: INITIALIZING to LISTENING on INITIALIZE
ptp4l: port 0: INITIALIZING to LISTENING on INITIALIZE
ptp4l: port 1: link up
ptp4l: timed out while polling for tx timestamp
ptp4l: increasing tx_timestamp_timeout may correct this issue,
       but it is likely caused by a driver bug
ptp4l: port 1: send peer delay response failed
ptp4l: port 1: LISTENING to FAULTY on FAULT_DETECTED (FT_UNSPECIFIED)

ptp4l tests pass when changing the tx-frames from 25 to 1 with
ethtool -C option.
It should be fine to set tx-frames default value to 1, so ptp4l will pass
by default.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 272b9ca66314..b069b3a2453b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -261,7 +261,7 @@ struct stmmac_safety_stats {
 #define STMMAC_COAL_TX_TIMER	1000
 #define STMMAC_MAX_COAL_TX_TICK	100000
 #define STMMAC_TX_MAX_FRAMES	256
-#define STMMAC_TX_FRAMES	25
+#define STMMAC_TX_FRAMES	1
 
 /* Packets types */
 enum packets_types {
-- 
2.20.1



