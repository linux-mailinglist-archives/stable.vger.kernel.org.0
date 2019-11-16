Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B5FFF29F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfKPPoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:44:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfKPPo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:29 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F52020803;
        Sat, 16 Nov 2019 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919068;
        bh=DYDeOGRcI4kuQWrRA6hmaepxNa+IRLppnQKcvt38DBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2TsweSq3Q7NI+TkM2IrnEvvf6i4gWnfpimWLbLTZZ3uVSwfe8yRDoQy6TCMS0opo
         y/h6DXcMF2/wXSEHUKLnEH3X0ONxRv8BedLNDd1GGV4d4vv99fgqom0WuSBAMh+NO9
         T2oSO4UvnLNGKq40MePp9C6nosrY0Kx8qd0a47is=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 140/237] um: Make line/tty semantics use true write IRQ
Date:   Sat, 16 Nov 2019 10:39:35 -0500
Message-Id: <20191116154113.7417-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
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
 arch/um/drivers/line.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 8d80b27502e6a..7e524efed5848 100644
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
@@ -284,7 +284,7 @@ int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 	if (err)
 		return err;
 	if (output)
-		err = um_request_irq(driver->write_irq, fd, IRQ_NONE,
+		err = um_request_irq(driver->write_irq, fd, IRQ_WRITE,
 				     line_write_interrupt, IRQF_SHARED,
 				     driver->write_irq_name, data);
 	return err;
-- 
2.20.1

