Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C3011346F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfLDSCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728852AbfLDSCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:02:17 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8B620659;
        Wed,  4 Dec 2019 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482537;
        bh=cLe4GfX3E+Qhpoe7pEAgaJTKy8YO6Tx/QDZhLXEeOIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fe2S5bPc0wF5Bqsnis0Qz7uX7NnRWxmaUQqSyPF+V0rs7dmQaLSlujo0FRMlA2OEJ
         nSuo7lJxFtGuOEjsL9hwGnZrvi8x0lBIUu499eOrknu9UEdsHZK5n6/d10MMwpiiqX
         njC7CqnEUTZUIj7oD2FRA/1SKDbSY8hYv+/uvEnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 035/209] parisc: Fix serio address output
Date:   Wed,  4 Dec 2019 18:54:07 +0100
Message-Id: <20191204175323.867395924@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aa9f29b875dea..d84e3b70215ad 100644
--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -382,9 +382,9 @@ static int __init gscps2_probe(struct parisc_device *dev)
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



