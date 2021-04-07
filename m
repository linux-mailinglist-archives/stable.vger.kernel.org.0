Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDBA356969
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350939AbhDGKYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234482AbhDGKX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:23:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B2F613A0;
        Wed,  7 Apr 2021 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617791030;
        bh=wHRJSTfhmbp2C9AGX30evxMJrkmtbmwIdlqGkY/e/2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGrb+ehhbmbharjoG2/kdhMvEMEAn4KqVkmW27uS07R3zXQnxjtTT9bl4clMtRC4L
         mz/NOkKzLXZFSyVetnC92f9nG4iFWfJd2DPNPxr9asYt3+YYahmw4HF5ksGvoRHFpk
         ivwoxk6NtKyFf0eslfsKZltd8/13XQD3h925CPv47ebd6nBWc7kKtyLTVXpLrTazo1
         tn2Op9/+/BUu4lns92hk8wieXI27aKQcZd1REzxI7f3u1d1RD07FSdft/LymuR7pX/
         nkssdhNi+W/Zen92B3L4ZuXDMvGiXboUiC8Yf4E1mQfaOJhm3zhdROvrAsFTle8vZg
         e+C8t0W5HMO+A==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5La-0008R1-Mc; Wed, 07 Apr 2021 12:23:42 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 01/16] staging: fwserial: fix TIOCSSERIAL jiffies conversions
Date:   Wed,  7 Apr 2021 12:23:19 +0200
Message-Id: <20210407102334.32361-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210407102334.32361-1-johan@kernel.org>
References: <20210407102334.32361-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The port close_delay parameter set by TIOCSSERIAL is specified in
jiffies, while the value returned by TIOCGSERIAL is specified in
centiseconds.

Add the missing conversions so that TIOCGSERIAL works as expected also
when HZ is not 100.

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Cc: stable@vger.kernel.org      # 3.8
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/fwserial/fwserial.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index c368082aae1a..c963848522b1 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1223,7 +1223,7 @@ static int get_serial_info(struct tty_struct *tty,
 	ss->flags = port->port.flags;
 	ss->xmit_fifo_size = FWTTY_PORT_TXFIFO_LEN;
 	ss->baud_base = 400000000;
-	ss->close_delay = port->port.close_delay;
+	ss->close_delay = jiffies_to_msecs(port->port.close_delay) / 10;
 	mutex_unlock(&port->port.mutex);
 	return 0;
 }
@@ -1245,7 +1245,7 @@ static int set_serial_info(struct tty_struct *tty,
 			return -EPERM;
 		}
 	}
-	port->port.close_delay = ss->close_delay * HZ / 100;
+	port->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	mutex_unlock(&port->port.mutex);
 
 	return 0;
-- 
2.26.3

