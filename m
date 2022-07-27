Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBF6582D6F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbiG0Q5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241185AbiG0Q50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:57:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831466AC0;
        Wed, 27 Jul 2022 09:36:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E830B821D4;
        Wed, 27 Jul 2022 16:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8F4C433D6;
        Wed, 27 Jul 2022 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939769;
        bh=IUKrvgR9qEPjvc7ubUpN6mhb+LpczifZ0GWm7PfjtOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oe+e9irdF/R0rq7MkxyoZVC5paLSe5EzT8TZC19FhCI9l9eId6zrJiJoG+BknpzRi
         tCveJF10J7O1HKaA7ikiIH0UL0Pe0iCjlmRuduZP6zEp8IxuAmGrtJu9zWFgHsZcuc
         vPtPj1wl+Y5wqttLBacBUXEj3ADyBs/8Vgn6WA1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@reisers.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.10 098/105] tty: the rest, stop using tty_schedule_flip()
Date:   Wed, 27 Jul 2022 18:11:24 +0200
Message-Id: <20220727161016.046323719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit b68b914494df4f79b4e9b58953110574af1cb7a2 upstream.

Since commit a9c3f68f3cd8d (tty: Fix low_latency BUG) in 2014,
tty_flip_buffer_push() is only a wrapper to tty_schedule_flip(). We are
going to remove the latter (as it is used less), so call the former in
the rest of the users.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: William Hubbs <w.d.hubbs@gmail.com>
Cc: Chris Brannon <chris@the-brannons.com>
Cc: Kirk Reiser <kirk@reisers.ca>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211122111648.30379-3-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/srmcons.c               |    2 +-
 drivers/accessibility/speakup/spk_ttyio.c |    4 ++--
 drivers/s390/char/keyboard.h              |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -59,7 +59,7 @@ srmcons_do_receive_chars(struct tty_port
 	} while((result.bits.status & 1) && (++loops < 10));
 
 	if (count)
-		tty_schedule_flip(port);
+		tty_flip_buffer_push(port);
 
 	return count;
 }
--- a/drivers/accessibility/speakup/spk_ttyio.c
+++ b/drivers/accessibility/speakup/spk_ttyio.c
@@ -88,7 +88,7 @@ static int spk_ttyio_receive_buf2(struct
 	}
 
 	if (!ldisc_data->buf_free)
-		/* ttyio_in will tty_schedule_flip */
+		/* ttyio_in will tty_flip_buffer_push */
 		return 0;
 
 	/* Make sure the consumer has read buf before we have seen
@@ -334,7 +334,7 @@ static unsigned char ttyio_in(int timeou
 	mb();
 	ldisc_data->buf_free = true;
 	/* Let TTY push more characters */
-	tty_schedule_flip(speakup_tty->port);
+	tty_flip_buffer_push(speakup_tty->port);
 
 	return rv;
 }
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -56,7 +56,7 @@ static inline void
 kbd_put_queue(struct tty_port *port, int ch)
 {
 	tty_insert_flip_char(port, ch, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static inline void
@@ -64,5 +64,5 @@ kbd_puts_queue(struct tty_port *port, ch
 {
 	while (*cp)
 		tty_insert_flip_char(port, *cp++, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }


