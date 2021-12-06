Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580DD469C79
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357611AbhLFPWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:22:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53986 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376938AbhLFPUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:20:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36F3FB8111E;
        Mon,  6 Dec 2021 15:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C805C341C2;
        Mon,  6 Dec 2021 15:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803840;
        bh=Ext6ZqfE8sVnU9h6sFrHWioziDXc1kQDxZ145o/hI8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vj1InWiGEZb3wwz9ailLU+Zdj01vfKK3RUvaGe2OAhfLtrXFFyjjeHVd5ht2aFRZ/
         ZN0V7RCzELQ7XywIXThpnFpw0+vV5xJy9Eu3mvgfYEdA2sbqzQziRqVqIYVOMGu9uH
         g70DkPoiZp6NipPDmA0fohd1DrXruHkWz3ejBnjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 064/130] i2c: cbus-gpio: set atomic transfer callback
Date:   Mon,  6 Dec 2021 15:56:21 +0100
Message-Id: <20211206145601.891092915@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit b12764695c3fcade145890b67f82f8b139174cc7 upstream.

CBUS transfers have always been atomic, but after commit 63b96983a5dd
("i2c: core: introduce callbacks for atomic transfers") we started to see
warnings during e.g. poweroff as the atomic callback is not explicitly set.
Fix that.

Fixes the following WARNING seen during Nokia N810 power down:

[  786.570617] reboot: Power down
[  786.573913] ------------[ cut here ]------------
[  786.578826] WARNING: CPU: 0 PID: 672 at drivers/i2c/i2c-core.h:40 i2c_smbus_xfer+0x100/0x110
[  786.587799] No atomic I2C transfer handler for 'i2c-2'

Fixes: 63b96983a5dd ("i2c: core: introduce callbacks for atomic transfers")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-cbus-gpio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-cbus-gpio.c
+++ b/drivers/i2c/busses/i2c-cbus-gpio.c
@@ -195,8 +195,9 @@ static u32 cbus_i2c_func(struct i2c_adap
 }
 
 static const struct i2c_algorithm cbus_i2c_algo = {
-	.smbus_xfer	= cbus_i2c_smbus_xfer,
-	.functionality	= cbus_i2c_func,
+	.smbus_xfer		= cbus_i2c_smbus_xfer,
+	.smbus_xfer_atomic	= cbus_i2c_smbus_xfer,
+	.functionality		= cbus_i2c_func,
 };
 
 static int cbus_i2c_remove(struct platform_device *pdev)


