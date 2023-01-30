Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B894D6811EB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbjA3ORV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbjA3OQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:16:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6B93D08E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3581B61083
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40056C433D2;
        Mon, 30 Jan 2023 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088210;
        bh=9MLON69AHoR+q/K+zfaO2GiUr4oqO7b6QntrDhxsdpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qs5KIgTowgTmrQK7JtbDufcTMJpNLqk0mapI17SB4xm0jV28wKh7iJ6HG64ijGydZ
         X2myRMFUCHZuPLQOlFe3ERCouOTlF/jE19PP889SP+cjFH5hKfPNphLxYjr+bkfWIu
         voUJGcoj54uFYg3ADa4LVpQDbsltfexnWpOJDfzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Morgan <macromorgan@hotmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Wolfram Sang <wsa@kernel.org>, Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH 5.15 152/204] i2c: mv64xxx: Remove shutdown method from driver
Date:   Mon, 30 Jan 2023 14:51:57 +0100
Message-Id: <20230130134323.236051412@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Morgan <macromorgan@hotmail.com>

commit 09b343038e3470e4d0da45f0ee09fb42107e5314 upstream.

When I attempt to shut down (or reboot) my R8 based NTC CHIP with this
i2c driver I get the following error: "i2c i2c-0: mv64xxx: I2C bus
locked, block: 1, time_left: 0". Reboots are successful but shutdowns
freeze. If I comment out the shutdown routine the device both reboots
and shuts down successfully without receiving this error (however it
does receive a warning of missing atomic_xfer).

It appears that very few i2c drivers have a shutdown method, I assume
because these devices are often used to communicate with PMICs (such
as in my case with the R8 based NTC CHIP). I'm proposing we simply
remove this method so long as it doesn't cause trouble for others
downstream. I'll work on an atomic_xfer method and submit that in
a different patch.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Acked-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mv64xxx.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -1047,14 +1047,6 @@ mv64xxx_i2c_remove(struct platform_devic
 	return 0;
 }
 
-static void
-mv64xxx_i2c_shutdown(struct platform_device *pd)
-{
-	pm_runtime_disable(&pd->dev);
-	if (!pm_runtime_status_suspended(&pd->dev))
-		mv64xxx_i2c_runtime_suspend(&pd->dev);
-}
-
 static const struct dev_pm_ops mv64xxx_i2c_pm_ops = {
 	SET_RUNTIME_PM_OPS(mv64xxx_i2c_runtime_suspend,
 			   mv64xxx_i2c_runtime_resume, NULL)
@@ -1065,7 +1057,6 @@ static const struct dev_pm_ops mv64xxx_i
 static struct platform_driver mv64xxx_i2c_driver = {
 	.probe	= mv64xxx_i2c_probe,
 	.remove	= mv64xxx_i2c_remove,
-	.shutdown = mv64xxx_i2c_shutdown,
 	.driver	= {
 		.name	= MV64XXX_I2C_CTLR_NAME,
 		.pm     = &mv64xxx_i2c_pm_ops,


