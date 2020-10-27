Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7105B29B36E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766565AbgJ0OtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766561AbgJ0OtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13069206E5;
        Tue, 27 Oct 2020 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810153;
        bh=DLx0wn6O1IvYMMtGamhATuorYPUG4JQWxkpIRTM9jGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGvJbCSk1zPfISQG3hiOzaRASklCXu/W+XZc32hQ4w972UDUQbppcVIsTiEZNPbw3
         6YwkQk5dQuGlM8ZfYLHRuf72/ouYYFsBUeTqXR8RrtM9xrSPnxzLCLMnlxgC+0VAlN
         /aLDuHkl2xblQmnsL2q3WTZJpzCRCNiLabf3JNLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 038/633] ibmvnic: save changed mac address to adapter->mac_addr
Date:   Tue, 27 Oct 2020 14:46:21 +0100
Message-Id: <20201027135524.478646220@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
@@ -4194,8 +4194,13 @@ static int handle_change_mac_rsp(union i
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


