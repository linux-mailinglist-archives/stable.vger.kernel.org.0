Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0C1EAA57
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgFASHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730533AbgFASHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:07:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01BF2206E2;
        Mon,  1 Jun 2020 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034822;
        bh=d6n1lfALiOuqf6hD6qY0ykkceo3UeXoajd4//MCBJ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4dSwDDgwL3l2nt78msaX17Zo3T7ntT120EgkYm7kZaGSc5E/xCiv6+ZMaofFK2EE
         vy0EopfXNqHaHrKOcgOY/WWDSnjtOKwYQpT1772ETaJXAP6y/styr3iDUIKx6oCQrE
         TA8e3q0zGr889vwR+ntfPgP0iWIdajrx2TCx7G5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 029/142] net: sun: fix missing release regions in cas_init_one().
Date:   Mon,  1 Jun 2020 19:53:07 +0200
Message-Id: <20200601174040.917626256@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit 5a730153984dd13f82ffae93d7170d76eba204e9 upstream.

In cas_init_one(), "pdev" is requested by "pci_request_regions", but it
was not released after a call of the function “pci_write_config_byte”
failed. Thus replace the jump target “err_write_cacheline” by
"err_out_free_res".

Fixes: 1f26dac32057 ("[NET]: Add Sun Cassini driver.")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/sun/cassini.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4971,7 +4971,7 @@ static int cas_init_one(struct pci_dev *
 					  cas_cacheline_size)) {
 			dev_err(&pdev->dev, "Could not set PCI cache "
 			       "line size\n");
-			goto err_write_cacheline;
+			goto err_out_free_res;
 		}
 	}
 #endif
@@ -5144,7 +5144,6 @@ err_out_iounmap:
 err_out_free_res:
 	pci_release_regions(pdev);
 
-err_write_cacheline:
 	/* Try to restore it in case the error occurred after we
 	 * set it.
 	 */


