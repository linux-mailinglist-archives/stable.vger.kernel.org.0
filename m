Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCA33B4FF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCONxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCONwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6315264EEC;
        Mon, 15 Mar 2021 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816365;
        bh=ScW4rOd4ghsjUf6uCweiEe9J55HiT107vre18lkL57E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PebaJK8+J5o46c/BS3Eut/5FKkk5EFwgrugL83k1JAqilLi19XNTBXFPUmMaYFEZZ
         ODAbnkW1YZ1TUgkfwhQIZPrRrkdu5fpC+zTRGMEtAJ6GMGM7MilXzIP377Y+R4d/Pe
         GPyi+VUzlvUAV80d+0d1pSGeqVw3ZkMFi/VvvaD0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 05/75] can: flexcan: assert FRZ bit in flexcan_chip_freeze()
Date:   Mon, 15 Mar 2021 14:51:19 +0100
Message-Id: <20210315135208.440928788@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 449052cfebf624b670faa040245d3feed770d22f upstream.

Assert HALT bit to enter freeze mode, there is a premise that FRZ bit is
asserted. This patch asserts FRZ bit in flexcan_chip_freeze, although
the reset value is 1b'1. This is a prepare patch, later patch will
invoke flexcan_chip_freeze() to enter freeze mode, which polling freeze
mode acknowledge.

Fixes: b1aa1c7a2165b ("can: flexcan: fix transition from and to freeze mode in chip_{,un}freeze")
Link: https://lore.kernel.org/r/20210218110037.16591-2-qiangqing.zhang@nxp.com
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -383,7 +383,7 @@ static int flexcan_chip_freeze(struct fl
 	u32 reg;
 
 	reg = flexcan_read(&regs->mcr);
-	reg |= FLEXCAN_MCR_HALT;
+	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
 	flexcan_write(reg, &regs->mcr);
 
 	while (timeout-- && !(flexcan_read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))


