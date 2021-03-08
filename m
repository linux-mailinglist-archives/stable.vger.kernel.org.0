Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEF4330E6F
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhCHMhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232511AbhCHMgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CE7265202;
        Mon,  8 Mar 2021 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207006;
        bh=3imioq9/hMi/mOcmhOxwjuyiPcBj34GxbBXKdvlXInI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLXey2bSpt0p6Cz05T1ek9RQ5yxmysRfNxE4c3ymp7ZWJptVvz83BhEyZMvl9K04+
         RsABv9ddSPUc6/K/ycoQ5tIqolGp60wReqhjXCfV4f6SsUk4mb3YtlxkD2aexbrUua
         2m5QLNSBVfq+d6myg1aga+u81GJFga6p3MUz8Xyo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyich@gmail.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 37/44] ia64: dont call handle_signal() unless theres actually a signal queued
Date:   Mon,  8 Mar 2021 13:35:15 +0100
Message-Id: <20210308122720.368163975@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f5f4fc4649ae542b1a25670b17aaf3cbb6187acc ]

Sergei and John both reported that ia64 failed to boot in 5.11, and it
was related to signals. Turns out the ia64 signal handling is a bit odd,
it doesn't check the return value of get_signal() for whether there's a
signal to deliver or not. With the introduction of TIF_NOTIFY_SIGNAL,
then task_work could trigger it.

Fix it by only calling handle_signal() if we actually have a real signal
to deliver. This brings it in line with all other archs, too.

Fixes: b269c229b0e8 ("ia64: add support for TIF_NOTIFY_SIGNAL")
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/signal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index e67b22fc3c60..c1b299760bf7 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -341,7 +341,8 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 	 * need to push through a forced SIGSEGV.
 	 */
 	while (1) {
-		get_signal(&ksig);
+		if (!get_signal(&ksig))
+			break;
 
 		/*
 		 * get_signal() may have run a debugger (via notify_parent())
-- 
2.30.1



