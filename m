Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE41064B9
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbfKVFzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:55:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728946AbfKVFzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:55:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 308B42070A;
        Fri, 22 Nov 2019 05:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402151;
        bh=l9yHDJcal3aq3sI6P1LeEpTZuLYipVHXnMG2ZNDim2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2e0iSYqUQOsx+YleG0ZBzkjjEiJhiqQ4jAwYpOhS+OPNSLFGCEp0eZTKQyothsWb0
         //JGGpoZLkGW+GdWJ4Ou5DBU68Yp3/g1xftQFMll/KjR6XVa92I2uLFlw4rXM/GXNn
         tTPLxSpz6uf7zmCPEbSlURDEXM1cU7R5wfMVqOOw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 007/127] parisc: Fix HP SDC hpa address output
Date:   Fri, 22 Nov 2019 00:53:45 -0500
Message-Id: <20191122055544.3299-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit c4bff35ca1bfba886da6223c9fed76a2b1382b8e ]

Show the hpa address of the HP SDC instead of a hashed value, e.g.:
HP SDC: HP SDC at 0xf0201000, IRQ 23 (NMI IRQ 24)

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/hp_sdc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 8eef6849d0660..5585823ced19d 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -887,8 +887,8 @@ static int __init hp_sdc_init(void)
 			"HP SDC NMI", &hp_sdc))
 		goto err2;
 
-	printk(KERN_INFO PREFIX "HP SDC at 0x%p, IRQ %d (NMI IRQ %d)\n",
-	       (void *)hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
+	pr_info(PREFIX "HP SDC at 0x%08lx, IRQ %d (NMI IRQ %d)\n",
+	       hp_sdc.base_io, hp_sdc.irq, hp_sdc.nmi);
 
 	hp_sdc_status_in8();
 	hp_sdc_data_in8();
-- 
2.20.1

