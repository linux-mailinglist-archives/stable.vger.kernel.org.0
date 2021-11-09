Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E929644A358
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243060AbhKIB0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243506AbhKIBXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F77C61A65;
        Tue,  9 Nov 2021 01:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420146;
        bh=YU2DXVZ+7h37o9JM5RlfJzMMJWMvl2Iw7jDeJIdyAxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFK2vAYGwyo7ouQhiN9j8Al+WO2xlzOLBlazdC0ag9om7D5BIb1VAN2CXDtRGS1b2
         MJKhB399Oc45cgNwqdu2wtAC6IcOkJLV9QyqtlDovxEUGULNPJiDLQTUVMaUrm95W2
         ZYtmwgh/AlWOWxjoo91yU72gk+KGjU9YyqQqSCy4ga4UuXcA87S6yXDGpuoigdwu8J
         gAVqYCVhRoY57cYfnP3XjYs7P5QmIJkNS9CmF5s8H1fWOqROcGy94AC6/upQn8oL49
         Qzudmfmtv0re7m77lHoNA2ckvCaVPbUNGCZ7FH8JWyEY9bZYMBtsgMRWaEpmxqVNcS
         WJOAqk1+chY/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        nathan@kernel.org, linux-arm-kernel@lists.infradead.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 29/33] ARM: clang: Do not rely on lr register for stacktrace
Date:   Mon,  8 Nov 2021 20:08:03 -0500
Message-Id: <20211109010807.1191567-29-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit b3ea5d56f212ad81328c82454829a736197ebccc ]

Currently the stacktrace on clang compiled arm kernel uses the 'lr'
register to find the first frame address from pt_regs. However, that
is wrong after calling another function, because the 'lr' register
is used by 'bl' instruction and never be recovered.

As same as gcc arm kernel, directly use the frame pointer (r11) of
the pt_regs to find the first frame address.

Note that this fixes kretprobe stacktrace issue only with
CONFIG_UNWINDER_FRAME_POINTER=y. For the CONFIG_UNWINDER_ARM,
we need another fix.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/stacktrace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 6e8a50de40e2b..c10c1de244eba 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -51,8 +51,7 @@ int notrace unwind_frame(struct stackframe *frame)
 
 	frame->sp = frame->fp;
 	frame->fp = *(unsigned long *)(fp);
-	frame->pc = frame->lr;
-	frame->lr = *(unsigned long *)(fp + 4);
+	frame->pc = *(unsigned long *)(fp + 4);
 #else
 	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
-- 
2.33.0

