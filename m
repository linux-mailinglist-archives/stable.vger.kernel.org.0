Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5025310666F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfKVGaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfKVFtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FCB2070B;
        Fri, 22 Nov 2019 05:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401772;
        bh=lYgW7XNs/bbUDwrVycp3txPbcFxD4o6rSDmCKbDXXEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3DkW109RdRE3mnfzsp90aCyCy+NCy1jp7FJGPzS8w8UGPa7WIE1bEK8MlmsaoNjO
         +T7PG5x3eaOqiTTB350dK8lbLJIO63AnuA7mvyX6bDyJ2/uZpu1h45xYPNBPJf+WMt
         ENObN3BXm6xFSZ0erpRkUrRYLefuKnpUBuxf+2PE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 022/219] parisc: Fix serio address output
Date:   Fri, 22 Nov 2019 00:45:54 -0500
Message-Id: <20191122054911.1750-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 785145171d17af2554128becd6a7c8f89e101141 ]

We want the hpa addresses printed in the serio modules, not some
virtual ioremap()ed address, e.g.:

 serio: gsc-ps2-keyboard port at 0xf0108000 irq 22 @ 2:0:11
 serio: gsc-ps2-mouse port at 0xf0108100 irq 22 @ 2:0:12

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/gscps2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/gscps2.c b/drivers/input/serio/gscps2.c
index 49d8d53e50b7b..96f9b5397367f 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -381,9 +381,9 @@ static int __init gscps2_probe(struct parisc_device *dev)
 		goto fail;
 #endif
 
-	printk(KERN_INFO "serio: %s port at 0x%p irq %d @ %s\n",
+	pr_info("serio: %s port at 0x%08lx irq %d @ %s\n",
 		ps2port->port->name,
-		ps2port->addr,
+		hpa,
 		ps2port->padev->irq,
 		ps2port->port->phys);
 
-- 
2.20.1

