Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4162420BC0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhJDM7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:32776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233355AbhJDM6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3400A61213;
        Mon,  4 Oct 2021 12:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352202;
        bh=n8QToiOkEOpcr7Fe8qUEh+CMAwzVrrn2EMx/b8QDslM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXNQwGnZCdkZKKLb+VKn9O3ndWkXkVkg7/ze5lsGJLXI8C+m+PIAIIx3XtY12471g
         xuonajQBeTvJL/KBa9xkvpG8vDvVaBxdSgjxVSpJtnATojCjMvVEKWLhWC2b6aX1tq
         KOuOkz433VWIXzCHiGDqBqmMX+NejtxduP3yTszE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/57] net: 6pack: Fix tx timeout and slot time
Date:   Mon,  4 Oct 2021 14:52:12 +0200
Message-Id: <20211004125029.828322339@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125028.940212411@linuxfoundation.org>
References: <20211004125028.940212411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 3c0d2a46c0141913dc6fd126c57d0615677d946e ]

tx timeout and slot time are currently specified in units of HZ.  On
Alpha, HZ is defined as 1024.  When building alpha:allmodconfig, this
results in the following error message.

  drivers/net/hamradio/6pack.c: In function 'sixpack_open':
  drivers/net/hamradio/6pack.c:71:41: error:
  	unsigned conversion from 'int' to 'unsigned char'
  	changes value from '256' to '0'

In the 6PACK protocol, tx timeout is specified in units of 10 ms and
transmitted over the wire:

    https://www.linux-ax25.org/wiki/6PACK

Defining a value dependent on HZ doesn't really make sense, and
presumably comes from the (very historical) situation where HZ was
originally 100.

Note that the SIXP_SLOTTIME use explicitly is about 10ms granularity:

        mod_timer(&sp->tx_t, jiffies + ((when + 1) * HZ) / 100);

and the SIXP_TXDELAY walue is sent as a byte over the wire.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index e510dbda77e5..96fb2a2a59f0 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -68,9 +68,9 @@
 #define SIXP_DAMA_OFF		0
 
 /* default level 2 parameters */
-#define SIXP_TXDELAY			(HZ/4)	/* in 1 s */
+#define SIXP_TXDELAY			25	/* 250 ms */
 #define SIXP_PERSIST			50	/* in 256ths */
-#define SIXP_SLOTTIME			(HZ/10)	/* in 1 s */
+#define SIXP_SLOTTIME			10	/* 100 ms */
 #define SIXP_INIT_RESYNC_TIMEOUT	(3*HZ/2) /* in 1 s */
 #define SIXP_RESYNC_TIMEOUT		5*HZ	/* in 1 s */
 
-- 
2.33.0



