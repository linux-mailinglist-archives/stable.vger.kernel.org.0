Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF23420BDE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhJDNAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233943AbhJDM7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B06B615A4;
        Mon,  4 Oct 2021 12:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352236;
        bh=L241wpkUh0bWgSPDGbsmy1HluiZHT2lvYcQZyy8xsko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDzY9vLWfu08nJF3bA6cCzN5xRgohG7RxDIDy5mto8T3HkuXZPCVb+BSyHQo4evYl
         gYQ1e+runFTLI/ANdyn73+bmZYWNbEIigjTaP9CRR+mxbX42eEkaAvC1DXvNIUllZN
         RjzmJFyDb7SnCaFoGC3jzIQ37kySzL0zAVdE2TDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felicitas Hetzelt <felicitashetzelt@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/57] e100: fix buffer overrun in e100_get_regs
Date:   Mon,  4 Oct 2021 14:52:24 +0200
Message-Id: <20211004125030.212671311@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 51032e6f17ce990d06123ad7307f258c50d25aa7 ]

The e100_get_regs function is used to implement a simple register dump
for the e100 device. The data is broken into a couple of MAC control
registers, and then a series of PHY registers, followed by a memory dump
buffer.

The total length of the register dump is defined as (1 + E100_PHY_REGS)
* sizeof(u32) + sizeof(nic->mem->dump_buf).

The logic for filling in the PHY registers uses a convoluted inverted
count for loop which counts from E100_PHY_REGS (0x1C) down to 0, and
assigns the slots 1 + E100_PHY_REGS - i. The first loop iteration will
fill in [1] and the final loop iteration will fill in [1 + 0x1C]. This
is actually one more than the supposed number of PHY registers.

The memory dump buffer is then filled into the space at
[2 + E100_PHY_REGS] which will cause that memcpy to assign 4 bytes past
the total size.

The end result is that we overrun the total buffer size allocated by the
kernel, which could lead to a panic or other issues due to memory
corruption.

It is difficult to determine the actual total number of registers
here. The only 8255x datasheet I could find indicates there are 28 total
MDI registers. However, we're reading 29 here, and reading them in
reverse!

In addition, the ethtool e100 register dump interface appears to read
the first PHY register to determine if the device is in MDI or MDIx
mode. This doesn't appear to be documented anywhere within the 8255x
datasheet. I can only assume it must be in register 28 (the extra
register we're reading here).

Lets not change any of the intended meaning of what we copy here. Just
extend the space by 4 bytes to account for the extra register and
continue copying the data out in the same order.

Change the E100_PHY_REGS value to be the correct total (29) so that the
total register dump size is calculated properly. Fix the offset for
where we copy the dump buffer so that it doesn't overrun the total size.

Re-write the for loop to use counting up instead of the convoluted
down-counting. Correct the mdio_read offset to use the 0-based register
offsets, but maintain the bizarre reverse ordering so that we have the
ABI expected by applications like ethtool. This requires and additional
subtraction of 1. It seems a bit odd but it makes the flow of assignment
into the register buffer easier to follow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Felicitas Hetzelt <felicitashetzelt@gmail.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index abb65ed9492b..aa556e4f9051 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2462,7 +2462,7 @@ static void e100_get_drvinfo(struct net_device *netdev,
 		sizeof(info->bus_info));
 }
 
-#define E100_PHY_REGS 0x1C
+#define E100_PHY_REGS 0x1D
 static int e100_get_regs_len(struct net_device *netdev)
 {
 	struct nic *nic = netdev_priv(netdev);
@@ -2484,14 +2484,18 @@ static void e100_get_regs(struct net_device *netdev,
 	buff[0] = ioread8(&nic->csr->scb.cmd_hi) << 24 |
 		ioread8(&nic->csr->scb.cmd_lo) << 16 |
 		ioread16(&nic->csr->scb.status);
-	for (i = E100_PHY_REGS; i >= 0; i--)
-		buff[1 + E100_PHY_REGS - i] =
-			mdio_read(netdev, nic->mii.phy_id, i);
+	for (i = 0; i < E100_PHY_REGS; i++)
+		/* Note that we read the registers in reverse order. This
+		 * ordering is the ABI apparently used by ethtool and other
+		 * applications.
+		 */
+		buff[1 + i] = mdio_read(netdev, nic->mii.phy_id,
+					E100_PHY_REGS - 1 - i);
 	memset(nic->mem->dump_buf, 0, sizeof(nic->mem->dump_buf));
 	e100_exec_cb(nic, NULL, e100_dump);
 	msleep(10);
-	memcpy(&buff[2 + E100_PHY_REGS], nic->mem->dump_buf,
-		sizeof(nic->mem->dump_buf));
+	memcpy(&buff[1 + E100_PHY_REGS], nic->mem->dump_buf,
+	       sizeof(nic->mem->dump_buf));
 }
 
 static void e100_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
-- 
2.33.0



