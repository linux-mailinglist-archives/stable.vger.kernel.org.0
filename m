Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947D3395D88
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhEaNrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232757AbhEaNpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:45:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD46261415;
        Mon, 31 May 2021 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467782;
        bh=SOIkqthu+jcwGxaEf1kbni/BuJeajPxGrKkNdiRXLYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r02g0xGEsjFvP/qKOOGHnouRHMYeHi35iePbJUcRnCPo/k5qqYr4tP0dOmvT4bD0u
         1IUisZfPwqw5Fi0vmpII1Qw5ELuoG+hUKGJAEXdat87umWFNbZ8xF/vuwntkxmvba7
         y+Iyn47i352rI6wYzvOAkd9mX3ZCZrDxDlBVOtYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.14 42/79] i2c: s3c2410: fix possible NULL pointer deref on read message after write
Date:   Mon, 31 May 2021 15:14:27 +0200
Message-Id: <20210531130637.360477622@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 24990423267ec283b9d86f07f362b753eb9b0ed5 upstream.

Interrupt handler processes multiple message write requests one after
another, till the driver message queue is drained.  However if driver
encounters a read message without preceding START, it stops the I2C
transfer as it is an invalid condition for the controller.  At least the
comment describes a requirement "the controller forces us to send a new
START when we change direction".  This stop results in clearing the
message queue (i2c->msg = NULL).

The code however immediately jumped back to label "retry_write" which
dereferenced the "i2c->msg" making it a possible NULL pointer
dereference.

The Coverity analysis:
1. Condition !is_msgend(i2c), taking false branch.
   if (!is_msgend(i2c)) {

2. Condition !is_lastmsg(i2c), taking true branch.
   } else if (!is_lastmsg(i2c)) {

3. Condition i2c->msg->flags & 1, taking true branch.
   if (i2c->msg->flags & I2C_M_RD) {

4. write_zero_model: Passing i2c to s3c24xx_i2c_stop, which sets i2c->msg to NULL.
   s3c24xx_i2c_stop(i2c, -EINVAL);

5. Jumping to label retry_write.
   goto retry_write;

6. var_deref_model: Passing i2c to is_msgend, which dereferences null i2c->msg.
   if (!is_msgend(i2c)) {"

All previous calls to s3c24xx_i2c_stop() in this interrupt service
routine are followed by jumping to end of function (acknowledging
the interrupt and returning).  This seems a reasonable choice also here
since message buffer was entirely emptied.

Addresses-Coverity: Explicit null dereferenced
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-s3c2410.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -495,7 +495,10 @@ static int i2c_s3c_irq_nextbyte(struct s
 					 * forces us to send a new START
 					 * when we change direction
 					 */
+					dev_dbg(i2c->dev,
+						"missing START before write->read\n");
 					s3c24xx_i2c_stop(i2c, -EINVAL);
+					break;
 				}
 
 				goto retry_write;


