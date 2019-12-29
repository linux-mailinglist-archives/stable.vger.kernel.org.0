Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41512C79F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbfL2Ro2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbfL2Ro1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BEE4206A4;
        Sun, 29 Dec 2019 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641466;
        bh=took2yfc10mwJIiU++wtfnWQRRM24oPstclwKzoQDaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLvPVA5ikYoeTdWAMjKchdvwed3BP5MKcMB+CXtHjnehG/O485NtQKofD5euUFzR0
         ZZgD/qYDqDoIEAebRVRaxaQ5q7EyiqSJR6FI2am9y1HmW9EvPnQoTglKC1WdTLXybi
         5iRRYmzf4uS1tvoQbWPA4VK0XaK8FTmidA1wU+w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/434] media: vim2m: Fix BUG_ON in vim2m_device_release()
Date:   Sun, 29 Dec 2019 18:22:11 +0100
Message-Id: <20191229172706.793607964@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 2455d417c03aa0cbafed04c46cbb354643238318 ]

If v4l2_m2m_init() fails, m2m_dev pointer will be set ERR_PTR(-ENOMEM),
then kfree m2m_dev will trigger BUG_ON, see below, fix it by setting m2m_dev
to NULL.

  vim2m vim2m.0: Failed to init mem2mem device
  ------------[ cut here ]------------
  kernel BUG at mm/slub.c:3944!
  invalid opcode: 0000 [#1] SMP PTI
  CPU: 11 PID: 9061 Comm: insmod Tainted: G            E     5.2.0-rc2 #81
  Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
  RIP: 0010:kfree+0x11a/0x160

  Call Trace:
   vim2m_device_release+0x3f/0x50 [vim2m]
   device_release+0x27/0x80
   kobject_release+0x68/0x190
   vim2m_probe+0x20f/0x280 [vim2m]
   platform_drv_probe+0x37/0x90
   really_probe+0xef/0x3d0
   driver_probe_device+0x110/0x120
   device_driver_attach+0x4f/0x60
   __driver_attach+0x9a/0x140
   ? device_driver_attach+0x60/0x60
   bus_for_each_dev+0x76/0xc0
   ? klist_add_tail+0x57/0x70
   bus_add_driver+0x141/0x210
   driver_register+0x5b/0xe0
   vim2m_init+0x29/0x1000 [vim2m]
   do_one_initcall+0x46/0x1f4
   ? __slab_alloc+0x1c/0x30
   ? kmem_cache_alloc_trace+0x167/0x1b0
   do_init_module+0x5b/0x21f
   load_module+0x1add/0x1fb0
   ? __do_sys_finit_module+0xe9/0x110
   __do_sys_finit_module+0xe9/0x110
   do_syscall_64+0x5b/0x1c0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: ea6c7e34f3b2 ("media: vim2m: replace devm_kzalloc by kzalloc")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 2d79cdc130c5..e17792f837f8 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1346,6 +1346,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->m2m_dev)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(dev->m2m_dev);
+		dev->m2m_dev = NULL;
 		goto error_dev;
 	}
 
-- 
2.20.1



