Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A052D767CD
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfGZNkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbfGZNkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47FB622BF5;
        Fri, 26 Jul 2019 13:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148406;
        bh=iRNqSiuw0WWltpKRN5X7jUlnCo+TpcQGXiHSgh5eqMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+BZ9qO3HO3Lv+2S1zOxKsRWPrk2zCm93HAagGr/eJJN7r5xAIZvHT83Bva7RN/S5
         sVRMKhd4gdnMh52/No96VpnxSWUj9nelRpUqQpNQg+Pyc4wNTil0vUyh5mc9SjZQRc
         XhSrT0zK8H1fTq2+xGRpixzfrACKqP+9+ykCm7MI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 16/85] soc: imx8: Fix potential kernel dump in error path
Date:   Fri, 26 Jul 2019 09:38:26 -0400
Message-Id: <20190726133936.11177-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 1bcbe7300815e91fef18ee905b04f65490ad38c9 ]

When SoC's revision value is 0, SoC driver will print out
"unknown" in sysfs's revision node, this "unknown" is a
static string which can NOT be freed, this will caused below
kernel dump in later error path which calls kfree:

kernel BUG at mm/slub.c:3942!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.2.0-rc4-next-20190611-00023-g705146c-dirty #2197
Hardware name: NXP i.MX8MQ EVK (DT)
pstate: 60000005 (nZCv daif -PAN -UAO)
pc : kfree+0x170/0x1b0
lr : imx8_soc_init+0xc0/0xe4
sp : ffff00001003bd10
x29: ffff00001003bd10 x28: ffff00001121e0a0
x27: ffff000011482000 x26: ffff00001117068c
x25: ffff00001121e100 x24: ffff000011482000
x23: ffff000010fe2b58 x22: ffff0000111b9ab0
x21: ffff8000bd9dfba0 x20: ffff0000111b9b70
x19: ffff7e000043f880 x18: 0000000000001000
x17: ffff000010d05fa0 x16: ffff0000122e0000
x15: 0140000000000000 x14: 0000000030360000
x13: ffff8000b94b5bb0 x12: 0000000000000038
x11: ffffffffffffffff x10: ffffffffffffffff
x9 : 0000000000000003 x8 : ffff8000b9488147
x7 : ffff00001003bc00 x6 : 0000000000000000
x5 : 0000000000000003 x4 : 0000000000000003
x3 : 0000000000000003 x2 : b8793acd604edf00
x1 : ffff7e000043f880 x0 : ffff7e000043f888
Call trace:
 kfree+0x170/0x1b0
 imx8_soc_init+0xc0/0xe4
 do_one_initcall+0x58/0x1b8
 kernel_init_freeable+0x1cc/0x288
 kernel_init+0x10/0x100
 ret_from_fork+0x10/0x18

This patch fixes this potential kernel dump when a chip's
revision is "unknown", it is done by checking whether the
revision space can be freed.

Fixes: a7e26f356ca1 ("soc: imx: Add generic i.MX8 SoC driver")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/soc-imx8.c b/drivers/soc/imx/soc-imx8.c
index e567d866a9d3..79a3d922a4a9 100644
--- a/drivers/soc/imx/soc-imx8.c
+++ b/drivers/soc/imx/soc-imx8.c
@@ -112,7 +112,8 @@ static int __init imx8_soc_init(void)
 	return 0;
 
 free_rev:
-	kfree(soc_dev_attr->revision);
+	if (strcmp(soc_dev_attr->revision, "unknown"))
+		kfree(soc_dev_attr->revision);
 free_soc:
 	kfree(soc_dev_attr);
 	of_node_put(root);
-- 
2.20.1

