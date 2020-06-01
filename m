Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E966E1EAED7
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgFAS5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbgFAR7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:59:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B96A206E2;
        Mon,  1 Jun 2020 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034389;
        bh=GMm8AhcPV7EpAvt+2CkU1zcExdXX+lpur4UqttDrAts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8qnURZenDz8TV4AVJ30YAEPzAJ5cLsIRS/X7Ixumrb9qBZr7knD6JCtQmTKtu1bc
         ICaSNgwBwMC/69HmZMlTp89vYwk8m0cKwBSLUEgMraXOfd2IJb+buKwKAbz/AqjQLd
         Lg3lq/YJ8PwigTOCMMyInnV0obW6HwMm/kPNjrMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 10/77] net: sun: fix missing release regions in cas_init_one().
Date:   Mon,  1 Jun 2020 19:53:15 +0200
Message-Id: <20200601174018.286787049@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
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
@@ -4983,7 +4983,7 @@ static int cas_init_one(struct pci_dev *
 					  cas_cacheline_size)) {
 			dev_err(&pdev->dev, "Could not set PCI cache "
 			       "line size\n");
-			goto err_write_cacheline;
+			goto err_out_free_res;
 		}
 	}
 #endif
@@ -5158,7 +5158,6 @@ err_out_iounmap:
 err_out_free_res:
 	pci_release_regions(pdev);
 
-err_write_cacheline:
 	/* Try to restore it in case the error occurred after we
 	 * set it.
 	 */


