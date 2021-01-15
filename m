Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9B2F7ACC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbhAOMzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387642AbhAOMfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:35:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D22482336F;
        Fri, 15 Jan 2021 12:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714083;
        bh=fip9LsIw/fuTpb8HCUU2MKHFkHvdDURgaJVNA8Hvq0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1C3Mu9GouGzKlNBdHR0z4SZc9XNQmm3As0A1MCcB5+O6w/psUNmybnaJVloXXUsae
         7QLiED/oycexX9QH2tV636s7wGzE+lt4eU2oOZV9jvBmmoM14iyH5s0H0y2g8Htdvd
         wdzJEyLKSUkm71I/gHpcAIIwSmh2FhO3PuUEx0uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 38/62] can: kvaser_pciefd: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:28:00 +0100
Message-Id: <20210115122000.236610955@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 1d48595c786b1b9dc6be301e8d7f6fc74e9882aa upstream.

Without crc32, this driver fails to link:

arm-linux-gnueabi-ld: drivers/net/can/kvaser_pciefd.o: in function `kvaser_pciefd_probe':
kvaser_pciefd.c:(.text+0x2b0): undefined reference to `crc32_be'

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -123,6 +123,7 @@ config CAN_JANZ_ICAN3
 config CAN_KVASER_PCIEFD
 	depends on PCI
 	tristate "Kvaser PCIe FD cards"
+	select CRC32
 	  help
 	  This is a driver for the Kvaser PCI Express CAN FD family.
 


