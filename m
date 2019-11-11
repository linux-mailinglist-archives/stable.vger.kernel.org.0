Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48CBF7F6B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfKKSbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfKKSbe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:31:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AFAD2173B;
        Mon, 11 Nov 2019 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497093;
        bh=+OcbpRDk8vmqcpdXP162JIV+eV/Y2V5IJpuBxfMkdiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGlDqSXG75L4FUO0NE0qXxuaAjxzql/vW55/CwLquG4seZ1gnszr2ikBltRB5gGYY
         fWz9/Fg1c1/RzvbV6hDD+e1t1UHsMchnM1znq1mlz+NkAN6QREnXnS9MgSb/vMFzZb
         xhhzJ5qTM2HNfgY5LIucLy2VKvnPIj9flgIfNxkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 41/43] can: flexcan: disable completely the ECC mechanism
Date:   Mon, 11 Nov 2019 19:28:55 +0100
Message-Id: <20191111181328.218240801@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 5e269324db5adb2f5f6ec9a93a9c7b0672932b47 ]

The ECC (memory error detection and correction) mechanism can be
activated or not, controlled by the ECCDIS bit in CAN_MECR. When
disabled, updates on indications and reporting registers are stopped.
So if want to disable ECC completely, had better assert ECCDIS bit, not
just mask the related interrupts.

Fixes: cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -923,6 +923,7 @@ static int flexcan_chip_start(struct net
 		reg_mecr = flexcan_read(&regs->mecr);
 		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
 		flexcan_write(reg_mecr, &regs->mecr);
+		reg_mecr |= FLEXCAN_MECR_ECCDIS;
 		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		flexcan_write(reg_mecr, &regs->mecr);


