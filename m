Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA813D6201
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhGZPd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhGZPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5F2E60F5D;
        Mon, 26 Jul 2021 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315923;
        bh=8geNSeru6DVfirCvlwIy2l/pC+6PLYeidIwPt3Ld+kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQNZKR7l4wql6XZf62d16fXKKopBwQmFyt8z+7iTui/YkiPtIP2qSdPIaSwXvAoA9
         xPBXfQbj8fnkGPaMpVzLQJDGiwY3RhwzB69P3lDrclhwSI8HFSMW1+MXaV/a09y29y
         Dmx7kRNaJxS3CXC0pk8cZaMQHF5T8qIsJ2O2EMiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 120/223] i2c: mpc: Poll for MCF
Date:   Mon, 26 Jul 2021 17:38:32 +0200
Message-Id: <20210726153850.189158572@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 4a8ac5e45cdaa88884b4ce05303e304cbabeb367 ]

During some transfers the bus can still be busy when an interrupt is
received. Commit 763778cd7926 ("i2c: mpc: Restore reread of I2C status
register") attempted to address this by re-reading MPC_I2C_SR once but
that just made it less likely to happen without actually preventing it.
Instead of a single re-read, poll with a timeout so that the bus is given
enough time to settle but a genuine stuck SCL is still noticed.

Fixes: 1538d82f4647 ("i2c: mpc: Interrupt driven transfer")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 6d5014ebaab5..a6ea1eb1394e 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -635,8 +635,8 @@ static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
 
 	status = readb(i2c->base + MPC_I2C_SR);
 	if (status & CSR_MIF) {
-		/* Read again to allow register to stabilise */
-		status = readb(i2c->base + MPC_I2C_SR);
+		/* Wait up to 100us for transfer to properly complete */
+		readb_poll_timeout(i2c->base + MPC_I2C_SR, status, !(status & CSR_MCF), 0, 100);
 		writeb(0, i2c->base + MPC_I2C_SR);
 		mpc_i2c_do_intr(i2c, status);
 		return IRQ_HANDLED;
-- 
2.30.2



