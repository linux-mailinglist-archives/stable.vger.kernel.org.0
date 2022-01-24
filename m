Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968484999F1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378171AbiAXViv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378363AbiAXV3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:29:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAB0C0A8848;
        Mon, 24 Jan 2022 12:19:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 731E1B811FB;
        Mon, 24 Jan 2022 20:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C9C340E5;
        Mon, 24 Jan 2022 20:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055558;
        bh=8RJImasyP0E687fOXhu6E9cjMMzCtvHjtFNDW7Y9jaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzUFTCvnoyp7Jy8RhjLTFpSREuJtRHqxVL28hCGmhI9B0hepr7qTb0RB9ckZbhSs9
         Z9AzFRWgmMYUO5E86Ldx8GY+MUIAlRH8/cpkjzuj/oJLKstx0MmLVadrckRKWoatyo
         Vp8H76Q9qK+Ajk9pkTmepH3IX2XT4rZ13QM5dNgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lizhi Hou <lizhi.hou@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/846] tty: serial: uartlite: allow 64 bit address
Date:   Mon, 24 Jan 2022 19:35:08 +0100
Message-Id: <20220124184107.541427000@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index dfc1ba4e15724..36871cebd6a0f 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -612,7 +612,7 @@ static struct uart_driver ulite_uart_driver = {
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



