Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38AA41C156
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 11:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244898AbhI2JLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 05:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244989AbhI2JLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Sep 2021 05:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC6DF6140B;
        Wed, 29 Sep 2021 09:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632906604;
        bh=xSqo1TwRt4jqwdnxqfFvi9GrKsg78RJwRQhRbiGEmuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MF5eh2ydbdZMSiWxANuPA54nULVZkbKd0t25t/bVkpo/eOYZqd5sf0FgbwQwPuIPf
         nj1GBC5zzTIzU3Vo6eEC2KF+59in3ZVgdiTYKG3dlfexP+zM42OMZYFobKFQDqsa0+
         dd5pYo0FdSUv8LxzM83bqAHYLAHPuclJSQU59znmAkyNvM8/A8Xr4m03L+H4q6nHJV
         4Q9iTaFm8bOn5Vk0ufOoGn8kM/SNsXj3ajvq1ZvoKPeI3i8luuEZOe9TBvmvH/6yro
         xsy41peGJrxHYMKmnDIgKWD0q4wM5V9F1oovqXt55spoJB6u10PTPQhVZZ2SKmHTeY
         r1YQ7UKCB8mEw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mVVbJ-0001wV-Qk; Wed, 29 Sep 2021 11:10:05 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] USB: cdc-acm: fix break reporting
Date:   Wed, 29 Sep 2021 11:09:37 +0200
Message-Id: <20210929090937.7410-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929090937.7410-1-johan@kernel.org>
References: <20210929090937.7410-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent change that started reporting break events forgot to push the
event to the line discipline, which meant that a detected break would
not be reported until further characters had been receive (the port
could even have been closed and reopened in between).

Fixes: 08dff274edda ("cdc-acm: fix BREAK rx code path adding necessary calls")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index c7a1736720e7..7b2e2420ecae 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -340,6 +340,9 @@ static void acm_process_notification(struct acm *acm, unsigned char *buf)
 			acm->iocount.overrun++;
 		spin_unlock_irqrestore(&acm->read_lock, flags);
 
+		if (newctrl & ACM_CTRL_BRK)
+			tty_flip_buffer_push(&acm->port);
+
 		if (difference)
 			wake_up_all(&acm->wioctl);
 
-- 
2.32.0

