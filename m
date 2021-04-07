Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2295535696D
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350957AbhDGKYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350937AbhDGKYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF25A613DF;
        Wed,  7 Apr 2021 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617791030;
        bh=osq8Zv5no+jjMKMVk9DS4gKqyPi6TZhpdLxBOLoPeJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsbJmXwBde2d8e+Lr6V5drvXKoLICyFpxDZnMjwpun+5gPF5scBnwg4GJRavGCZkh
         2TPKrto7dJgbX3xsfrUc/VZstna7ELu+UBRr5wsY2d1wH8semrsXtQNc8Uz1FKPpQo
         kOrhUNR7B4TkyE4L+TOFPUYOzc8ILnhGbUL1qujyeZUwNplmHHGpfWjnyigFOh3O5q
         eGskzEIWIPcyjSX7t0zLN854YOX7402fzTy8Q6TETsqiYw++tss77MqCQ3PNKsPGx+
         u+V5pBQ7q/StMEmYfLZYZRmp6FFKK5iJdLkTCcxKjKicalMUuOW7QCQ9lD8TvuL8e0
         A7oXfpRzV7W1A==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5Lb-0008RT-Dq; Wed, 07 Apr 2021 12:23:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 10/16] tty: moxa: fix TIOCSSERIAL jiffies conversions
Date:   Wed,  7 Apr 2021 12:23:28 +0200
Message-Id: <20210407102334.32361-11-johan@kernel.org>
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

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/moxa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 32eb6b5e510f..5b7bc7af8b1e 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -2038,7 +2038,7 @@ static int moxa_get_serial_info(struct tty_struct *tty,
 	ss->line = info->port.tty->index,
 	ss->flags = info->port.flags,
 	ss->baud_base = 921600,
-	ss->close_delay = info->port.close_delay;
+	ss->close_delay = jiffies_to_msecs(info->port.close_delay) / 10;
 	mutex_unlock(&info->port.mutex);
 	return 0;
 }
@@ -2067,7 +2067,7 @@ static int moxa_set_serial_info(struct tty_struct *tty,
 			return -EPERM;
 		}
 	}
-	info->port.close_delay = ss->close_delay * HZ / 100;
+	info->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
 
 	MoxaSetFifo(info, ss->type == PORT_16550A);
 
-- 
2.26.3

