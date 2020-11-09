Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1042ABB25
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbgKINYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731863AbgKINSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:18:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC042076E;
        Mon,  9 Nov 2020 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927920;
        bh=khB+fXKKincLA3kRo0EB7b7vJ0Ib+IRQFqAu/sTvaOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2+nnS5QlPd5cV7uQPWC5ThWLYc2N/hYGGRgsYXHW5x7ivw15MyxA9eDHof+xN21l
         dmQ78OVc47WEd7kUNU10ayXeKSSoaCNCpc2ojxeUpggHV5UbaD5NwsoG9rUD8FzM4q
         CV0u90DIcBefSXYKmeRukA+tanHsk1F1CQNMtvWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 036/133] sfp: Fix error handing in sfp_probe()
Date:   Mon,  9 Nov 2020 13:54:58 +0100
Message-Id: <20201109125032.446747892@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
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
@@ -2389,7 +2389,8 @@ static int sfp_probe(struct platform_dev
 			continue;
 
 		sfp->gpio_irq[i] = gpiod_to_irq(sfp->gpio[i]);
-		if (!sfp->gpio_irq[i]) {
+		if (sfp->gpio_irq[i] < 0) {
+			sfp->gpio_irq[i] = 0;
 			sfp->need_poll = true;
 			continue;
 		}


