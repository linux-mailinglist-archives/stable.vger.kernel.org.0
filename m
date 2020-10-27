Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617AA29C359
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902130AbgJ0Oak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759353AbgJ0O33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4DB320754;
        Tue, 27 Oct 2020 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808969;
        bh=nFu3G1aXMLT+TVBWsmBJJOO4RMTQ6HbsJYqt7qryeMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8KxFmghfj3dHt3qei602t++FywgIpM6Lxv0qftMR+8oP5jrNrVbKRgoipzvMvgTQ
         1TK4hDA3/7IWM4vnZNtAmgjwi8UV/YQTYTlhUdnzI2eakSsAKbpx5P2+59y805n9IU
         EWkL7XgyKnMVFergtPpwgKSdaWnlqGTQ6hCMsxEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 028/408] ibmvnic: save changed mac address to adapter->mac_addr
Date:   Tue, 27 Oct 2020 14:49:26 +0100
Message-Id: <20201027135456.367152981@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit d9b0e599b2b892422f1cbc5d2658049b895b2b58 ]

After mac address change request completes successfully, the new mac
address need to be saved to adapter->mac_addr as well as
netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
data.

Fixes: 62740e97881c ("net/ibmvnic: Update MAC address settings after adapter reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/20201020223919.46106-1-ljp@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4074,8 +4074,13 @@ static int handle_change_mac_rsp(union i
 		dev_err(dev, "Error %ld in CHANGE_MAC_ADDR_RSP\n", rc);
 		goto out;
 	}
+	/* crq->change_mac_addr.mac_addr is the requested one
+	 * crq->change_mac_addr_rsp.mac_addr is the returned valid one.
+	 */
 	ether_addr_copy(netdev->dev_addr,
 			&crq->change_mac_addr_rsp.mac_addr[0]);
+	ether_addr_copy(adapter->mac_addr,
+			&crq->change_mac_addr_rsp.mac_addr[0]);
 out:
 	complete(&adapter->fw_done);
 	return rc;


