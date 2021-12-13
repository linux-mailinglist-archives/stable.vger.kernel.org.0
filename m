Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848604729DE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhLMK0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbhLMKYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:24:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E3C018B41;
        Mon, 13 Dec 2021 01:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D0B9CE0F47;
        Mon, 13 Dec 2021 09:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1841AC34600;
        Mon, 13 Dec 2021 09:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389573;
        bh=R5rS5VHgeyL4l0JwjhOqMsMgnTHLdlbhgq0jbVGHanw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZ+MXQuwcy6BnS+lub1BqtqgTYop2dDXwcWIJXa1uj5gSAhk7djsM/KXCVFYLSwE1
         MUPw4dUjwPhzCXGhKGSnRN1saxG/2nuPvG5YQdTSuEGHj7xuZM/GbAFjZvvqhn+7GP
         I4ciDCVqkkm/z0gZ+bzJAxqmYBkdnk2lK6J2FRZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 101/171] i2c: mpc: Use atomic read and fix break condition
Date:   Mon, 13 Dec 2021 10:30:16 +0100
Message-Id: <20211213092948.440424427@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

commit a74c313aca266fab0d1d1a72becbb8b7b5286b6e upstream.

Maxime points out that the polling code in mpc_i2c_isr should use the
_atomic API because it is called in an irq context and that the
behaviour of the MCF bit is that it is 1 when the byte transfer is
complete. All of this means the original code was effectively a
udelay(100).

Fix this by using readb_poll_timeout_atomic() and removing the negation
of the break condition.

Fixes: 4a8ac5e45cda ("i2c: mpc: Poll for MCF")
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Tested-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -636,7 +636,7 @@ static irqreturn_t mpc_i2c_isr(int irq,
 	status = readb(i2c->base + MPC_I2C_SR);
 	if (status & CSR_MIF) {
 		/* Wait up to 100us for transfer to properly complete */
-		readb_poll_timeout(i2c->base + MPC_I2C_SR, status, !(status & CSR_MCF), 0, 100);
+		readb_poll_timeout_atomic(i2c->base + MPC_I2C_SR, status, status & CSR_MCF, 0, 100);
 		writeb(0, i2c->base + MPC_I2C_SR);
 		mpc_i2c_do_intr(i2c, status);
 		return IRQ_HANDLED;


