Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441883C3098
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhGJCf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbhGJCe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCF26124C;
        Sat, 10 Jul 2021 02:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884326;
        bh=jubVaQRlhNSmiN+XmTt572cEjRXXkVgH+Bp7bvrT6Vg=;
        h=From:To:Cc:Subject:Date:From;
        b=JbONIqs5EynXwNL7RjgaOGjuP7BVbgW1N0Pt1yUkiR2abyRLO1aCRCWrejKGa3Otx
         6fjzA2IGLzgRDUr5X+9AuSRhppXZnV8XgNwzt/eb7GqPxcnA4FfZ/RnicKMTvCQd0O
         UWPc3zB4cFcC3GH5Tnk34nhg+XfzEgxGQVzVvR008G8CuOhYCOzAYCHylyyyn06Pit
         MklNqLg9DbtQIJuuz5EROreiy7WyGgE3GC9c8pBCF3mvY4oMBMVCYrw8OuJTp+auP5
         3UqWXbF/nMJp/OYybbT4K/L3gLG+pSTiLMxkOEIxXBy4dzH+DqE4Rg+hJywpqEGytE
         ULQRKhXrKx6mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/39] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Fri,  9 Jul 2021 22:31:26 -0400
Message-Id: <20210710023204.3171428-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit fcb10ee27fb91b25b68d7745db9817ecea9f1038 ]

We should be very careful about the register values that will be used
for division or modulo operations, althrough the possibility that the
UARTBAUD register value is zero is very low, but we had better to deal
with the "bad data" of hardware in advance to avoid division or modulo
by zero leading to undefined kernel behavior.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20210427021226.27468-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 4b9f42269477..deb9d4fa9cb0 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1992,6 +1992,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
 	bd = lpuart32_read(&sport->port, UARTBAUD);
 	bd &= UARTBAUD_SBR_MASK;
+	if (!bd)
+		return;
+
 	sbr = bd;
 	uartclk = clk_get_rate(sport->clk);
 	/*
-- 
2.30.2

