Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A74229C710
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752998AbgJ0N6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752993AbgJ0N6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8800B206D4;
        Tue, 27 Oct 2020 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807081;
        bh=HOhYGf2UDIhKrg4GwxL4075rEbUsggKdop19aIGLRos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2AsOl0F2WepBD1quxIg53PyUJsLcvDTCXWG8lICKXE+1+Ae/y3/VQB4IqzxVRmbe
         TiS0/XFRAqd2b3eCe2rRgwWeLBmPpVYDHn4BPC178Pgo8qZykGuNh6WMhxzvlnCYyT
         mLjxbo5d8zJn2wtQ+ilKwVj8pG2slelIGgSlvuXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 036/112] tty: serial: earlycon dependency
Date:   Tue, 27 Oct 2020 14:49:06 +0100
Message-Id: <20201027134902.269585794@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 0fb9342d06b0f667b915ba58bfefc030e534a218 ]

parse_options() in drivers/tty/serial/earlycon.c calls uart_parse_earlycon
in drivers/tty/serial/serial_core.c therefore selecting SERIAL_EARLYCON
should automatically select SERIAL_CORE, otherwise will result in symbol
not found error during linking if SERIAL_CORE is not configured as builtin

Fixes: 9aac5887595b ("tty/serial: add generic serial earlycon")
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20200828123949.2642-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index f38beb28e7ae6..5c3c86d4fe716 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -9,6 +9,7 @@ menu "Serial drivers"
 
 config SERIAL_EARLYCON
 	bool
+	depends on SERIAL_CORE
 	help
 	  Support for early consoles with the earlycon parameter. This enables
 	  the console before standard serial driver is probed. The console is
-- 
2.25.1



