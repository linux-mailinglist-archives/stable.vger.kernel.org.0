Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE9FF106
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbfKPPta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730320AbfKPPt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:26 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A93020870;
        Sat, 16 Nov 2019 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919365;
        bh=PZrL9vWqCTiFw2xV4xCtIutuGc0aIhE7zE1PDg4v3/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6PlZZqPcDvDOiHGjIkG32U1y3ENQJy61urFVoYSC2juGfZ6AFu0g5rF1MtgaocKN
         B92O05DB69DTfpetnmcGg9oS9fX3dhMDobdmVqugzmhvazuJTj4zN0qwoXT6+sr3Ut
         YsNxHu0U2l4+xVhwfpbtNvIBTNzUa956S/aQH8Vc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 087/150] um: Make line/tty semantics use true write IRQ
Date:   Sat, 16 Nov 2019 10:46:25 -0500
Message-Id: <20191116154729.9573-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

[ Upstream commit 917e2fd2c53eb3c4162f5397555cbd394390d4bc ]

This fixes a long standing bug where large amounts of output
could freeze the tty (most commonly seen on stdio console).
While the bug has always been there it became more pronounced
after moving to the new interrupt controller.

The line semantics are now changed to have true IRQ write
semantics which should further improve the tty/line subsystem
stability and performance

Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/line.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 366e57f5e8d63..7e524efed5848 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -261,7 +261,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	if (err == 0) {
 		spin_unlock(&line->lock);
 		return IRQ_NONE;
-	} else if (err < 0) {
+	} else if ((err < 0) && (err != -EAGAIN)) {
 		line->head = line->buffer;
 		line->tail = line->buffer;
 	}
-- 
2.20.1

