Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC562E682E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732503AbfJ0VYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbfJ0VYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:23 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 341E421783;
        Sun, 27 Oct 2019 21:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211462;
        bh=pi7SjfMWiAbPd0beiEK8YvY0VIwoPcp6zYc9P+qpbmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJao6HGx1lnM2/7oji2M9S3yr6vNQai4J4eOo/jVktFx2p9VQVRp2U49vtJ9VVYON
         TPwqgJMF/RrpXRXR4UdGMZBieyxk8bFDstLuTqvXknn4JqqeSD8H5W7BHBp3HrUZ47
         +WhWFwdsUDXhqks7MX+DuLpDDOgQ+2iR+GI5WFTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 5.3 160/197] lib/vdso: Make clock_getres() POSIX compliant again
Date:   Sun, 27 Oct 2019 22:01:18 +0100
Message-Id: <20191027203400.319408005@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 1638b8f096ca165965189b9626564c933c79fe63 upstream.

A recent commit removed the NULL pointer check from the clock_getres()
implementation causing a test case to fault.

POSIX requires an explicit NULL pointer check for clock_getres() aside of
the validity check of the clock_id argument for obscure reasons.

Add it back for both 32bit and 64bit.

Note, this is only a partial revert of the offending commit which does not
bring back the broken fallback invocation in the the 32bit compat
implementations of clock_getres() and clock_gettime().

Fixes: a9446a906f52 ("lib/vdso/32: Remove inconsistent NULL pointer checks")
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1910211202260.1904@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/vdso/gettimeofday.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -214,9 +214,10 @@ int __cvdso_clock_getres_common(clockid_
 		return -1;
 	}
 
-	res->tv_sec = 0;
-	res->tv_nsec = ns;
-
+	if (likely(res)) {
+		res->tv_sec = 0;
+		res->tv_nsec = ns;
+	}
 	return 0;
 }
 
@@ -245,7 +246,7 @@ __cvdso_clock_getres_time32(clockid_t cl
 		ret = clock_getres_fallback(clock, &ts);
 #endif
 
-	if (likely(!ret)) {
+	if (likely(!ret && res)) {
 		res->tv_sec = ts.tv_sec;
 		res->tv_nsec = ts.tv_nsec;
 	}


