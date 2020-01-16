Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AB813F8E6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgAPQxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731087AbgAPQxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC02E21D56;
        Thu, 16 Jan 2020 16:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193618;
        bh=RZLN/GyyfS05oYGs4sRibs4loKFtEY5puOXxElSy0q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffNMgf9zpdJRdM7DtbPSWDc0JFO0i1lWuH/GRM6wYKFD15PSYkF+8fE3QJIwiBVCV
         mynThaUIl0ZMWgo4Cp+OmD38T8+ES+1PWlWX8WAG4dvX5HsZdVhCLxZdpVGN6pyvwV
         vm4LqMUePQKvrQlzTUwdipe34Sowrx3XwOzi93iw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 154/205] clk: Fix memory leak in clk_unregister()
Date:   Thu, 16 Jan 2020 11:42:09 -0500
Message-Id: <20200116164300.6705-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 8247470772beb38822f226c99a2ed8c195f6b438 ]

Memory allocated in alloc_clk() for 'struct clk' and
'const char *con_id' while invoking clk_register() is never freed
in clk_unregister(), resulting in kmemleak showing the following
backtrace.

  backtrace:
    [<00000000546f5dd0>] kmem_cache_alloc+0x18c/0x270
    [<0000000073a32862>] alloc_clk+0x30/0x70
    [<0000000082942480>] __clk_register+0xc8/0x760
    [<000000005c859fca>] devm_clk_register+0x54/0xb0
    [<00000000868834a8>] 0xffff800008c60950
    [<00000000d5a80534>] platform_drv_probe+0x50/0xa0
    [<000000001b3889fc>] really_probe+0x108/0x348
    [<00000000953fa60a>] driver_probe_device+0x58/0x100
    [<0000000008acc17c>] device_driver_attach+0x6c/0x90
    [<0000000022813df3>] __driver_attach+0x84/0xc8
    [<00000000448d5443>] bus_for_each_dev+0x74/0xc8
    [<00000000294aa93f>] driver_attach+0x20/0x28
    [<00000000e5e52626>] bus_add_driver+0x148/0x1f0
    [<000000001de21efc>] driver_register+0x60/0x110
    [<00000000af07c068>] __platform_driver_register+0x40/0x48
    [<0000000060fa80ee>] 0xffff800008c66020

Fix it here.

Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lkml.kernel.org/r/20191022071153.21118-1-kishon@ti.com
Fixes: 1df4046a93e0 ("clk: Combine __clk_get() and __clk_create_clk()")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 27a95c86a80b..4fc294c2f9e8 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3886,6 +3886,7 @@ void clk_unregister(struct clk *clk)
 					__func__, clk->core->name);
 
 	kref_put(&clk->core->ref, __clk_release);
+	free_clk(clk);
 unlock:
 	clk_prepare_unlock();
 }
-- 
2.20.1

