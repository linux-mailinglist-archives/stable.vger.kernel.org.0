Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D9E226639
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732526AbgGTQBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732523AbgGTQBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4968220684;
        Mon, 20 Jul 2020 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260882;
        bh=h7Ps1GgimivDdIJ4fXkDhfZKjiyw9iWrxOUCPcVj2Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnMSFV04fyoTgkOntES27n6QdIEObUU+HW3cEE+MF31M/6fwJb944NX4A5yTnPq9/
         LbEu6C69HZP6ia5142kKmLdG+JsQiWMX9NYFaD3hxCwBF/JXk1F/Pd8CWFhCt55wRN
         1T94DIcPwPWJnD1HaHl+NrvOHb/OABJCWCKvog/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/215] bus: ti-sysc: Fix wakeirq sleeping function called from invalid context
Date:   Mon, 20 Jul 2020 17:36:21 +0200
Message-Id: <20200720152824.919529936@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 9f9113925018d500a95df539014d9ff11ac2c02d ]

With CONFIG_DEBUG_ATOMIC_SLEEP enabled we can see the following with
wakeirqs and serial console idled:

BUG: sleeping function called from invalid context at drivers/bus/ti-sysc.c:242
...
(sysc_wait_softreset) from [<c0606894>] (sysc_enable_module+0x48/0x274)
(sysc_enable_module) from [<c0606c5c>] (sysc_runtime_resume+0x19c/0x1d8)
(sysc_runtime_resume) from [<c0606cf0>] (sysc_child_runtime_resume+0x58/0x84)
(sysc_child_runtime_resume) from [<c06eb7bc>] (__rpm_callback+0x30/0x12c)
(__rpm_callback) from [<c06eb8d8>] (rpm_callback+0x20/0x80)
(rpm_callback) from [<c06eb434>] (rpm_resume+0x638/0x7fc)
(rpm_resume) from [<c06eb658>] (__pm_runtime_resume+0x60/0x9c)
(__pm_runtime_resume) from [<c06edc08>] (handle_threaded_wake_irq+0x24/0x60)
(handle_threaded_wake_irq) from [<c01befec>] (irq_thread_fn+0x1c/0x78)
(irq_thread_fn) from [<c01bf30c>] (irq_thread+0x140/0x26c)

We have __pm_runtime_resume() call the sysc_runtime_resume() with spinlock
held and interrupts disabled.

Fixes: d46f9fbec719 ("bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index bb3e3310865bd..da586d75962fd 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -201,15 +201,14 @@ static int sysc_wait_softreset(struct sysc *ddata)
 		syss_done = ddata->cfg.syss_mask;
 
 	if (syss_offset >= 0) {
-		error = readx_poll_timeout(sysc_read_sysstatus, ddata, rstval,
-					   (rstval & ddata->cfg.syss_mask) ==
-					   syss_done,
-					   100, MAX_MODULE_SOFTRESET_WAIT);
+		error = readx_poll_timeout_atomic(sysc_read_sysstatus, ddata,
+				rstval, (rstval & ddata->cfg.syss_mask) ==
+				syss_done, 100, MAX_MODULE_SOFTRESET_WAIT);
 
 	} else if (ddata->cfg.quirks & SYSC_QUIRK_RESET_STATUS) {
-		error = readx_poll_timeout(sysc_read_sysconfig, ddata, rstval,
-					   !(rstval & sysc_mask),
-					   100, MAX_MODULE_SOFTRESET_WAIT);
+		error = readx_poll_timeout_atomic(sysc_read_sysconfig, ddata,
+				rstval, !(rstval & sysc_mask),
+				100, MAX_MODULE_SOFTRESET_WAIT);
 	}
 
 	return error;
-- 
2.25.1



