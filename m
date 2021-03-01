Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5126B328D0C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbhCATEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233771AbhCAS6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:58:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00FA6652BB;
        Mon,  1 Mar 2021 17:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620216;
        bh=zx9VS/lv2RMPavg7RhWlwFPUVhkKTlRXBgr+/0LOknQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FzK0Y+P1NsWyOUJei2HhVgyeaglYdW9tKAnGapDQI5ptIn1XWJKnX1AJvmEmKmgj
         hSxatAs24fzIExx6l+dkk7v6CLD0XrMwamz8xZmvvXjYJgTIUFQqM/JCc5lAmG8+lk
         1R8O2yxMZ1tLmflGI7a4gNjiLsxLEzb32tA8A/Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 042/775] net: stmmac: dwmac-meson8b: fix enabling the timing-adjustment clock
Date:   Mon,  1 Mar 2021 17:03:30 +0100
Message-Id: <20210301161203.801416791@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 025822884a4fd2d0af51dcf77ddc494e60c5ff63 ]

The timing-adjustment clock only has to be enabled when a) there is a
2ns RX delay configured using device-tree and b) the phy-mode indicates
that the RX delay should be enabled.

Only enable the RX delay if both are true, instead of (by accident) also
enabling it when there's the 2ns RX delay configured but the phy-mode
incicates that the RX delay is not used.

Fixes: 9308c47640d515 ("net: stmmac: dwmac-meson8b: add support for the RX delay configuration")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index f184b00f51166..5f500141567d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -301,7 +301,7 @@ static int meson8b_init_prg_eth(struct meson8b_dwmac *dwmac)
 		return -EINVAL;
 	}
 
-	if (rx_dly_config & PRG_ETH0_ADJ_ENABLE) {
+	if (delay_config & PRG_ETH0_ADJ_ENABLE) {
 		if (!dwmac->timing_adj_clk) {
 			dev_err(dwmac->dev,
 				"The timing-adjustment clock is mandatory for the RX delay re-timing\n");
-- 
2.27.0



