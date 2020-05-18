Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5FB1D8135
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgERRpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbgERRpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:45:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E5520674;
        Mon, 18 May 2020 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823952;
        bh=hBjtYZJ5CvsH4u+wYPEqeBG0fOmlntBuMqfYioHyMZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dkEAskBWhbLOtMhAvchTayb/G26drV6wrobnmr77JYsOpbSqEG6gyLDqei0nrfl8C
         erNM0AKXqCZU05U0M6iR7cI99Nv4PrpISBroo71RXFHqmKjsHVjmV5OPhcHjdkUg7k
         BD2MIe0l5suo5mwWkfnlpzEzJmMWBkPAX696Q4kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 012/114] bnxt_en: Improve AER slot reset.
Date:   Mon, 18 May 2020 19:35:44 +0200
Message-Id: <20200518173505.705981494@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
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
@@ -8423,8 +8423,11 @@ static pci_ers_result_t bnxt_io_slot_res
 		}
 	}
 
-	if (result != PCI_ERS_RESULT_RECOVERED && netif_running(netdev))
-		dev_close(netdev);
+	if (result != PCI_ERS_RESULT_RECOVERED) {
+		if (netif_running(netdev))
+			dev_close(netdev);
+		pci_disable_device(pdev);
+	}
 
 	rtnl_unlock();
 
@@ -8435,7 +8438,7 @@ static pci_ers_result_t bnxt_io_slot_res
 			 err); /* non-fatal, continue */
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	return result;
 }
 
 /**


