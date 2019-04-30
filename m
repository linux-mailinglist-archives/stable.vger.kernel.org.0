Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25664F704
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbfD3Ltw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbfD3Ltw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D2BF2173E;
        Tue, 30 Apr 2019 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624991;
        bh=TsZdpmCy1pcPB5gfC6C686aDfKiW4WLiHwcWOX4x58w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yekqfFra68Hqp5thEvG9aDcnnJAEhjuGjn4ZAIY3jp5txFBQtelGuaBdm9Z4mCWuu
         +66MSHflMMj1n5LFfe22fw/c3Qn1zrcpHA8oB5OkGdaE+Iy4aSSt+wOnE8fdEy5uYB
         Egl9lrtqt0D1f2kLIRd7G2cPxYG8kMPWGua9hsmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baolin Wang <baolin.wang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.0 15/89] gpio: eic: sprd: Fix incorrect irq type setting for the sync EIC
Date:   Tue, 30 Apr 2019 13:38:06 +0200
Message-Id: <20190430113610.404625881@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
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


