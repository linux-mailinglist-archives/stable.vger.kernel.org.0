Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4823CDF38
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344433AbhGSPI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:08:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245008AbhGSPGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA528613ED;
        Mon, 19 Jul 2021 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709600;
        bh=sT+e0hNKLkCsOWrTnDNuAgfnRZqKvy8MxoEqU5PIEtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zarPC2HeZH85Rn9emzfQ8a6O7d9roxXoq/HquY8KGnk+um7Rpts0m4WH3Al7unAlh
         NQHK/iMWjPJzwuLo6HLFjXSZOoeDKf7GC5SQx4rRFuqvmFnTnyR2ETKNwL44HjUf/C
         knEDAbG7bt0A/BK4w7ontYxJvImKc/V2vmDxvb8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 008/149] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Mon, 19 Jul 2021 16:51:56 +0200
Message-Id: <20210719144903.413602646@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 upstream.

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

[yyl: since devm_platform_get_and_ioremap_resource() is introduced
      in linux-5.7, so just check the return value after calling
      platform_get_resource()]

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -481,6 +481,10 @@ static int moxart_mac_probe(struct platf
 	priv->pdev = pdev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -EINVAL;
+		goto init_fail;
+	}
 	ndev->base_addr = res->start;
 	priv->base = devm_ioremap_resource(p_dev, res);
 	if (IS_ERR(priv->base)) {


