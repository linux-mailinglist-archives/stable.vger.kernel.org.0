Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2CE3AEEB1
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhFUQbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232481AbhFUQ3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E64361400;
        Mon, 21 Jun 2021 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292660;
        bh=vQa3WRUXBaoO0MDN369yEG3QL7O0qB3xPdu6boF6Vnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvss4HQAo/EBgc7CnPQCX8qZ4GUzFlparNFhjRkkZpNG8X80uVsQCLpLfANC+wrFX
         7oALTtzPGKkb/DoZv7ah7keD/UNHNxgHNxCTjjrMuAPjwOYMPaoV7EXYW/7etcmeV5
         CYs/W2dfsrMzlTXwDwI948dmM6tS/77eZkOJ3cdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/146] netxen_nic: Fix an error handling path in netxen_nic_probe()
Date:   Mon, 21 Jun 2021 18:14:40 +0200
Message-Id: <20210621154913.110589792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 49a10c7b176295f8fafb338911cf028e97f65f4d ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: e87ad5539343 ("netxen: support pci error handlers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index d258e0ccf946..e2046b6d65a3 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1602,6 +1602,8 @@ err_out_free_netdev:
 	free_netdev(netdev);
 
 err_out_free_res:
+	if (NX_IS_REVISION_P3(pdev->revision))
+		pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2



