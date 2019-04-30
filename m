Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7921AF7BB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfD3Loa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbfD3Lo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:44:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE962177B;
        Tue, 30 Apr 2019 11:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624669;
        bh=TsZdpmCy1pcPB5gfC6C686aDfKiW4WLiHwcWOX4x58w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOU+UOJp2HDKLNV0Sx/U5bhyNo4HEugxWPguMk4vTPz/S4Hv+4IXSlwvigs6MIfdo
         BxL+kqdCUu1nr+/zC9Hd5BHhN9gkx/sz1QMAYD1mckgnDQUMt2s6/LGg18sZuiw3qk
         30PlA7Q5zp7m/9zVbTonEukynIccN1DJMinc7BJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 027/100] gpio: eic: sprd: Fix incorrect irq type setting for the sync EIC
Date:   Tue, 30 Apr 2019 13:37:56 +0200
Message-Id: <20190430113610.145108698@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baolin Wang <baolin.wang@linaro.org>

commit 102bbe34b31c9159e714432afd64458f6f3876d7 upstream.

When setting sync EIC as IRQ_TYPE_EDGE_BOTH type, we missed to set the
SPRD_EIC_SYNC_INTMODE register to 0, which means detecting edge signals.

Thus this patch fixes the issue.

Fixes: 25518e024e3a ("gpio: Add Spreadtrum EIC driver support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-eic-sprd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-eic-sprd.c
+++ b/drivers/gpio/gpio-eic-sprd.c
@@ -414,6 +414,7 @@ static int sprd_eic_irq_set_type(struct
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_EDGE_BOTH:
+			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTBOTH, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;


