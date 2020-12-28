Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6714D2E3F86
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502540AbgL1Okz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502473AbgL1O2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EC620739;
        Mon, 28 Dec 2020 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165676;
        bh=I2cXp1MT7EnjWf0cayzQn7ATh5TaaXPWvohR2tD1TEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIyHc9ydFlRa5c3HJw5tMWNJGex/n4zECohOuI4cGQ7Lp8VEs5O7nbkgGP0JC2TFk
         3Vnc+dF0JlsnzDtNMNW0HZGGn7NzAeQbqB8fh6fYCVY6rdIzJS8WyK4dX5lUZhU/Iq
         kWB1DMI8CwtMu1y251pP3Zm7YyokcrWzG9xI+U+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 574/717] Documentation: seqlock: s/LOCKTYPE/LOCKNAME/g
Date:   Mon, 28 Dec 2020 13:49:32 +0100
Message-Id: <20201228125048.421617679@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

commit cf48647243cc28d15280600292db5777592606c5 upstream.

Sequence counters with an associated write serialization lock are called
seqcount_LOCKNAME_t. Fix the documentation accordingly.

While at it, remove a paragraph that inappropriately discussed a
seqlock.h implementation detail.

Fixes: 6dd699b13d53 ("seqlock: seqcount_LOCKNAME_t: Standardize naming convention")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201206162143.14387-2-a.darwish@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/locking/seqlock.rst |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/Documentation/locking/seqlock.rst
+++ b/Documentation/locking/seqlock.rst
@@ -89,7 +89,7 @@ Read path::
 
 .. _seqcount_locktype_t:
 
-Sequence counters with associated locks (``seqcount_LOCKTYPE_t``)
+Sequence counters with associated locks (``seqcount_LOCKNAME_t``)
 -----------------------------------------------------------------
 
 As discussed at :ref:`seqcount_t`, sequence count write side critical
@@ -115,27 +115,26 @@ The following sequence counters with ass
   - ``seqcount_mutex_t``
   - ``seqcount_ww_mutex_t``
 
-The plain seqcount read and write APIs branch out to the specific
-seqcount_LOCKTYPE_t implementation at compile-time. This avoids kernel
-API explosion per each new seqcount LOCKTYPE.
+The sequence counter read and write APIs can take either a plain
+seqcount_t or any of the seqcount_LOCKNAME_t variants above.
 
-Initialization (replace "LOCKTYPE" with one of the supported locks)::
+Initialization (replace "LOCKNAME" with one of the supported locks)::
 
 	/* dynamic */
-	seqcount_LOCKTYPE_t foo_seqcount;
-	seqcount_LOCKTYPE_init(&foo_seqcount, &lock);
+	seqcount_LOCKNAME_t foo_seqcount;
+	seqcount_LOCKNAME_init(&foo_seqcount, &lock);
 
 	/* static */
-	static seqcount_LOCKTYPE_t foo_seqcount =
-		SEQCNT_LOCKTYPE_ZERO(foo_seqcount, &lock);
+	static seqcount_LOCKNAME_t foo_seqcount =
+		SEQCNT_LOCKNAME_ZERO(foo_seqcount, &lock);
 
 	/* C99 struct init */
 	struct {
-		.seq   = SEQCNT_LOCKTYPE_ZERO(foo.seq, &lock),
+		.seq   = SEQCNT_LOCKNAME_ZERO(foo.seq, &lock),
 	} foo;
 
 Write path: same as in :ref:`seqcount_t`, while running from a context
-with the associated LOCKTYPE lock acquired.
+with the associated write serialization lock acquired.
 
 Read path: same as in :ref:`seqcount_t`.
 


