Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D63111FDB
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfLCWjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbfLCWjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC3ED2073C;
        Tue,  3 Dec 2019 22:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412776;
        bh=evPbkcsov7YSCiEHsYu8yJYE3b6iC/HezEAed6gzsj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqbeLXwP05GDyCoTcgmJxopnn75XZcVzdx245oua4ZVX+Xm916Vx8NtVpUwdztKYq
         Owa9XRsPJ8viD3l1CelPOuVSop3rUy4y2B5EcvwBwL9zuu2cob2kXZH3ATWvNY8Vxz
         nRJ92YpoSHlQhsMNVAtnHRhan/5kID83V6anwCXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 013/135] reset: Fix memory leak in reset_control_array_put()
Date:   Tue,  3 Dec 2019 23:34:13 +0100
Message-Id: <20191203213008.064783486@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 532f9cd6ee994ed10403e856ca27501428048597 ]

Memory allocated for 'struct reset_control_array' in
of_reset_control_array_get() is never freed in
reset_control_array_put() resulting in kmemleak showing
the following backtrace.

  backtrace:
    [<00000000c5f17595>] __kmalloc+0x1b0/0x2b0
    [<00000000bd499e13>] of_reset_control_array_get+0xa4/0x180
    [<000000004cc02754>] 0xffff800008c669e4
    [<0000000050a83b24>] platform_drv_probe+0x50/0xa0
    [<00000000d3a0b0bc>] really_probe+0x108/0x348
    [<000000005aa458ac>] driver_probe_device+0x58/0x100
    [<000000008853626c>] device_driver_attach+0x6c/0x90
    [<0000000085308d19>] __driver_attach+0x84/0xc8
    [<00000000080d35f2>] bus_for_each_dev+0x74/0xc8
    [<00000000dd7f015b>] driver_attach+0x20/0x28
    [<00000000923ba6e6>] bus_add_driver+0x148/0x1f0
    [<0000000061473b66>] driver_register+0x60/0x110
    [<00000000c5bec167>] __platform_driver_register+0x40/0x48
    [<000000007c764b4f>] 0xffff800008c6c020
    [<0000000047ec2e8c>] do_one_initcall+0x5c/0x1b0
    [<0000000093d4b50d>] do_init_module+0x54/0x1d0

Fixes: 17c82e206d2a ("reset: Add APIs to manage array of resets")
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 213ff40dda110..36b1ff69b1e2a 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -748,6 +748,7 @@ static void reset_control_array_put(struct reset_control_array *resets)
 	for (i = 0; i < resets->num_rstcs; i++)
 		__reset_control_put_internal(resets->rstc[i]);
 	mutex_unlock(&reset_list_mutex);
+	kfree(resets);
 }
 
 /**
-- 
2.20.1



