Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D678E13FFBE
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgAPXo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:44:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731489AbgAPXXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C795B2176D;
        Thu, 16 Jan 2020 23:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217018;
        bh=7XkkFiByh7e8tI6otoiNQUWOwsrLM1DR+5pw5Gn0nEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/7YMH2Q/Rs7ffqgRLLCtttka3hxiopVxmKSqpH4cJOY76ggEPtVDn3LxkjuMqI4+
         PuLWF3rXH/pE7AYkdyxQvKPuwurIRHGE8EzXajmbr9nCFlM+zOzWWF0Xy+FIXEmAuN
         OeRZsDr6gQ33jGPMm4he+euu3j4wIr8L2HQvyVOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.4 114/203] clk: Fix memory leak in clk_unregister()
Date:   Fri, 17 Jan 2020 00:17:11 +0100
Message-Id: <20200116231755.394698166@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 8247470772beb38822f226c99a2ed8c195f6b438 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3886,6 +3886,7 @@ void clk_unregister(struct clk *clk)
 					__func__, clk->core->name);
 
 	kref_put(&clk->core->ref, __clk_release);
+	free_clk(clk);
 unlock:
 	clk_prepare_unlock();
 }


