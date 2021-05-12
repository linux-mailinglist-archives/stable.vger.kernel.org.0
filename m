Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909BB37CB7D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhELQfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241281AbhELQ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8133B61DD1;
        Wed, 12 May 2021 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834674;
        bh=vR4uCZFVrYols5TeDN297eVtLmebC0YzuyiQeuQ5jSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lziv1HlSK8XjUHTJ8J9fQwyc70qWY7xwBHzWbGNk1bwiSWocXhJ2Z6oL1tUcvPYeD
         42vMGMFECK4uqxReZYrYWM9b+SBwGjFHkJ+8aONKoBY4JPy86thKyzMoT+XS3p9Kjb
         xgwDZPI4F0JgIK3a+xR+U4ftzMmLClfjP9t4eOLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 009/677] tty: moxa: fix TIOCSSERIAL jiffies conversions
Date:   Wed, 12 May 2021 16:40:55 +0200
Message-Id: <20210512144837.524505213@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 6e70b73ca5240c0059a1fbf8ccd4276d6cf71956 upstream.

The port close_delay parameter set by TIOCSSERIAL is specified in
jiffies, while the value returned by TIOCGSERIAL is specified in
centiseconds.

Add the missing conversions so that TIOCGSERIAL works as expected also
when HZ is not 100.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-11-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/moxa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -2040,7 +2040,7 @@ static int moxa_get_serial_info(struct t
 	ss->line = info->port.tty->index,
 	ss->flags = info->port.flags,
 	ss->baud_base = 921600,
-	ss->close_delay = info->port.close_delay;
+	ss->close_delay = jiffies_to_msecs(info->port.close_delay) / 10;
 	mutex_unlock(&info->port.mutex);
 	return 0;
 }
@@ -2069,7 +2069,7 @@ static int moxa_set_serial_info(struct t
 			return -EPERM;
 		}
 	}
-	info->port.close_delay = ss->close_delay * HZ / 100;
+	info->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
 
 	MoxaSetFifo(info, ss->type == PORT_16550A);
 


