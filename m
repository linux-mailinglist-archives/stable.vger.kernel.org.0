Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F6F469ECC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376369AbhLFPoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390251AbhLFPmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2C9C09CE57;
        Mon,  6 Dec 2021 07:26:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FA75B810AC;
        Mon,  6 Dec 2021 15:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D447CC34900;
        Mon,  6 Dec 2021 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804361;
        bh=Ext6ZqfE8sVnU9h6sFrHWioziDXc1kQDxZ145o/hI8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2XOKTl1H5FSR3Ixk5aYNDDVHKzIC7N758eeZURan4frki7lkIRYyPa8fDmTd6vYb
         2ZNDOH0YiD8vcguAOjI17E0u2SpD6TaHIfTLuS44JGSUhbBmuXCCDahVGuFD4vBKOm
         I6Yru6T3dqZEuIWxZhF6rOGvD8aXvmzXgHORJWRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 102/207] i2c: cbus-gpio: set atomic transfer callback
Date:   Mon,  6 Dec 2021 15:55:56 +0100
Message-Id: <20211206145613.773331088@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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


