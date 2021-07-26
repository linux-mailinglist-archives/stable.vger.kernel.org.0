Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237BD3D5F7D
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbhGZPSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236719AbhGZPPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1907460FEA;
        Mon, 26 Jul 2021 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314831;
        bh=e5MnrLQcPlS8Dt2d1w2cYDGLFhlYG1t7XWPSZaQpFvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCvzxoUJkMUI4/4gZTx9u0YDO1wp80cSQFaTVoKtEljAQgw0aaK7s65TMHMYQAY+k
         Ih8Y9Uo9vThMBarUBTpBlQ7Gl+FRvyQI24iRNo9bRE1eeR15MQNSZctM5p7KVcDPEB
         c2hmtDv0jfsxBNX+kRewGdZL48GkL04ebOxotny0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/120] liquidio: Fix unintentional sign extension issue on left shift of u16
Date:   Mon, 26 Jul 2021 17:38:44 +0200
Message-Id: <20210726153834.698431329@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e7efc2ce3d0789cd7c21b70ff00cd7838d382639 ]

Shifting the u16 integer oct->pcie_port by CN23XX_PKT_INPUT_CTL_MAC_NUM_POS
(29) bits will be promoted to a 32 bit signed int and then sign-extended
to a u64. In the cases where oct->pcie_port where bit 2 is set (e.g. 3..7)
the shifted value will be sign extended and the top 32 bits of the result
will be set.

Fix this by casting the u16 values to a u64 before the 29 bit left shift.

Addresses-Coverity: ("Unintended sign extension")

Fixes: 3451b97cce2d ("liquidio: CN23XX register setup")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
index 55fe80ca10d3..9e447983d0aa 100644
--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -420,7 +420,7 @@ static int cn23xx_pf_setup_global_input_regs(struct octeon_device *oct)
 	 * bits 32:47 indicate the PVF num.
 	 */
 	for (q_no = 0; q_no < ern; q_no++) {
-		reg_val = oct->pcie_port << CN23XX_PKT_INPUT_CTL_MAC_NUM_POS;
+		reg_val = (u64)oct->pcie_port << CN23XX_PKT_INPUT_CTL_MAC_NUM_POS;
 
 		/* for VF assigned queues. */
 		if (q_no < oct->sriov_info.pf_srn) {
-- 
2.30.2



