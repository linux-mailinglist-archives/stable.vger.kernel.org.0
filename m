Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE903C55DF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350124AbhGLIM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354001AbhGLIDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D52461A19;
        Mon, 12 Jul 2021 07:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076755;
        bh=2DjKnuJYo6CRy0mLMm13Hc7BpLJ2aMnbSkwUhZ5AR50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yErIcvLl9mYKHLb/2xdJTq76avZBgwNp/HcVP1T0wa6cERUXQvL4RDTIZJTcAbCc/
         v+EUWjxka8FokCPNLKul1W1HeQgDhTAy2TD3PD8LGxezVxx28pzxJlUzOVhAxd9+RE
         15L9ZK0aGjNPRfn/7PJR4FqbhfcELt+XHuPfCTzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 779/800] i2c: mpc: Restore reread of I2C status register
Date:   Mon, 12 Jul 2021 08:13:22 +0200
Message-Id: <20210712061049.723306779@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 763778cd79267dadf0ec7e044caf7563df0ab597 ]

Prior to commit 1538d82f4647 ("i2c: mpc: Interrupt driven transfer") the
old interrupt handler would reread MPC_I2C_SR after checking the CSR_MIF
bit. When the driver was re-written this was removed as it seemed
unnecessary. However as it turns out this is necessary for i2c devices
which do clock stretching otherwise we end up thinking the bus is still
busy when processing the interrupt.

Fixes: 1538d82f4647 ("i2c: mpc: Interrupt driven transfer")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mpc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index dcca9c2396db..6d5014ebaab5 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -635,6 +635,8 @@ static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
 
 	status = readb(i2c->base + MPC_I2C_SR);
 	if (status & CSR_MIF) {
+		/* Read again to allow register to stabilise */
+		status = readb(i2c->base + MPC_I2C_SR);
 		writeb(0, i2c->base + MPC_I2C_SR);
 		mpc_i2c_do_intr(i2c, status);
 		return IRQ_HANDLED;
-- 
2.30.2



