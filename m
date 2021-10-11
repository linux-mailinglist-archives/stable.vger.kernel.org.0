Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF25429019
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbhJKOFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238980AbhJKODD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29FB16108F;
        Mon, 11 Oct 2021 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960698;
        bh=GgDRqfBeQMUhgmLcfjsJRYdlUheZeSWZePX/uUDmz4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st4Fp/9zaw99rGn/ytx2lYkyYcPaDTqr/Xm4T4b8mRUrnPaeQ2OmvQTj9/9DQzc1+
         3VK/9qhbz/M2aqp5IFEd3rSzX+vduVAoNpMMt9SoVoPNdNa54wSYoEwLxDE6E8NlK7
         lfnoxFmKFcelQtzSmAK1bJ6ZRR0VS/CyX9czlmUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 050/151] xtensa: call irqchip_init only when CONFIG_USE_OF is selected
Date:   Mon, 11 Oct 2021 15:45:22 +0200
Message-Id: <20211011134519.473564831@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit 6489f8d0e1d93a3603d8dad8125797559e4cf2a2 ]

During boot time kernel configured with OF=y but USE_OF=n displays the
following warnings and hangs shortly after starting userspace:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/irq/irqdomain.c:695 irq_create_mapping_affinity+0x29/0xc0
irq_create_mapping_affinity(, 6) called with NULL domain
CPU: 0 PID: 0 Comm: swapper Not tainted 5.15.0-rc3-00001-gd67ed2510d28 #30
Call Trace:
  __warn+0x69/0xc4
  warn_slowpath_fmt+0x6c/0x94
  irq_create_mapping_affinity+0x29/0xc0
  local_timer_setup+0x40/0x88
  time_init+0xb1/0xe8
  start_kernel+0x31d/0x3f4
  _startup+0x13b/0x13b
---[ end trace 1e6630e1c5eda35b ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at arch/xtensa/kernel/time.c:141 local_timer_setup+0x58/0x88
error: can't map timer irq
CPU: 0 PID: 0 Comm: swapper Tainted: G        W         5.15.0-rc3-00001-gd67ed2510d28 #30
Call Trace:
  __warn+0x69/0xc4
  warn_slowpath_fmt+0x6c/0x94
  local_timer_setup+0x58/0x88
  time_init+0xb1/0xe8
  start_kernel+0x31d/0x3f4
  _startup+0x13b/0x13b
---[ end trace 1e6630e1c5eda35c ]---
Failed to request irq 0 (timer)

Fix that by calling irqchip_init only when CONFIG_USE_OF is selected and
calling legacy interrupt controller init otherwise.

Fixes: da844a81779e ("xtensa: add device trees support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index a48bf2d10ac2..80cc9770a8d2 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -145,7 +145,7 @@ unsigned xtensa_get_ext_irq_no(unsigned irq)
 
 void __init init_IRQ(void)
 {
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 	irqchip_init();
 #else
 #ifdef CONFIG_HAVE_SMP
-- 
2.33.0



