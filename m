Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89712EEE9C
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388384AbfKDWQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389781AbfKDWFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:05 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4C6205C9;
        Mon,  4 Nov 2019 22:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905105;
        bh=dZa1QclI7nmvnRW5lxGZ749Hnz0M0rK1zGRq3RTeM6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzUENApHlTGfHAjbOTw8C6JwbqkWqPmo9NYf7PD3xcizxFG3F+5ThewOfuZJVnix8
         DHteIZqKkjOqGTUonw3z48TdRiIo+EJPPBQWh6KOpb3eFFhnlK0saho5fPqKjJo280
         jtmCmuf9Ni6cS0Ft1Pa79+TZcuK5Dt/NIbEU9DEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 030/163] arm64: Fix incorrect irqflag restore for priority masking for compat
Date:   Mon,  4 Nov 2019 22:43:40 +0100
Message-Id: <20191104212142.477442421@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit f46f27a576cc3b1e3d45ea50bc06287aa46b04b2 ]

Commit bd82d4bd2188 ("arm64: Fix incorrect irqflag restore for priority
masking") added a macro to the entry.S call paths that leave the
PSTATE.I bit set. This tells the pPNMI masking logic that interrupts
are masked by the CPU, not by the PMR. This value is read back by
local_daif_save().

Commit bd82d4bd2188 added this call to el0_svc, as el0_svc_handler
is called with interrupts masked. el0_svc_compat was missed, but should
be covered in the same way as both of these paths end up in
el0_svc_common(), which expects to unmask interrupts.

Fixes: bd82d4bd2188 ("arm64: Fix incorrect irqflag restore for priority masking")
Signed-off-by: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 109894bd31948..239f6841a7412 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -775,6 +775,7 @@ el0_sync_compat:
 	b.ge	el0_dbg
 	b	el0_inv
 el0_svc_compat:
+	gic_prio_kentry_setup tmp=x1
 	mov	x0, sp
 	bl	el0_svc_compat_handler
 	b	ret_to_user
-- 
2.20.1



