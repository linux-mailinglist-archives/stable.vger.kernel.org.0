Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6D710BFA5
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfK0VpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbfK0UgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:36:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94CC721582;
        Wed, 27 Nov 2019 20:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886976;
        bh=dvvlDb/+0VMhtBKkl1moFhh/et82E8jtpyGoaFbPt7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMYYhf1z0uFLZdjQ2uhXolBrWg2Z2mxzaqiaWBe0pQpJDARagG/rY3hnziOLq1pT6
         7Nr+6wnYQ48WOH+6qCELUx6AqGyZBwg3F0RUzZc9Xc0wmedO2jiLz1Pj8pl7/NjHyw
         iFzvNLIDa1GVytphdL73BsJorTragtG7vgbt//tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 063/132] um: Make line/tty semantics use true write IRQ
Date:   Wed, 27 Nov 2019 21:30:54 +0100
Message-Id: <20191127203000.660825178@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



