Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E674373A82
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhEEMLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232835AbhEEMJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90F9613F6;
        Wed,  5 May 2021 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216488;
        bh=J+pkQqcLR08+eXI1pASlQjdsDhzLZeLxRxcH8lffClA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNWhdTbvqle6e2T/i4xVS8m5sBRSjYOPWhEKbP7VH8nZlbYYXuh9U3pyuAKoAEyMt
         uAEYBAPa4+uLnTTGuPoEocRryewZz9TDxTU/Skx1MgY3MAzOMMzDuEjh3BB0nliADh
         lkUH/kDSyDQRW8QEX3b4kvk5lE62eO9ILo8LDb3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.12 17/17] perf/core: Fix unconditional security_locked_down() call
Date:   Wed,  5 May 2021 14:06:12 +0200
Message-Id: <20210505112325.509270181@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 08ef1af4de5fe7de9c6d69f1e22e51b66e385d9b upstream.

Currently, the lockdown state is queried unconditionally, even though
its result is used only if the PERF_SAMPLE_REGS_INTR bit is set in
attr.sample_type. While that doesn't matter in case of the Lockdown LSM,
it causes trouble with the SELinux's lockdown hook implementation.

SELinux implements the locked_down hook with a check whether the current
task's type has the corresponding "lockdown" class permission
("integrity" or "confidentiality") allowed in the policy. This means
that calling the hook when the access control decision would be ignored
generates a bogus permission check and audit record.

Fix this by checking sample_type first and only calling the hook when
its result would be honored.

Fixes: b0c8fdc7fdb7 ("lockdown: Lock down perf when in confidentiality mode")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Link: https://lkml.kernel.org/r/20210224215628.192519-1-omosnace@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11829,12 +11829,12 @@ SYSCALL_DEFINE5(perf_event_open,
 			return err;
 	}
 
-	err = security_locked_down(LOCKDOWN_PERF);
-	if (err && (attr.sample_type & PERF_SAMPLE_REGS_INTR))
-		/* REGS_INTR can leak data, lockdown must prevent this */
-		return err;
-
-	err = 0;
+	/* REGS_INTR can leak data, lockdown must prevent this */
+	if (attr.sample_type & PERF_SAMPLE_REGS_INTR) {
+		err = security_locked_down(LOCKDOWN_PERF);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * In cgroup mode, the pid argument is used to pass the fd


