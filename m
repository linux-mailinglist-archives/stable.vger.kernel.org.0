Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D6A43A149
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhJYTiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236709AbhJYTfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF4A60C4B;
        Mon, 25 Oct 2021 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190342;
        bh=cc1GL83gT3Dxfcuqd6jBoPymTs4TLnGIBDuRj5MXjxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtqtMYOqp/BQaFpz4Z0YPiblcBafbYyuoTeEgnOExHgB6CjXrPTN3RFjWZVWb5W5F
         OWoqBjyc0ZTKGva16sAFIF8OXVGEdaFhx61+75x5vOvfpd8cldnR0LlB03bc/Z62qJ
         vklfvodhNO7w4uIj0mtJNdu4gl+Bd25W3mPKPE2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        ClaudiuManoilclaudiu.manoil@nxp.com
Subject: [PATCH 5.10 33/95] net: enetc: fix ethtool counter name for PM0_TERR
Date:   Mon, 25 Oct 2021 21:14:30 +0200
Message-Id: <20211025191001.676347785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit fb8dc5fc8cbdfd62ecd16493848aee2f42ed84d9 ]

There are two counters named "MAC tx frames", one of them is actually
incorrect. The correct name for that counter should be "MAC tx error
frames", which is symmetric to the existing "MAC rx error frames".

Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: <Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20211020165206.1069889-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 89e558135432..9c1690f64a02 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -157,7 +157,7 @@ static const struct {
 	{ ENETC_PM0_TFRM,   "MAC tx frames" },
 	{ ENETC_PM0_TFCS,   "MAC tx fcs errors" },
 	{ ENETC_PM0_TVLAN,  "MAC tx VLAN frames" },
-	{ ENETC_PM0_TERR,   "MAC tx frames" },
+	{ ENETC_PM0_TERR,   "MAC tx frame errors" },
 	{ ENETC_PM0_TUCA,   "MAC tx unicast frames" },
 	{ ENETC_PM0_TMCA,   "MAC tx multicast frames" },
 	{ ENETC_PM0_TBCA,   "MAC tx broadcast frames" },
-- 
2.33.0



