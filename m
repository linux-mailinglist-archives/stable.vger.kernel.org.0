Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5C419B3A8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgDAQwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388283AbgDAQdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:33:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22EF120658;
        Wed,  1 Apr 2020 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758825;
        bh=zI1L8fWuxnVasn0HN2osMoOEJhb/uWGdUVBR50usJHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUT3xlbxXxI21O+OXBBVZukXKHsz9beg/darQMDeA5iNrfXVtT7ZTG6ZDw3x6Y8+Y
         VhjA7+bakiKJJ4RCXDugsA8u1Ru1n0opFkpSVo/IRdpQCPcmbVCNxHJI77ejYC+e2C
         dGmXT+CJm6b5suAakucdSTmlqqcglRGzJ9QRvb4I=
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
Subject: [PATCH 4.4 87/91] locking/atomic, kref: Add kref_read()
Date:   Wed,  1 Apr 2020 18:18:23 +0200
Message-Id: <20200401161539.844562724@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161512.917494101@linuxfoundation.org>
References: <20200401161512.917494101@linuxfoundation.org>
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


