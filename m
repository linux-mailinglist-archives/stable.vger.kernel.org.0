Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3588EFF009
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbfKPPw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbfKPPwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:52:21 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42E9020728;
        Sat, 16 Nov 2019 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919541;
        bh=dvvlDb/+0VMhtBKkl1moFhh/et82E8jtpyGoaFbPt7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7dVi7VI6xUFGv7gJYMn0cvHgj6rKot0LCfaaEfKKpAAEDSOYNdtrHN4ufrI6mITe
         dMDiIlt0g8iRoEfZ4TmAHjN5MlZKwDCr4m++3H+0qHK6rLJw+2xLr8hWudVSP0CO/P
         I1QmPk7cu79HQHcFJqBDgnqD5FXHVTF70zdM9xSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 56/99] um: Make line/tty semantics use true write IRQ
Date:   Sat, 16 Nov 2019 10:50:19 -0500
Message-Id: <20191116155103.10971-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
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
index 62087028a9ce1..d2ad45c101137 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -260,7 +260,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
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

