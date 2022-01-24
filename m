Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA532498D76
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351844AbiAXTcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56854 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbiAXT3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:29:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8334961318;
        Mon, 24 Jan 2022 19:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63496C340E7;
        Mon, 24 Jan 2022 19:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052558;
        bh=5+WVR8/VwfqjhVkSmEbR7E7LpMZedr93a/vPe4N8MMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ8waSCWfU6vQ58frZU4U2+Mfr0m+u7N6kbJJusUA63Sj+ipcwHdKVY4xTsNS0QFK
         EofTPDmq6T/xFeDajnYHU/irdS2urNuyNcU4xU/7e/PSO8jeTS+OJKqtsaWvZfOoPU
         TZNZNPPCfwnZjoqvCtaf9oaUml/hAIR/sJbhqcYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lizhi Hou <lizhi.hou@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/320] tty: serial: uartlite: allow 64 bit address
Date:   Mon, 24 Jan 2022 19:40:50 +0100
Message-Id: <20220124183955.969344022@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lizhi Hou <lizhi.hou@xilinx.com>

[ Upstream commit 3672fb65155530b5eea6225685c75329b6debec3 ]

The base address of uartlite registers could be 64 bit address which is from
device resource. When ulite_probe() calls ulite_assign(), this 64 bit
address is casted to 32-bit. The fix is to replace "u32" type with
"phys_addr_t" type for the base address in ulite_assign() argument list.

Fixes: 8fa7b6100693 ("[POWERPC] Uartlite: Separate the bus binding from the driver proper")
Signed-off-by: Lizhi Hou <lizhi.hou@xilinx.com>
Link: https://lore.kernel.org/r/20211129202302.1319033-1-lizhi.hou@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/uartlite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 56066d93a65b8..9a4049c894f7a 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -618,7 +618,7 @@ static struct uart_driver ulite_uart_driver = {
  *
  * Returns: 0 on success, <0 otherwise
  */
-static int ulite_assign(struct device *dev, int id, u32 base, int irq,
+static int ulite_assign(struct device *dev, int id, phys_addr_t base, int irq,
 			struct uartlite_data *pdata)
 {
 	struct uart_port *port;
-- 
2.34.1



