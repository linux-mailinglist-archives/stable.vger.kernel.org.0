Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424AC420C71
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhJDNFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235112AbhJDNDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A4D61B03;
        Mon,  4 Oct 2021 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352409;
        bh=KTWfOgBFlkIwENSSXqqs1/+ibOYxMx7CwI3CgEhNjZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JoYP2T3/6ilN7Q0Kv5Rn97uiXeBrYJd82ocZKj8tUtI0VgEaJF4xz1P5M6RzIiZrj
         Fm8yhyKo+08RzyFebDXQUe7SzzsPq6xqWtENBubGNOj1WPC30r4VGPFqQjx09XMseu
         HGVPMn9Q/82h9ChKuHnvGRjlDKfxmf9UBbCK3QSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felicitas Hetzelt <felicitashetzelt@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/75] e100: fix length calculation in e100_get_regs_len
Date:   Mon,  4 Oct 2021 14:52:26 +0200
Message-Id: <20211004125033.234387493@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
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
index a73102357bbd..ae967fa9e502 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2463,7 +2463,11 @@ static void e100_get_drvinfo(struct net_device *netdev,
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



