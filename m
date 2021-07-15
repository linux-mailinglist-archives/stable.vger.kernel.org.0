Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B033CAAF1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243487AbhGOTQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:16:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244604AbhGOTO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD42B613F3;
        Thu, 15 Jul 2021 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376234;
        bh=Db9BWr13IIhpMoNlTyg48YEuC4w/VdnvUhnVfdi8Q8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEKJIUa0lPbjysPaWYcdPbNJICWyJETgpI9KoybOa4de9isWGmWcKMM+o9rQM8u3h
         1htXhmbclzMGq6k5HOodaiI9jdGBv+aaq1BvBBGFqy6mQBQevjd5j7mk+g4lyt92eX
         HGqC502PVjZ17mfwV/JkM3EROc1PvEiooPjkP4T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Haren Myneni <haren@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 184/266] powerpc/powernv/vas: Release reference to tgid during window close
Date:   Thu, 15 Jul 2021 20:38:59 +0200
Message-Id: <20210715182643.896511000@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haren Myneni <haren@linux.ibm.com>

commit 91cdbb955aa94ee0841af4685be40937345d29b8 upstream.

The kernel handles the NX fault by updating CSB or sending
signal to process. In multithread applications, children can
open VAS windows and can exit without closing them. But the
parent can continue to send NX requests with these windows. To
prevent pid reuse, reference will be taken on pid and tgid
when the window is opened and release them during window close.

The current code is not releasing the tgid reference which can
cause pid leak and this patch fixes the issue.

Fixes: db1c08a740635 ("powerpc/vas: Take reference to PID and mm for user space windows")
Cc: stable@vger.kernel.org # 5.8+
Reported-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/6020fc4d444864fe20f7dcdc5edfe53e67480a1c.camel@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/vas-window.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -1093,9 +1093,9 @@ struct vas_window *vas_tx_win_open(int v
 		/*
 		 * Process closes window during exit. In the case of
 		 * multithread application, the child thread can open
-		 * window and can exit without closing it. Expects parent
-		 * thread to use and close the window. So do not need
-		 * to take pid reference for parent thread.
+		 * window and can exit without closing it. so takes tgid
+		 * reference until window closed to make sure tgid is not
+		 * reused.
 		 */
 		txwin->tgid = find_get_pid(task_tgid_vnr(current));
 		/*
@@ -1339,8 +1339,9 @@ int vas_win_close(struct vas_window *win
 	/* if send window, drop reference to matching receive window */
 	if (window->tx_win) {
 		if (window->user_win) {
-			/* Drop references to pid and mm */
+			/* Drop references to pid. tgid and mm */
 			put_pid(window->pid);
+			put_pid(window->tgid);
 			if (window->mm) {
 				mm_context_remove_vas_window(window->mm);
 				mmdrop(window->mm);


