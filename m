Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3651CAF1B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgEHNOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbgEHMqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EEA2495E;
        Fri,  8 May 2020 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942013;
        bh=si+R2ZWl7SvDMQd5E/QfliAZaePZH2mtXt7CY4pbOzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3Pr6US3vsKDocKtfrUhPRVo9VtgIo7QSEIIhBM7PVKGkGVC57G42oQRJHDD1hhg8
         bTAY5hko4+DVgou/XJt3aKhGupgI58nMGX0N36JjbO2nn8KFtvJ/Z/GrqnjmdGgwtb
         iPJC5WW98VVmDdwd0st3i/61P/53TnJl6P27l79A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyj.lk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 261/312] net: macb: add missing free_netdev() on error in macb_probe()
Date:   Fri,  8 May 2020 14:34:12 +0200
Message-Id: <20200508123142.781496849@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyj.lk@gmail.com>

commit b22ae0b4d9669495158a7fa0fd027bd0fcd8896e upstream.

Add the missing free_netdev() before return from function macb_probe()
in the platform_get_irq() error handling case.

Fixes: c69618b3e4f2 ("net/macb: fix probe sequence to setup clocks earlier")
Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/cadence/macb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2904,7 +2904,7 @@ static int macb_probe(struct platform_de
 	dev->irq = platform_get_irq(pdev, 0);
 	if (dev->irq < 0) {
 		err = dev->irq;
-		goto err_disable_clocks;
+		goto err_out_free_netdev;
 	}
 
 	mac = of_get_mac_address(np);


