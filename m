Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4AE1F118
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730795AbfEOLUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbfEOLUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:20:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40748206BF;
        Wed, 15 May 2019 11:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919248;
        bh=c73fBmBoUFbpJi5x/+IpwqKCWz6Hyese2gMWQna4xCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvYQdqSTDt2W0cxU1rhKHzHbYs2JIawSr5DdAo3puR0LjOsTJOjmOcCUMG3LQNdCL
         9VgHGtTfdZHo3+UXWLJOp9rzuvlEG/KYp2bZxolJ3Vw62mW681hlryiroIKzLcUKvz
         MnQ93CJ60xHb4jgrc6JlTbV9RCvXKsqTAB3iYQd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 106/115] net: seeq: fix crash caused by not set dev.parent
Date:   Wed, 15 May 2019 12:56:26 +0200
Message-Id: <20190515090706.834096793@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 5afcd14cfc7fed1bcc8abcee2cef82732772bfc2 ]

The old MIPS implementation of dma_cache_sync() didn't use the dev argument,
but commit c9eb6172c328 ("dma-mapping: turn dma_cache_sync into a
dma_map_ops method") changed that, so we now need to set dev.parent.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/seeq/sgiseeq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -734,6 +734,7 @@ static int sgiseeq_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */


