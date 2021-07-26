Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF463D5F42
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhGZPRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237450AbhGZPPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8409610CB;
        Mon, 26 Jul 2021 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314967;
        bh=KQBIvWw5YEEKzswPulW/87FGiBPzOznHMPU68F6m9Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woXBJvyMfpsnSG/jixYVdNUIqX5Lz710/elJoHUh3/C2o9kNJNwmUWzo9Et+3RdL4
         VrQphIGmqIcbWyWM6IE3Xk91P78Ps/IxePcf8LbL5i9LzG2CO6otHlBQuL20Qtx+e0
         MfjEpPY3HsbyHGUov7pxEnxPzqu0rnxrGD8or7rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/108] liquidio: Fix unintentional sign extension issue on left shift of u16
Date:   Mon, 26 Jul 2021 17:38:38 +0200
Message-Id: <20210726153832.884665464@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index 4cddd628d41b..9ed3d1ab2ca5 100644
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



