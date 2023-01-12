Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3766781C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbjALOwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240005AbjALOwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9083574C1
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:39:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFEA0B81E70
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB58C433EF;
        Thu, 12 Jan 2023 14:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534343;
        bh=ZN1uqIKnRbORek46wyJybPpY39mJT9PJZkaRRBfcVHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQQOOId6TEoKykLyxV7MyApTsInkEKt9/355Mpk3vZemZH+yLUD6xMJ+DoTq6DBNe
         tLntafRvc54ztekd5xZHLYnpLCIxC1iTFeL7VEeypqfcBCQnLAh1ZcJy/hisKjn2As
         oJDVsNlF/ZDhXKn0i6VIlKFpeouH81IKMz2Jfjqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 777/783] serial: fixup backport of "serial: Deassert Transmit Enable on probe in driver-specific way"
Date:   Thu, 12 Jan 2023 14:58:13 +0100
Message-Id: <20230112135600.410571286@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

When 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
driver-specific way") got backported to 5.10.y, there known as
26a2b9c468de, some hunks were accidentally left out.

In serial_core.c, it is possible that the omission in
uart_suspend_port() is harmless, but the backport did have the
corresponding hunk in uart_resume_port(), it runs counter to the
original commit's intention of

  Skip any invocation of ->set_mctrl() if RS485 is enabled.

and it's certainly better to be aligned with upstream.

Link: https://lkml.kernel.org/r/20221222114414.1886632-1-linux@rasmusvillemoes.dk
Fixes: 26a2b9c468de ("serial: Deassert Transmit Enable on probe in driver-specific way")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
[the fsl_lpuart part of the 5.15 patch is not required on 5.10,
because the code before 26a2b9c468de was incorrectly not calling
uart_remove_one_port on failed_get_rs485]
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2254,7 +2254,8 @@ int uart_suspend_port(struct uart_driver
 
 		spin_lock_irq(&uport->lock);
 		ops->stop_tx(uport);
-		ops->set_mctrl(uport, 0);
+		if (!(uport->rs485.flags & SER_RS485_ENABLED))
+			ops->set_mctrl(uport, 0);
 		ops->stop_rx(uport);
 		spin_unlock_irq(&uport->lock);
 


