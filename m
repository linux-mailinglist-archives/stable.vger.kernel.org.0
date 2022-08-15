Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7F3594C86
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343749AbiHPAb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346372AbiHPAaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:30:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9FB37F8F;
        Mon, 15 Aug 2022 13:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F468B80EB1;
        Mon, 15 Aug 2022 20:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8795AC433D6;
        Mon, 15 Aug 2022 20:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595711;
        bh=l1DpSV+JZmB6Uto3+hA8ft5nZq/mq6tTv8aWI1ilAHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhbQli6j7QwsG9WJzNJddfb/Aq+l04CxIXC2iNsZa5B4s9OTebuO3depz/+vtpAL7
         BJ34kJFNc0cLekq/lI8eoXlkxu7hrgWNXhwLaCHTUey1xkihszBt1FITyLJdICRCaA
         JYXU7ZX/8avtpmVLlN9BfOvB4m9TcdAtsuSYcag0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0850/1157] USB: serial: fix tty-port initialized comments
Date:   Mon, 15 Aug 2022 20:03:26 +0200
Message-Id: <20220815180513.486785921@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 9d56138133a9..ef6a2891f290 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -737,7 +737,8 @@ static void sierra_close(struct usb_serial_port *port)
 
 	/*
 	 * Need to take susp_lock to make sure port is not already being
-	 * resumed, but no need to hold it due to initialized
+	 * resumed, but no need to hold it due to the tty-port initialized
+	 * flag.
 	 */
 	spin_lock_irq(&intfdata->susp_lock);
 	if (--intfdata->open_ports == 0)
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 24101bd7fcad..e35bea2235c1 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -295,7 +295,7 @@ static int serial_open(struct tty_struct *tty, struct file *filp)
  *
  * Shut down a USB serial port. Serialized against activate by the
  * tport mutex and kept to matching open/close pairs
- * of calls by the initialized flag.
+ * of calls by the tty-port initialized flag.
  *
  * Not called if tty is console.
  */
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index dab38b63eaf7..cc81ab7ef4da 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -388,7 +388,8 @@ void usb_wwan_close(struct usb_serial_port *port)
 
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



