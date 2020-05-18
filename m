Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73E11D80CD
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgERRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbgERRmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:42:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F1F8207C4;
        Mon, 18 May 2020 17:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823726;
        bh=Rb7UxkR8SUT5Bw8UAQG6g2rq3U0rT6XFV6zgMx0mh2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCiyrKRKz+NazSHenuN755lfMi2REW1ZV3UobIqw8BqaeGo37xlIBfLWJSBulyys4
         M2fsGxuwy+AgoxzuVeFwZLciuRdlXxX8JFMU2rFsQpPWsw9GO3bJq23Yx9ycHiA6QY
         b/7ucnELhaz31rcbWn2Ag8jm2HzLsAAVbw2o73/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 12/90] bnxt_en: Improve AER slot reset.
Date:   Mon, 18 May 2020 19:35:50 +0200
Message-Id: <20200518173453.713553654@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit bae361c54fb6ac6eba3b4762f49ce14beb73ef13 ]

Improve the slot reset sequence by disabling the device to prevent bad
DMAs if slot reset fails.  Return the proper result instead of always
PCI_ERS_RESULT_RECOVERED to the caller.

Fixes: 6316ea6db93d ("bnxt_en: Enable AER support.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7166,8 +7166,11 @@ static pci_ers_result_t bnxt_io_slot_res
 			result = PCI_ERS_RESULT_RECOVERED;
 	}
 
-	if (result != PCI_ERS_RESULT_RECOVERED && netif_running(netdev))
-		dev_close(netdev);
+	if (result != PCI_ERS_RESULT_RECOVERED) {
+		if (netif_running(netdev))
+			dev_close(netdev);
+		pci_disable_device(pdev);
+	}
 
 	rtnl_unlock();
 
@@ -7178,7 +7181,7 @@ static pci_ers_result_t bnxt_io_slot_res
 			 err); /* non-fatal, continue */
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	return result;
 }
 
 /**


