Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA294419A05
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhI0RGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhI0RFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C15B610FC;
        Mon, 27 Sep 2021 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762252;
        bh=Ba75qXYPZPQCLgO4W/Xt5wNbmeQ98XfUQ4dURcrPfDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYpiTc7PhtyFy8OusB3YSINhlTnFpNxN5wZwBKtpq8iMe6fFbdpe9p7yPhATPq2F3
         7sQmdJMX6hT3ABIuD4bsjRho8rPnzLMat8cYy+5IkkaTJaPYK8eYHXsDrjVY6qNhoR
         Se+Itv11rnDOBvc64XLIjB6ttDghgoOQ2NzvaNaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <balbi@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.4 02/68] usb: gadget: r8a66597: fix a loop in set_feature()
Date:   Mon, 27 Sep 2021 19:01:58 +0200
Message-Id: <20210927170219.984041931@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 17956b53ebff6a490baf580a836cbd3eae94892b upstream.

This loop is supposed to loop until if reads something other than
CS_IDST or until it times out after 30,000 attempts.  But because of
the || vs && bug, it will never time out and instead it will loop a
minimum of 30,000 times.

This bug is quite old but the code is only used in USB_DEVICE_TEST_MODE
so it probably doesn't affect regular usage.

Fixes: 96fe53ef5498 ("usb: gadget: r8a66597-udc: add support for TEST_MODE")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210906094221.GA10957@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1250,7 +1250,7 @@ static void set_feature(struct r8a66597
 			do {
 				tmp = r8a66597_read(r8a66597, INTSTS0) & CTSQ;
 				udelay(1);
-			} while (tmp != CS_IDST || timeout-- > 0);
+			} while (tmp != CS_IDST && timeout-- > 0);
 
 			if (tmp == CS_IDST)
 				r8a66597_bset(r8a66597,


