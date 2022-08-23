Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B16459D870
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbiHWJvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351690AbiHWJuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:50:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9AA6DF9A;
        Tue, 23 Aug 2022 01:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0720761338;
        Tue, 23 Aug 2022 08:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7FEC433D6;
        Tue, 23 Aug 2022 08:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244274;
        bh=aolZgR12PUzxTi1PxC82EDK5N5Y8ZmpIPPwJr1pSbSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rkmck8acNBP9tHM7vZbYO8TDsrh/QBB/azb9mhtrCNM5nr674F9JOgMaCBmAwrwaX
         PfWvQTytkWIcd399g2QucmN5k53MeGeycGvV5xhIKFt+ZRKRY8Ayj3vLLKeDiUtsCJ
         X1peLc0aSqRe2r9voQvRkvQNoPZy7aX3N9Ml2/t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/229] USB: serial: fix tty-port initialized comments
Date:   Tue, 23 Aug 2022 10:24:33 +0200
Message-Id: <20220823080057.677023084@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 688ee1d1785c1359f9040f615dd8e6054962bce2 ]

Fix up the tty-port initialized comments which got truncated and
obfuscated when replacing the old ASYNCB_INITIALIZED flag.

Fixes: d41861ca19c9 ("tty: Replace ASYNC_INITIALIZED bit and update atomically")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/sierra.c     | 3 ++-
 drivers/usb/serial/usb-serial.c | 2 +-
 drivers/usb/serial/usb_wwan.c   | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index a9c5564b6b65..fcbe8a9d2650 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -759,7 +759,8 @@ static void sierra_close(struct usb_serial_port *port)
 
 	/*
 	 * Need to take susp_lock to make sure port is not already being
-	 * resumed, but no need to hold it due to initialized
+	 * resumed, but no need to hold it due to the tty-port initialized
+	 * flag.
 	 */
 	spin_lock_irq(&intfdata->susp_lock);
 	if (--intfdata->open_ports == 0)
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 3dc3464626fb..731bae05d7e5 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -254,7 +254,7 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
  *
  * Shut down a USB serial port. Serialized against activate by the
  * tport mutex and kept to matching open/close pairs
- * of calls by the initialized flag.
+ * of calls by the tty-port initialized flag.
  *
  * Not called if tty is console.
  */
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 4fab7ec9cd3f..bb05c9ea9190 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -465,7 +465,8 @@ void usb_wwan_close(struct usb_serial_port *port)
 
 	/*
 	 * Need to take susp_lock to make sure port is not already being
-	 * resumed, but no need to hold it due to initialized
+	 * resumed, but no need to hold it due to the tty-port initialized
+	 * flag.
 	 */
 	spin_lock_irq(&intfdata->susp_lock);
 	if (--intfdata->open_ports == 0)
-- 
2.35.1



