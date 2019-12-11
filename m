Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE5211B751
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbfLKQHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:07:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731158AbfLKPMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D301222C4;
        Wed, 11 Dec 2019 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077151;
        bh=JTsTVhsy3zqt1vTyRg8yc3o1dJloENyZSI0v+uOIwYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YC9de2q1X4n4uZtwfb+egEwTr7gSXTfrP0FvriM7TaAYdCtORBAuQIdP0aTfhpwXF
         RYMQl+/fbcXsQZhtpZvxPk0kazMOAx6CMzwSer1y6WdjdLGClDBDtGG23XapfgBCnr
         PiJhkLz6LOfDEjntb9/E/y0ACm8CShNmrhUOfeTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 038/134] selftests/powerpc: Skip tm-signal-sigreturn-nt if TM not available
Date:   Wed, 11 Dec 2019 10:10:14 -0500
Message-Id: <20191211151150.19073-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 505127068d9b705a6cf335143239db91bfe7bbe2 ]

On systems where TM (Transactional Memory) is disabled the
tm-signal-sigreturn-nt test causes a SIGILL:

  test: tm_signal_sigreturn_nt
  tags: git_version:7c202575ef63
  !! child died by signal 4
  failure: tm_signal_sigreturn_nt

We should skip the test if TM is not available.

Fixes: 34642d70ac7e ("selftests/powerpc: Add checks for transactional sigreturn")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104233524.24348-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c b/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c
index 56fbf9f6bbf30..07c388147b75e 100644
--- a/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c
+++ b/tools/testing/selftests/powerpc/tm/tm-signal-sigreturn-nt.c
@@ -10,10 +10,12 @@
  */
 
 #define _GNU_SOURCE
+#include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
 
 #include "utils.h"
+#include "tm.h"
 
 void trap_signal_handler(int signo, siginfo_t *si, void *uc)
 {
@@ -29,6 +31,8 @@ int tm_signal_sigreturn_nt(void)
 {
 	struct sigaction trap_sa;
 
+	SKIP_IF(!have_htm());
+
 	trap_sa.sa_flags = SA_SIGINFO;
 	trap_sa.sa_sigaction = trap_signal_handler;
 
-- 
2.20.1

