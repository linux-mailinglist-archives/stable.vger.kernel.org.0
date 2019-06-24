Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E255082E
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbfFXKEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbfFXKEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:04 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 090F3214DA;
        Mon, 24 Jun 2019 10:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370644;
        bh=D4RMN1f/DLIbKHDKcjd5wfl1Siuho9V4f9ky9WSofjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDIrh3z2ZzmXCXQ4itrJIpvY4NMkk58WDH2MCnj90vj7Ohv5jHwLOUiFc/pyiOiSg
         ZSHxphfUNvk1kbTEJiVGKX8S81FQ8bzyTOu+ln6H1UafP4H1F+GBa1U1Ffn0YixgY2
         4Bz4Cd9Mmff1UKsIkwvO6odN/njt6+yjAHUun2PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/90] parport: Fix mem leak in parport_register_dev_model
Date:   Mon, 24 Jun 2019 17:56:27 +0800
Message-Id: <20190624092316.732679453@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



