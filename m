Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757AD6DF62C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 14:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDLMv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 08:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjDLMvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 08:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9B3E67;
        Wed, 12 Apr 2023 05:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 901216347C;
        Wed, 12 Apr 2023 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E720EC4339C;
        Wed, 12 Apr 2023 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681303820;
        bh=cB07st6xmfnNAjG3gTahjDFnN/n1huuNtFfo9gnhBEY=;
        h=From:To:Cc:Subject:Date:From;
        b=q7Rmc8f1u04NKMPlTME4lPTsDQIRlahQuoW+2iyf2X2+6O67Po92ybWVMAknYn4/4
         ccRsxe1qxv5BOiIzgny0JEBA2irFNQAuUyE7YVEVq/edeUCeb8MgsMIo1YLED3kBpr
         HdghfgHPL5GZ8igrDCQmLze4hkaAOToLwuNKQp0KF1e+OJM9yq2xB8MfYEXiCkIYK7
         5N0TJLt70g0bdjECOriqHffTqLXq0u1ilQF0N5MjI9tLvcIDK5mgIG8ZPLkvSVDOcN
         fzjrQteq7hgjj1jO2o+iA71KBXbpk4AYxRI3YEmLj+P7k4sKaouFDhQ+YL59Z+raRt
         M7NrR37WyOVYQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pmZvX-0002vd-D0; Wed, 12 Apr 2023 14:50:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH] serial: fix TIOCSRS485 locking
Date:   Wed, 12 Apr 2023 14:48:11 +0200
Message-Id: <20230412124811.11217-1-johan@kernel.org>
X-Mailer: git-send-email 2.39.2
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

The RS485 multipoint addressing support for some reason added a new
ADDRB termios cflag which is (only!) updated from one of the RS485
ioctls.

Make sure to take the termios rw semaphore for the right ioctl (i.e.
set, not get).

Fixes: ae50bb275283 ("serial: take termios_rwsem for ->rs485_config() & pass termios as param")
Cc: stable@vger.kernel.org	# 6.0
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---

I did not have time to review the multipoint addressing patches at the
time and only skimmed the archives now, but I can't seem to find any
motivation for why a precious termios bit was seemingly wasted on ADDRB
when it is only updated from the RS485 ioctls.

I hope it wasn't done just to simplify the implementation of
tty_get_frame_size()? Or was it a left-over from the RFC which
apparently actually used termios to enable this feature?

Should we consider dropping the Linux-specific ADDRB bit again?

Johan


 drivers/tty/serial/serial_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2bd32c8ece39..728cb72be066 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1552,7 +1552,7 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 		goto out;
 
 	/* rs485_config requires more locking than others */
-	if (cmd == TIOCGRS485)
+	if (cmd == TIOCSRS485)
 		down_write(&tty->termios_rwsem);
 
 	mutex_lock(&port->mutex);
@@ -1595,7 +1595,7 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 	}
 out_up:
 	mutex_unlock(&port->mutex);
-	if (cmd == TIOCGRS485)
+	if (cmd == TIOCSRS485)
 		up_write(&tty->termios_rwsem);
 out:
 	return ret;
-- 
2.39.2

