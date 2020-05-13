Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026C1D0D2B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbgEMJux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732965AbgEMJuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D96D22312A;
        Wed, 13 May 2020 09:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363450;
        bh=pGMOmfgZYD4hG2YOmoxa8HOQPBwC8mhC3RTXFJgBhFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZbnAGnjujml0isSLvdXj5WRpG9+uyT+Piy9f9m4llYcWR7s68ihs490/uR5QTCJG
         kRPsm0iBwDajAqVmvYEnDC0Iz4Ve8facstS7cnWejPEEIwFqfQjc1L7vfbeDAkFBnW
         F1L7JDqN7zrAevTv2QI8Tm9mxN5v+pDisq8zjXjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jere=20Lepp=C3=A4nen?= <jere.leppanen@nokia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 42/90] sctp: Fix bundling of SHUTDOWN with COOKIE-ACK
Date:   Wed, 13 May 2020 11:44:38 +0200
Message-Id: <20200513094413.208427698@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jere Leppänen <jere.leppanen@nokia.com>

commit 145cb2f7177d94bc54563ed26027e952ee0ae03c upstream.

When we start shutdown in sctp_sf_do_dupcook_a(), we want to bundle
the SHUTDOWN with the COOKIE-ACK to ensure that the peer receives them
at the same time and in the correct order. This bundling was broken by
commit 4ff40b86262b ("sctp: set chunk transport correctly when it's a
new asoc"), which assigns a transport for the COOKIE-ACK, but not for
the SHUTDOWN.

Fix this by passing a reference to the COOKIE-ACK chunk as an argument
to sctp_sf_do_9_2_start_shutdown() and onward to
sctp_make_shutdown(). This way the SHUTDOWN chunk is assigned the same
transport as the COOKIE-ACK chunk, which allows them to be bundled.

In sctp_sf_do_9_2_start_shutdown(), the void *arg parameter was
previously unused. Now that we're taking it into use, it must be a
valid pointer to a chunk, or NULL. There is only one call site where
it's not, in sctp_sf_autoclose_timer_expire(). Fix that too.

Fixes: 4ff40b86262b ("sctp: set chunk transport correctly when it's a new asoc")
Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sctp/sm_statefuns.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1865,7 +1865,7 @@ static enum sctp_disposition sctp_sf_do_
 		 */
 		sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(repl));
 		return sctp_sf_do_9_2_start_shutdown(net, ep, asoc,
-						     SCTP_ST_CHUNK(0), NULL,
+						     SCTP_ST_CHUNK(0), repl,
 						     commands);
 	} else {
 		sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
@@ -5470,7 +5470,7 @@ enum sctp_disposition sctp_sf_do_9_2_sta
 	 * in the Cumulative TSN Ack field the last sequential TSN it
 	 * has received from the peer.
 	 */
-	reply = sctp_make_shutdown(asoc, NULL);
+	reply = sctp_make_shutdown(asoc, arg);
 	if (!reply)
 		goto nomem;
 
@@ -6068,7 +6068,7 @@ enum sctp_disposition sctp_sf_autoclose_
 	disposition = SCTP_DISPOSITION_CONSUME;
 	if (sctp_outq_is_empty(&asoc->outqueue)) {
 		disposition = sctp_sf_do_9_2_start_shutdown(net, ep, asoc, type,
-							    arg, commands);
+							    NULL, commands);
 	}
 
 	return disposition;


