Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40681D0D70
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733020AbgEMJxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387889AbgEMJxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F2020575;
        Wed, 13 May 2020 09:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363582;
        bh=ZW/YsyCLq2WywkRXD65KdBn4deEsO02bkk6I1bnGvWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0YNA9kZZVpSqwPmpWkxy4glXa9rMFoqDp8r6ndBJpHWGX2wlakAiF61xTbCVNxQx
         hNVcOZ6IH1Dbmg4yv6f0iTB0cw58SoEYDgFcPLwciO3NRjUt4x1a9qLeqacyhN4WtJ
         gQSl6Zb7XLqDXe/phWROpKeI9K5fKNyuW3ltQt3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 043/118] bnxt_en: Improve AER slot reset.
Date:   Wed, 13 May 2020 11:44:22 +0200
Message-Id: <20200513094421.080353924@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
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
@@ -12173,12 +12173,15 @@ static pci_ers_result_t bnxt_io_slot_res
 		bnxt_ulp_start(bp, err);
 	}
 
-	if (result != PCI_ERS_RESULT_RECOVERED && netif_running(netdev))
-		dev_close(netdev);
+	if (result != PCI_ERS_RESULT_RECOVERED) {
+		if (netif_running(netdev))
+			dev_close(netdev);
+		pci_disable_device(pdev);
+	}
 
 	rtnl_unlock();
 
-	return PCI_ERS_RESULT_RECOVERED;
+	return result;
 }
 
 /**


