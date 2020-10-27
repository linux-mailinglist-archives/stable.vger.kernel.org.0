Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E778029C711
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1808820AbgJ0S1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbgJ0N6E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59256206D4;
        Tue, 27 Oct 2020 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807084;
        bh=FkHSQwyV1DG0Ipd5r7fKN+XoE/6iIwCGbUmZJw/vaPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chc7rnM9scoirT1GDvRPOXGQLrD2wCAEXs4UT4/haBDnldqbbzkTkNwmIbvEs01wS
         ntKLPaiNznuZBiuQCOOWKl7zAosdEdvjw4KYyoKwW98vENH2765Nxd9OyUGEfU/1wX
         iZNHFe2hPT90blFy4l4b3ABHkxMU+U2d1u7W00Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 037/112] tty: hvcs: Dont NULL tty->driver_data until hvcs_cleanup()
Date:   Tue, 27 Oct 2020 14:49:07 +0100
Message-Id: <20201027134902.315863828@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 63ffcbdad738e3d1c857027789a2273df3337624 ]

The code currently NULLs tty->driver_data in hvcs_close() with the
intent of informing the next call to hvcs_open() that device needs to be
reconfigured. However, when hvcs_cleanup() is called we copy hvcsd from
tty->driver_data which was previoulsy NULLed by hvcs_close() and our
call to tty_port_put(&hvcsd->port) doesn't actually do anything since
&hvcsd->port ends up translating to NULL by chance. This has the side
effect that when hvcs_remove() is called we have one too many port
references preventing hvcs_destuct_port() from ever being called. This
also prevents us from reusing the /dev/hvcsX node in a future
hvcs_probe() and we can eventually run out of /dev/hvcsX devices.

Fix this by waiting to NULL tty->driver_data in hvcs_cleanup().

Fixes: 27bf7c43a19c ("TTY: hvcs, add tty install")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://lore.kernel.org/r/20200820234643.70412-1-tyreld@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvcs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 5997b17311113..cba662c50f919 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1232,13 +1232,6 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 
 		tty_wait_until_sent(tty, HVCS_CLOSE_WAIT);
 
-		/*
-		 * This line is important because it tells hvcs_open that this
-		 * device needs to be re-configured the next time hvcs_open is
-		 * called.
-		 */
-		tty->driver_data = NULL;
-
 		free_irq(irq, hvcsd);
 		return;
 	} else if (hvcsd->port.count < 0) {
@@ -1254,6 +1247,13 @@ static void hvcs_cleanup(struct tty_struct * tty)
 {
 	struct hvcs_struct *hvcsd = tty->driver_data;
 
+	/*
+	 * This line is important because it tells hvcs_open that this
+	 * device needs to be re-configured the next time hvcs_open is
+	 * called.
+	 */
+	tty->driver_data = NULL;
+
 	tty_port_put(&hvcsd->port);
 }
 
-- 
2.25.1



