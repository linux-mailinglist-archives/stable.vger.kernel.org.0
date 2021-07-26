Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473893D5E67
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbhGZPHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236325AbhGZPG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEE2F60F59;
        Mon, 26 Jul 2021 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314445;
        bh=wPLt4gxhICw/KEnuyRMLGO7LpLZt+kTfhVZnYMBVttA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew6kufuhmIenhOUyHjdf49W+aNSHgCqgITTqMTsT3Z1YqppWIgRxUrkBSCWLI6fPy
         IyhbuzInz7P7cN0Plopzx3dRk5qD1SSdKn9Bt5XIrO6Nsn2JPmiG9zHY5vpUa4j5Zu
         DlcVsibyffRfYLjaMSYFR0IUsvFrBsLSEKSTnNrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 49/82] liquidio: Fix unintentional sign extension issue on left shift of u16
Date:   Mon, 26 Jul 2021 17:38:49 +0200
Message-Id: <20210726153829.773878286@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 30f0e54f658e..4248ba307b66 100644
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



