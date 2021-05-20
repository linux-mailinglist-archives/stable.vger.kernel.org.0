Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B932F38AAD0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbhETLRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239690AbhETLPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:15:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B19361D5E;
        Thu, 20 May 2021 10:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505348;
        bh=9+pzrV+BAotpe9FgS0dlM/njhff3/8uV7rNJxVIBdxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7s6wCCOF+s8jMbl/9dKWr0YTYYr+PCDHiAzX7C4RqE0BB+Wm4LkIGbmj0D+q3m59
         500mCbQnJBJ5NB6RD37U93Wrv4kIdlXO90E3auF2n0K564dkLoth3wfEE5yj9Pc/g6
         QZFbctv5eSgvUtQTtwJARwVkLaT6/oskk0uwWNTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 094/190] USB: cdc-acm: fix unprivileged TIOCCSERIAL
Date:   Thu, 20 May 2021 11:22:38 +0200
Message-Id: <20210520092105.310097831@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit dd5619582d60007139f0447382d2839f4f9e339b ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

A non-privileged user has only ever been able to set the since long
deprecated ASYNC_SPD flags and trying to change any other *supported*
feature should result in -EPERM being returned. Setting the current
values for any supported features should return success.

Fix the cdc-acm implementation which instead indicated that the
TIOCSSERIAL ioctl was not even implemented when a non-privileged user
set the current values.

Fixes: ba2d8ce9db0a ("cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)")
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210408131602.27956-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8c476a785360..0478d55bd283 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -883,8 +883,6 @@ static int set_serial_info(struct acm *acm,
 		if ((new_serial.close_delay != old_close_delay) ||
 	            (new_serial.closing_wait != old_closing_wait))
 			retval = -EPERM;
-		else
-			retval = -EOPNOTSUPP;
 	} else {
 		acm->port.close_delay  = close_delay;
 		acm->port.closing_wait = closing_wait;
-- 
2.30.2



