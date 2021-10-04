Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68E9420DF1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbhJDNUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236572AbhJDNSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF0161B46;
        Mon,  4 Oct 2021 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352866;
        bh=t/9gFuZK62+2+aeVhuMTdacunlbUyE/NL9u+sDaxjbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svDWHmxOhGLG3KmM6WEtsxm1e9K3UG+9bUVVpGHJ8VwtBlbgAhDNhwR/n/7WjX2bP
         D1GKhqg7BNvgsoS/bouq99+imrUTHl+hbucnpST9er8JuQuUUKMfsdoKjnCxi3BRYM
         1FUxsX51AOys9j4zPCQzjS6YUS2JKmOH8KuGpatw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felicitas Hetzelt <felicitashetzelt@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/56] e100: fix length calculation in e100_get_regs_len
Date:   Mon,  4 Oct 2021 14:52:43 +0200
Message-Id: <20211004125030.728177186@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 4329c8dc110b25d5f04ed20c6821bb60deff279f ]

commit abf9b902059f ("e100: cleanup unneeded math") tried to simplify
e100_get_regs_len and remove a double 'divide and then multiply'
calculation that the e100_reg_regs_len function did.

This change broke the size calculation entirely as it failed to account
for the fact that the numbered registers are actually 4 bytes wide and
not 1 byte. This resulted in a significant under allocation of the
register buffer used by e100_get_regs.

Fix this by properly multiplying the register count by u32 first before
adding the size of the dump buffer.

Fixes: abf9b902059f ("e100: cleanup unneeded math")
Reported-by: Felicitas Hetzelt <felicitashetzelt@gmail.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 911b3d2a94e1..ea0f97d76964 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2439,7 +2439,11 @@ static void e100_get_drvinfo(struct net_device *netdev,
 static int e100_get_regs_len(struct net_device *netdev)
 {
 	struct nic *nic = netdev_priv(netdev);
-	return 1 + E100_PHY_REGS + sizeof(nic->mem->dump_buf);
+
+	/* We know the number of registers, and the size of the dump buffer.
+	 * Calculate the total size in bytes.
+	 */
+	return (1 + E100_PHY_REGS) * sizeof(u32) + sizeof(nic->mem->dump_buf);
 }
 
 static void e100_get_regs(struct net_device *netdev,
-- 
2.33.0



