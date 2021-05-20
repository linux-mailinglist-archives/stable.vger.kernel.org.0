Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE37238A938
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhETLA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238634AbhETK5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:57:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B65DA61CF4;
        Thu, 20 May 2021 10:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504930;
        bh=5zE6i/k8EBj/j49KT1aMJJuN/V/FPr/WbhyYN+v9Gb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ou2HMvKfF1AVZcdAJ2GYl/hiOFtfVIIo95pntIN3GhHprW+/sO+IRU9G7+V4p8/Qr
         yD0ogMZrvLrDFf//qOmw7GsLWDPPp44Zs4ea6qbr+3k71cAUnaOK8BZc18MIsw3E1r
         2tQB0c+DRl/igaNKbgPZlq7Fg9EHm8MrzJfH2ebI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 112/240] staging: greybus: uart: fix unprivileged TIOCCSERIAL
Date:   Thu, 20 May 2021 11:21:44 +0200
Message-Id: <20210520092112.440345354@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 60c6b305c11b5fd167ce5e2ce42f3a9098c388f0 ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

A non-privileged user has only ever been able to set the since long
deprecated ASYNC_SPD flags and trying to change any other *supported*
feature should result in -EPERM being returned. Setting the current
values for any supported features should return success.

Fix the greybus implementation which instead indicated that the
TIOCSSERIAL ioctl was not even implemented when a non-privileged user
set the current values.

Fixes: e68453ed28c5 ("greybus: uart-gb: now builds, more framework added")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-7-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/uart.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 9ef9cbfd8926..c35c9b766a00 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -661,8 +661,6 @@ static int set_serial_info(struct gb_tty *gb_tty,
 		if ((close_delay != gb_tty->port.close_delay) ||
 		    (closing_wait != gb_tty->port.closing_wait))
 			retval = -EPERM;
-		else
-			retval = -EOPNOTSUPP;
 	} else {
 		gb_tty->port.close_delay = close_delay;
 		gb_tty->port.closing_wait = closing_wait;
-- 
2.30.2



