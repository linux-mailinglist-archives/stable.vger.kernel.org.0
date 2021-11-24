Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4808145C69F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354562AbhKXOKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352162AbhKXOIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:08:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D2A61A8F;
        Wed, 24 Nov 2021 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759581;
        bh=bg7a5XaN1mQspZcAuSdnAS6T2vaFtb3kuZ/x5E0ZJfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHE4IaqVruosYfNlQ/h0cOUlr2O+5saPKruldNBezqvHVXqVbDxL873rKT9v9ho3w
         cHcVqdnCTaKM95lRm+/fQi4e/YElDoMd4oZvYHDe0e8vbrvtdnYkiXODqTVY8m4IDn
         AlilLZmFll7j5GcWuCyAIRLte++txjyHdTHfWaQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 260/279] signal/sparc32: Exit with a fatal signal when try_to_clear_window_buffer fails
Date:   Wed, 24 Nov 2021 12:59:07 +0100
Message-Id: <20211124115727.702541074@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit c317d306d55079525c9610267fdaf3a8a6d2f08b upstream.

The function try_to_clear_window_buffer is only called from
rtrap_32.c.  After it is called the signal pending state is retested,
and signals are handled if TIF_SIGPENDING is set.  This allows
try_to_clear_window_buffer to call force_fatal_signal and then rely on
the signal being delivered to kill the process, without any danger of
returning to userspace, or otherwise using possible corrupt state on
failure.

The functional difference between force_fatal_sig and do_exit is that
do_exit will only terminate a single thread, and will never trigger a
core-dump.  A multi-threaded program for which a single thread
terminates unexpectedly is hard to reason about.  Calling force_fatal_sig
does not give userspace a chance to catch the signal, but otherwise
is an ordinary fatal signal exit, and it will trigger a coredump
of the offending process if core dumps are enabled.

Cc: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Link: https://lkml.kernel.org/r/20211020174406.17889-15-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/windows.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/windows.c
+++ b/arch/sparc/kernel/windows.c
@@ -121,8 +121,10 @@ void try_to_clear_window_buffer(struct p
 
 		if ((sp & 7) ||
 		    copy_to_user((char __user *) sp, &tp->reg_window[window],
-				 sizeof(struct reg_window32)))
-			do_exit(SIGILL);
+				 sizeof(struct reg_window32))) {
+			force_fatal_sig(SIGILL);
+			return;
+		}
 	}
 	tp->w_saved = 0;
 }


