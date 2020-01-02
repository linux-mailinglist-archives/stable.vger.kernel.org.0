Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDE12F17A
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgABXAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 18:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgABWM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C6822314;
        Thu,  2 Jan 2020 22:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003146;
        bh=TGGxvAo+S16GT7ah/Ubi13LJFJ8SAp4fVF9vbI6BQ7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1pGZxu4gwA9h6iHv1I0laEF9TNJoLAH4fZwZsHY891KwxoUEUxLTvP1sf3GGW7Jw
         R7mVMY/QCMx20u6mW/1+yKANw6Zuu7NwIJjQsbxtB6eFHuhdo5kRP5tpfpYhtf65vM
         lEJrAmf8kP4ZrrqG67NZKvARrKegmtmietyiC0DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/191] selftests/powerpc: Skip tm-signal-sigreturn-nt if TM not available
Date:   Thu,  2 Jan 2020 23:05:21 +0100
Message-Id: <20200102215834.138393477@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 56fbf9f6bbf3..07c388147b75 100644
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



