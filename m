Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829FC53824F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbiE3OWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241611AbiE3ORt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA9A5622F;
        Mon, 30 May 2022 06:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CEAB80DA7;
        Mon, 30 May 2022 13:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D387C36AE3;
        Mon, 30 May 2022 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918467;
        bh=AXOBA65BddkvlexoXP5FgrUhECKQc/p2tp+kkr1ZyVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTBGarW105iqQ2LzlgzisX1OsOyex5IjOHNCFpdC+WVT4VutEX7gUb1k2fbW3QgMV
         fR0uQKoxj6dSIhTl9ivXpoyfcRiIsiCr/n3NHa/c9V/1WTEdZwUtypmsg/vJI4FM2d
         kVtRkyuovLc8aQqxhl+uo1azTuofEhGdyMGMuBfSJmSQ6BxM7WobRywnhLeX75S0q3
         uhLtb+x0Cp8QVxn6W0c7ot/vAbN7RIfxcM2lZ0AQt2RP7Exuuo5TZG0a1pkfQwmuxp
         6xMwgcf+YqU0KB7Tld+hyeGAwFgDMQd4aIHzP5RNJ7B1q6SQNzJ/IP3qr0Mx54jcBk
         FNls6ltXZIsiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/55] media: cx25821: Fix the warning when removing the module
Date:   Mon, 30 May 2022 09:46:23 -0400
Message-Id: <20220530134701.1935933-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 2203436a4d24302871617373a7eb21bc17e38762 ]

When removing the module, we will get the following warning:

[   14.746697] remove_proc_entry: removing non-empty directory 'irq/21', leaking at least 'cx25821[1]'
[   14.747449] WARNING: CPU: 4 PID: 368 at fs/proc/generic.c:717 remove_proc_entry+0x389/0x3f0
[   14.751611] RIP: 0010:remove_proc_entry+0x389/0x3f0
[   14.759589] Call Trace:
[   14.759792]  <TASK>
[   14.759975]  unregister_irq_proc+0x14c/0x170
[   14.760340]  irq_free_descs+0x94/0xe0
[   14.760640]  mp_unmap_irq+0xb6/0x100
[   14.760937]  acpi_unregister_gsi_ioapic+0x27/0x40
[   14.761334]  acpi_pci_irq_disable+0x1d3/0x320
[   14.761688]  pci_disable_device+0x1ad/0x380
[   14.762027]  ? _raw_spin_unlock_irqrestore+0x2d/0x60
[   14.762442]  ? cx25821_shutdown+0x20/0x9f0 [cx25821]
[   14.762848]  cx25821_finidev+0x48/0xc0 [cx25821]
[   14.763242]  pci_device_remove+0x92/0x240

Fix this by freeing the irq before call pci_disable_device().

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx25821/cx25821-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 44839a6461e8..534829e352d1 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1340,11 +1340,11 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 	struct cx25821_dev *dev = get_cx25821(v4l2_dev);
 
 	cx25821_shutdown(dev);
-	pci_disable_device(pci_dev);
 
 	/* unregister stuff */
 	if (pci_dev->irq)
 		free_irq(pci_dev->irq, dev);
+	pci_disable_device(pci_dev);
 
 	cx25821_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
-- 
2.35.1

