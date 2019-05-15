Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0F51EF56
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733076AbfEOLco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733073AbfEOLcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:32:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB712053B;
        Wed, 15 May 2019 11:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919963;
        bh=A5n4mTZtTb5EEfrTR3AlfarJ5yVRdt4gFPUi2LZqFk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVhqW6mPWJz2lxcvrLyX2jXHM+b9nngX9ReAYeeLmM0elQbfk8kAxE/tJ+E0+mQLY
         1ixEe8PX0h7iEafkY/ei1kmBypTIv5t80xB3FsD8KFeiu2nxBaZfYgjWTOrDUd526m
         iHHbIo41XKXdB6X0BCM+1NSzYBYXClJQKwZY/khE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 22/46] net: seeq: fix crash caused by not set dev.parent
Date:   Wed, 15 May 2019 12:56:46 +0200
Message-Id: <20190515090624.564026538@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
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
@@ -735,6 +735,7 @@ static int sgiseeq_probe(struct platform
 	}
 
 	platform_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */


