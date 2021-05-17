Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B2B38329C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbhEQOuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240997AbhEQOrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3191C6145A;
        Mon, 17 May 2021 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261318;
        bh=RCxLgN7/gkXsKhym5ThqqgbVTx9xWZPHnifZLnamMSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjlxyKYJHCOuFiJ3FF4D9q5K0b7a2NfMc5v+Gp5VlJpBylp3lAYKp7aSnNpLgSrLu
         7pBo/wYQ4BpLLxZgUFWTlkS4B2Ij7XerjMC+/iLwW/IlUubwW8p2+TanzSkrxNturL
         6jQpQr1G+rka2tFNW1aOUj49az9gmzCpfJQUZBeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 101/329] iavf: remove duplicate free resources calls
Date:   Mon, 17 May 2021 16:00:12 +0200
Message-Id: <20210517140305.542678764@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 1a0e880b028f97478dc689e2900b312741d0d772 ]

Both iavf_free_all_tx_resources() and iavf_free_all_rx_resources() have
already been called in the very same function.
Remove the duplicate calls.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index dc5b3c06d1e0..ebd08543791b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3899,8 +3899,6 @@ static void iavf_remove(struct pci_dev *pdev)
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-	iavf_free_all_tx_resources(adapter);
-	iavf_free_all_rx_resources(adapter);
 	iavf_free_queues(adapter);
 	kfree(adapter->vf_res);
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
-- 
2.30.2



