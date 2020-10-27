Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FD929B3E5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782070AbgJ0O4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1782057AbgJ0O4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3996222202;
        Tue, 27 Oct 2020 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810591;
        bh=Gmvx4WtfdG425Q3eSI869QXWdcUAsj9AGUtwWV7m66I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZuaVQZEdd6cjhmB5LH0DYXwPq+ive5V7BPa+H2g2aYS2RTx1/JnkMvznI11X6bnh
         N8AhalYXmBaQ86zWl1wAkiQBUK+jBtxEKXny1qEydKT/dZd9BK9t4UvTraiMNPkgKO
         zkfjWV0cH8RwRYwSjRsFVWhjGV/mZV6qK4dBKcO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 194/633] tty: serial: earlycon dependency
Date:   Tue, 27 Oct 2020 14:48:57 +0100
Message-Id: <20201027135531.777294220@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 780908d435577..896b9c77117d3 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -8,6 +8,7 @@ menu "Serial drivers"
 
 config SERIAL_EARLYCON
 	bool
+	depends on SERIAL_CORE
 	help
 	  Support for early consoles with the earlycon parameter. This enables
 	  the console before standard serial driver is probed. The console is
-- 
2.25.1



