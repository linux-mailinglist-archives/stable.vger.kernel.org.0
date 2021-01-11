Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33A2F1C5B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389497AbhAKR3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:29:35 -0500
Received: from aposti.net ([89.234.176.197]:36546 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388882AbhAKR3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:29:35 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        stable@vger.kernel.org
Subject: [PATCH] seccomp: Add missing return in non-void function
Date:   Mon, 11 Jan 2021 17:28:39 +0000
Message-Id: <20210111172839.640914-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We don't actually care about the value, since the kernel will panic
before that; but a value should nonetheless be returned, otherwise the
compiler will complain.

Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
Cc: stable@vger.kernel.org # 4.7+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 kernel/seccomp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 952dc1c90229..63b40d12896b 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1284,6 +1284,8 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 			    const bool recheck_after_trace)
 {
 	BUG();
+
+	return -1;
 }
 #endif
 
-- 
2.29.2

