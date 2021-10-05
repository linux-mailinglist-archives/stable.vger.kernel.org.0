Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EB542222D
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhJEJXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233174AbhJEJXr (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB1F61108;
        Tue,  5 Oct 2021 09:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425717;
        bh=0PxRnGy79cHPI29YbTzcVc+CS9MniT/5v9FYmYlkVGY=;
        h=Subject:To:From:Date:From;
        b=E99bXCOHevWFUl0ldIzmdMhW7qVnC/sD5V7O9QqWCWNlepJFavo+hFOa8qBMecBJP
         pTgZAWWi8ULjrq+IZcAzzmADCAe7F/zapCQvRpUQtLF9y7rPL1uT1/TizAs8Bn2In7
         xEsFHvWNZO9yx1+fa+oBVXz82lYJSb0IgGQIcHZQ=
Subject: patch "iio: light: opt3001: Fixed timeout error when 0 lux" added to staging-linus
To:     valek@2n.cz, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:27 +0200
Message-ID: <163342568767114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: opt3001: Fixed timeout error when 0 lux

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 26d90b5590579def54382a2fc34cfbe8518a9851 Mon Sep 17 00:00:00 2001
From: Jiri Valek - 2N <valek@2n.cz>
Date: Mon, 20 Sep 2021 14:53:48 +0200
Subject: iio: light: opt3001: Fixed timeout error when 0 lux

Reading from sensor returned timeout error under
zero light conditions.

Signed-off-by: Jiri Valek - 2N <valek@2n.cz>
Fixes: ac663db3678a ("iio: light: opt3001: enable operation w/o IRQ")
Link: https://lore.kernel.org/r/20210920125351.6569-1-valek@2n.cz
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/opt3001.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/opt3001.c b/drivers/iio/light/opt3001.c
index 52963da401a7..1880bd5bb258 100644
--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -276,6 +276,8 @@ static int opt3001_get_lux(struct opt3001 *opt, int *val, int *val2)
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
+		if (ret == 0)
+			return -ETIMEDOUT;
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?
@@ -312,9 +314,7 @@ static int opt3001_get_lux(struct opt3001 *opt, int *val, int *val2)
 		/* Disallow IRQ to access the device while lock is active */
 		opt->ok_to_ignore_lock = false;
 
-	if (ret == 0)
-		return -ETIMEDOUT;
-	else if (ret < 0)
+	if (ret < 0)
 		return ret;
 
 	if (opt->use_irq) {
-- 
2.33.0


