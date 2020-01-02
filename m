Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA0D12F02F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgABWvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbgABWY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F0D222C3;
        Thu,  2 Jan 2020 22:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003867;
        bh=pAVe+hWOgWyKDdn9K32HXdVAcd4Lp9YJCc37+Z+FiRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG4VUTZs/JQ45oJ9XrW/+vgSnB6E4t7mGZae7lTofLZoROnJTM62l52vQi6ILgLg6
         EyhvcrYPtRTQQZWfJNX6LxQcEqUkuBEAjWztlbP6MgQHkMvIyOJp2lyCQGA1FbOT/B
         cbWUK3RWgl1v8i1z/egdNq9jSfkpjOQJrpbHOrMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/91] powerpc/pseries: Mark accumulate_stolen_time() as notrace
Date:   Thu,  2 Jan 2020 23:06:51 +0100
Message-Id: <20200102220407.826536439@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit eb8e20f89093b64f48975c74ccb114e6775cee22 ]

accumulate_stolen_time() is called prior to interrupt state being
reconciled, which can trip the warning in arch_local_irq_restore():

  WARNING: CPU: 5 PID: 1017 at arch/powerpc/kernel/irq.c:258 .arch_local_irq_restore+0x9c/0x130
  ...
  NIP .arch_local_irq_restore+0x9c/0x130
  LR  .rb_start_commit+0x38/0x80
  Call Trace:
    .ring_buffer_lock_reserve+0xe4/0x620
    .trace_function+0x44/0x210
    .function_trace_call+0x148/0x170
    .ftrace_ops_no_ops+0x180/0x1d0
    ftrace_call+0x4/0x8
    .accumulate_stolen_time+0x1c/0xb0
    decrementer_common+0x124/0x160

For now just mark it as notrace. We may change the ordering to call it
after interrupt state has been reconciled, but that is a larger
change.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191024055932.27940-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 14f3f28a089e..66a9987dc0f8 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -241,7 +241,7 @@ static u64 scan_dispatch_log(u64 stop_tb)
  * Accumulate stolen time by scanning the dispatch trace log.
  * Called on entry from user mode.
  */
-void accumulate_stolen_time(void)
+void notrace accumulate_stolen_time(void)
 {
 	u64 sst, ust;
 	u8 save_soft_enabled = local_paca->soft_enabled;
-- 
2.20.1



