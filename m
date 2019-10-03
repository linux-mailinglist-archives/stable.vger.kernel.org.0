Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F88ECA347
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388508AbfJCQOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388504AbfJCQOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07A8A20700;
        Thu,  3 Oct 2019 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119241;
        bh=nv5tyfbfrOt8/5M/vZRl8GRVLkrUHUar+IwteF0cp3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEJuvm4ZwJkIXNsNdkE7ncE5lydUyDunX2A7g1WyqNb8Xp8X6whl+V1SeZ/amBs1o
         waAUaJGEc5dHhgwrRHgQBCN/ixQD3t0H7h9v8yB+niSnPqBHBBQgS86PgrvxGutpXz
         7LSkeB39oIJnerqfNmOqiBa/Ie69lvFNTAgww4ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.14 179/185] i2c: riic: Clear NACK in tend isr
Date:   Thu,  3 Oct 2019 17:54:17 +0200
Message-Id: <20191003154521.694500080@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Brandt <chris.brandt@renesas.com>

commit a71e2ac1f32097fbb2beab098687a7a95c84543e upstream.

The NACKF flag should be cleared in INTRIICNAKI interrupt processing as
description in HW manual.

This issue shows up quickly when PREEMPT_RT is applied and a device is
probed that is not plugged in (like a touchscreen controller). The result
is endless interrupts that halt system boot.

Fixes: 310c18a41450 ("i2c: riic: add driver")
Cc: stable@vger.kernel.org
Reported-by: Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-riic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -212,6 +212,7 @@ static irqreturn_t riic_tend_isr(int irq
 	if (readb(riic->base + RIIC_ICSR2) & ICSR2_NACKF) {
 		/* We got a NACKIE */
 		readb(riic->base + RIIC_ICDRR);	/* dummy read */
+		riic_clear_set_bit(riic, ICSR2_NACKF, 0, RIIC_ICSR2);
 		riic->err = -ENXIO;
 	} else if (riic->bytes_left) {
 		return IRQ_NONE;


