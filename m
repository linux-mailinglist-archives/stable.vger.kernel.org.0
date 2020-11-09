Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E012ABA96
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbgKINUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732909AbgKINUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD8E520663;
        Mon,  9 Nov 2020 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928036;
        bh=kXFRtjBxsyYjLjWKGTA7/FcRMhr+/+nYL7ud7uUDT6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWd2+U/sj/yCsPFFCG2MgH+WMjZBQnGjsPWpj6Wt6TmU6MFABxHkMpBMb/oKsD9ig
         iErToe1jDr+u51QvTcG257DaNjDXO3UE2UAssfYsy7PrSVM9+w866yrbKBZgAMWAbj
         i7hhKCqM7vujGNelKQ53Owwe5DKvSfCCiD092Xyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH 5.9 106/133] tty: serial: imx: enable earlycon by default if IMX_SERIAL_CONSOLE is enabled
Date:   Mon,  9 Nov 2020 13:56:08 +0100
Message-Id: <20201109125035.789587193@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 427627a23c3e86e31113f9db9bfdca41698a0ee5 upstream.

Since 699cc4dfd140 (tty: serial: imx: add imx earlycon driver), the earlycon
part of imx serial is a separate driver and isn't necessarily enabled anymore
when the console is enabled. This causes users to loose the earlycon
functionality when upgrading their kenrel configuration via oldconfig.

Enable earlycon by default when IMX_SERIAL_CONSOLE is enabled.

Fixes: 699cc4dfd140 (tty: serial: imx: add imx earlycon driver)
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20201105204026.1818219-1-l.stach@pengutronix.de
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -522,6 +522,7 @@ config SERIAL_IMX_EARLYCON
 	depends on OF
 	select SERIAL_EARLYCON
 	select SERIAL_CORE_CONSOLE
+	default y if SERIAL_IMX_CONSOLE
 	help
 	  If you have enabled the earlycon on the Freescale IMX
 	  CPU you can make it the earlycon by answering Y to this option.


