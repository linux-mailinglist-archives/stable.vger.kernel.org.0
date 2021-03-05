Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E5932E8B3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhCEM20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCEM14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:27:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A08A565053;
        Fri,  5 Mar 2021 12:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947276;
        bh=1nkAT+pDs7vToMv9eZRpsXbFF0+6IX42fVlJ2vLv7nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+1Y9mRI9/em122LnsT8rFM1MTnJjNMfTWiXn+srUUqWh1oR5+IZQanearoL29god
         oGRv0Ni/AbpBS2AaFSfG3JOGgkO70y6BdeVnFm5rUV1F4SLAofhn/McU9PtG185k7z
         rqIbZqCONzRp3eyeZk1DDxhIcNgBGYRDOa0oySaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 096/104] tty: fix up iterate_tty_read() EOVERFLOW handling
Date:   Fri,  5 Mar 2021 13:21:41 +0100
Message-Id: <20210305120907.879395756@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e71a8d5cf4b4f274740e31b601216071e2a11afa upstream.

When I converted the tty_ldisc_ops 'read()' function to take a kernel
pointer, I was a bit too aggressive about the ldisc returning EOVERFLOW.

Yes, we want to have EOVERFLOW override any partially read data (because
the whole point is that the buffer was too small for the whole packet,
and we don't want to see partial packets), but it shouldn't override a
previous EFAULT.

And in fact, it really is just EOVERFLOW that is special and should
throw away any partially read data, not "any error".  Admittedly
EOVERFLOW is currently the only one that can happen for a continuation
read - and if the first read iteration returns an error we won't have this issue.

So this is more of a technicality, but let's just make the intent very
explicit, and re-organize the error handling a bit so that this is all
clearer.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/CAHk-=wh+-rGsa=xruEWdg_fJViFG8rN9bpLrfLz=_yBYh2tBhA@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -859,13 +859,20 @@ static int iterate_tty_read(struct tty_l
 		if (!size)
 			break;
 
-		/*
-		 * A ldisc read error return will override any previously copied
-		 * data (eg -EOVERFLOW from HDLC)
-		 */
 		if (size < 0) {
-			memzero_explicit(kernel_buf, sizeof(kernel_buf));
-			return size;
+			/* Did we have an earlier error (ie -EFAULT)? */
+			if (retval)
+				break;
+			retval = size;
+
+			/*
+			 * -EOVERFLOW means we didn't have enough space
+			 * for a whole packet, and we shouldn't return
+			 * a partial result.
+			 */
+			if (retval == -EOVERFLOW)
+				offset = 0;
+			break;
 		}
 
 		copied = copy_to_iter(kernel_buf, size, to);


