Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9BE46ABE
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfFNU3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbfFNU3A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:00 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCC021850;
        Fri, 14 Jun 2019 20:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544140;
        bh=DkwTj3lGy+62IaL5sUSt22R/GkKUGMOQMc62lTrrUjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcH/ToUZ1UIIL4mXEmxV1+GXMxxyxkcScWFsWF/rx/ti2K7L31AU3uegRpej1uujn
         BQ1j/pDSxs1bv/FrTnaJT7/R2YRFGC9mqIVnUDzfSXQlY0XwGNL32LKCf5EQqb9OM4
         QsO4gY04Xq7stZT3jWZPtlvCos6fUIhlBhRM2zX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 18/59] parport: Fix mem leak in parport_register_dev_model
Date:   Fri, 14 Jun 2019 16:28:02 -0400
Message-Id: <20190614202843.26941-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 1c7ebeabc9e5ee12e42075a597de40fdb9059530 ]

BUG: memory leak
unreferenced object 0xffff8881df48cda0 (size 16):
  comm "syz-executor.0", pid 5077, jiffies 4295994670 (age 22.280s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d2d0d5fe>] parport_register_dev_model+0x141/0x6e0 [parport]
    [<00000000782f6dab>] 0xffffffffc15d1196
    [<00000000d2ca6ae4>] platform_drv_probe+0x7e/0x100
    [<00000000628c2a94>] really_probe+0x342/0x4d0
    [<000000006874f5da>] driver_probe_device+0x8c/0x170
    [<00000000424de37a>] __device_attach_driver+0xda/0x100
    [<000000002acab09a>] bus_for_each_drv+0xfe/0x170
    [<000000003d9e5f31>] __device_attach+0x190/0x230
    [<0000000035d32f80>] bus_probe_device+0x123/0x140
    [<00000000a05ba627>] device_add+0x7cc/0xce0
    [<000000003f7560bf>] platform_device_add+0x230/0x3c0
    [<000000002a0be07d>] 0xffffffffc15d0949
    [<000000007361d8d2>] port_check+0x3b/0x50 [parport]
    [<000000004d67200f>] bus_for_each_dev+0x115/0x180
    [<000000003ccfd11c>] __parport_register_driver+0x1f0/0x210 [parport]
    [<00000000987f06fc>] 0xffffffffc15d803e

After commit 4e5a74f1db8d ("parport: Revert "parport: fix
memory leak""), free_pardevice do not free par_dev->state,
we should free it in error path of parport_register_dev_model
before return.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 4e5a74f1db8d ("parport: Revert "parport: fix memory leak"")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/share.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index 5dc53d420ca8..7b4ee33c1935 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -895,6 +895,7 @@ parport_register_dev_model(struct parport *port, const char *name,
 	par_dev->devmodel = true;
 	ret = device_register(&par_dev->dev);
 	if (ret) {
+		kfree(par_dev->state);
 		put_device(&par_dev->dev);
 		goto err_put_port;
 	}
@@ -912,6 +913,7 @@ parport_register_dev_model(struct parport *port, const char *name,
 			spin_unlock(&port->physport->pardevice_lock);
 			pr_debug("%s: cannot grant exclusive access for device %s\n",
 				 port->name, name);
+			kfree(par_dev->state);
 			device_unregister(&par_dev->dev);
 			goto err_put_port;
 		}
-- 
2.20.1

