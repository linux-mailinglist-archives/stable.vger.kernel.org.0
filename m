Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F9254844E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 12:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241375AbiFMKOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241401AbiFMKOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:14:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D499BF7A;
        Mon, 13 Jun 2022 03:14:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2468CE1163;
        Mon, 13 Jun 2022 10:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989F0C34114;
        Mon, 13 Jun 2022 10:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115267;
        bh=Pc6AH3aNje77UUx9oth6RMHG9z01vE/DhvECuLUn6TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GCGSStYIUHp9QnNwmqibBPCt9abCqAmF6z+9swjwNUWBhKb8iE+CXv36B1l8wkpC
         xxpdizmsvO6/Xd09BWvdz9fqRx/qdZPs5Ak2Xp67ulIgOnkCwnK+RSiA8ORuC/Yutn
         UaGq7+6kyns8iMyR8uK146uTea95pDOYVk4PgBZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 014/167] media: cx25821: Fix the warning when removing the module
Date:   Mon, 13 Jun 2022 12:08:08 +0200
Message-Id: <20220613094844.204109813@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d58c58e61bde..acd896ca1339 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1354,11 +1354,11 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
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



