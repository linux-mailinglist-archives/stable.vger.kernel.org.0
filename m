Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8819B1ED
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbgDAQjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389171AbgDAQjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:39:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13E5B20719;
        Wed,  1 Apr 2020 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759162;
        bh=zI1L8fWuxnVasn0HN2osMoOEJhb/uWGdUVBR50usJHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzpPFqYKXbJv/q6I2NMgp3/XTJKGlerhLJxcdV0qQXQfgPQD0w1WgHHAOg5BTw62e
         mgWYAlMY0u0Xlhute+Cbu6Wdm8qclqiWx4HjgvOxZKaj9UUg71nZTnQni79D2g49wQ
         dHdArfCjOFqiF7KdyyS2fU+k5KlAxP4Efy6DN44Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 097/102] locking/atomic, kref: Add kref_read()
Date:   Wed,  1 Apr 2020 18:18:40 +0200
Message-Id: <20200401161548.288744634@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 2c935bc57221cc2edc787c72ea0e2d30cdcd3d5e upstream.

Since we need to change the implementation, stop exposing internals.

Provide kref_read() to read the current reference count; typically
used for debug messages.

Kills two anti-patterns:

	atomic_read(&kref->refcount)
	kref->refcount.counter

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[only add kref_read() to kref.h for stable backports - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kref.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -33,6 +33,11 @@ static inline void kref_init(struct kref
 	atomic_set(&kref->refcount, 1);
 }
 
+static inline int kref_read(const struct kref *kref)
+{
+	return atomic_read(&kref->refcount);
+}
+
 /**
  * kref_get - increment refcount for object.
  * @kref: object.


