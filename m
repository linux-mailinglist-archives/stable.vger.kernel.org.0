Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B742ABC09
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgKINd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:33:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731113AbgKINGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:06:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C03E520789;
        Mon,  9 Nov 2020 13:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927201;
        bh=a4fewJNY0TNNf/IBkSpKcRWKjiib/2IG8c/d6vocP8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4tOIWWl1Swwko14kLBCr2limz4szF7lK+lKO7PIM9hqlDLvUdeFiOdLFz6G/jR2a
         ByaL+n5VMraxCo2ZwUF+C+Xl32HmyTYPvz2s7TpjRv3RHjcVITaZYTIaNsQwba76RR
         P6ArZLS5pXG2IX5vCso4Csilj8iJSDW223jn1S8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 08/48] sfp: Fix error handing in sfp_probe()
Date:   Mon,  9 Nov 2020 13:55:17 +0100
Message-Id: <20201109125017.154511467@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 9621618130bf7e83635367c13b9a6ee53935bb37 ]

gpiod_to_irq() never return 0, but returns negative in
case of error, check it and set gpio_irq to 0.

Fixes: 73970055450e ("sfp: add SFP module support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20201031031053.25264-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -881,7 +881,8 @@ static int sfp_probe(struct platform_dev
 			continue;
 
 		irq = gpiod_to_irq(sfp->gpio[i]);
-		if (!irq) {
+		if (irq < 0) {
+			irq = 0;
 			poll = true;
 			continue;
 		}


