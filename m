Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3594714E0A
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfEFO6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbfEFOn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:43:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D818A20449;
        Mon,  6 May 2019 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153836;
        bh=BCJyrJQC8pq+NG1HUdcgLrXOxTCc40nsDQ/UkAV12WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsHUEMNb/LyOhV+nzrNVBm4TZhnaHzYl3lhUav/kUEuCV4edB0QixqVnXEFSjqye2
         2c5C8KNM8m4dy5Up4bBMg/mYl8q/GiefjappX9QRx1pM7Cbx2mK4kUcOoSHA+5QlYt
         9ESbv85Dgw7KGHFYzXNihBqCWyghDnTOOWq9wIZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.14 15/75] arm64: only advance singlestep for user instruction traps
Date:   Mon,  6 May 2019 16:32:23 +0200
Message-Id: <20190506143054.566908300@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 9478f1927e6ef9ef5e1ad761af1c98aa8e40b7f5 upstream.

Our arm64_skip_faulting_instruction() helper advances the userspace
singlestep state machine, but this is also called by the kernel BRK
handler, as used for WARN*().

Thus, if we happen to hit a WARN*() while the user singlestep state
machine is in the active-no-pending state, we'll advance to the
active-pending state without having executed a user instruction, and
will take a step exception earlier than expected when we return to
userspace.

Let's fix this by only advancing the state machine when skipping a user
instruction.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/traps.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -304,7 +304,8 @@ void arm64_skip_faulting_instruction(str
 	 * If we were single stepping, we want to get the step exception after
 	 * we return from the trap.
 	 */
-	user_fastforward_single_step(current);
+	if (user_mode(regs))
+		user_fastforward_single_step(current);
 }
 
 static LIST_HEAD(undef_hook);


