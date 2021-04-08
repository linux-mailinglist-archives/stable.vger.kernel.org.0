Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A374358464
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 15:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhDHNQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 09:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231255AbhDHNQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 09:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B06F461153;
        Thu,  8 Apr 2021 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617887776;
        bh=d3QIU2csiNcJOLhdhvMefuw6/6a+Kk8J/zx9o70Jpps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uh8hPpWVU5FMBgvNilxKuYOwn9YjfqX36+j/9INbaLI/SFniaEjUPvTSrDSkK0jsw
         0AvOzuI3LpG+S/7BIqkjUk54KQVts84ymLFz1xx7WbAl118XMuByWMXb/sA9bG6QIr
         A/5hCFZw3sxdlyg87QbCW6jvYuzcztYI1U9onCfqcUAXytL3EF/e1A2mlIHBywVulQ
         XJnpqOvT7M6LQpxGQT9P714cWxD2ncacZLCd6ASSkB8M/2E8bt3G9d4veSRKPNfCIz
         qB3J1YKvbnqj91qkaQ+BAsIEHuqpmEAVpXleYlOJybzM8yi8aQMNtFwLJNJXJPLi0S
         oRKh1qYVG+jXQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lUUW4-0007Hi-FQ; Thu, 08 Apr 2021 15:16:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Anthony Mallet <anthony.mallet@laas.fr>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"
Date:   Thu,  8 Apr 2021 15:16:00 +0200
Message-Id: <20210408131602.27956-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408131602.27956-1-johan@kernel.org>
References: <20210408131602.27956-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit b401f8c4f492cbf74f3f59c9141e5be3071071bb.

The offending commit claimed that trying to set the values reported back
by TIOCGSERIAL as a regular user could result in an -EPERM error when HZ
is 250, but that was never the case.

With HZ=250, the default 0.5 second value of close_delay is converted to
125 jiffies when set and is converted back to 50 centiseconds by
TIOCGSERIAL as expected (not 12 cs as was claimed, even if that was the
case before an earlier fix).

Comparing the internal current and new jiffies values is just fine to
determine if the value is about to change so drop the bogus workaround
(which was also backported to stable).

For completeness: With different default values for these parameters or
with a HZ value not divisible by two, the lack of rounding when setting
the default values in tty_port_init() could result in an -EPERM being
returned, but this is hardly something we need to worry about.

Cc: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 3fda1ec961d7..96e221803fa6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -942,7 +942,6 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct acm *acm = tty->driver_data;
 	unsigned int closing_wait, close_delay;
-	unsigned int old_closing_wait, old_close_delay;
 	int retval = 0;
 
 	close_delay = msecs_to_jiffies(ss->close_delay * 10);
@@ -950,17 +949,11 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 			ASYNC_CLOSING_WAIT_NONE :
 			msecs_to_jiffies(ss->closing_wait * 10);
 
-	/* we must redo the rounding here, so that the values match */
-	old_close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
-	old_closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-				ASYNC_CLOSING_WAIT_NONE :
-				jiffies_to_msecs(acm->port.closing_wait) / 10;
-
 	mutex_lock(&acm->port.mutex);
 
 	if (!capable(CAP_SYS_ADMIN)) {
-		if ((ss->close_delay != old_close_delay) ||
-		    (ss->closing_wait != old_closing_wait))
+		if ((close_delay != acm->port.close_delay) ||
+		    (closing_wait != acm->port.closing_wait))
 			retval = -EPERM;
 		else
 			retval = -EOPNOTSUPP;
-- 
2.26.3

