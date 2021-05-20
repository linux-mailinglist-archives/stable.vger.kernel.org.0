Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB438A3C7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhETJ4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:56:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234851AbhETJys (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91CCF613E8;
        Thu, 20 May 2021 09:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503425;
        bh=8csTBPhZNYEwpZ/JDNZfQoTGZl82h2J9l4/jiCn7/4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAF3KkZPmWGMwvpr4UBthCf71Sa7apYmUrVjk6NmD+/JB17aA3AgjtdDT2USgBBMe
         vlBibNOJC0fSvvQJMlAnqw7/rlg8JruPg8QJH/t+DCIDhCdo3use4JQyY0J+lBaQWX
         BsxKh7Av+fpzJBL3tix02ybcgO/6lorXTAu3Lx6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/425] USB: cdc-acm: fix unprivileged TIOCCSERIAL
Date:   Thu, 20 May 2021 11:19:43 +0200
Message-Id: <20210520092138.456882105@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 7f4f21ba8efc..738de8c9c354 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -987,8 +987,6 @@ static int set_serial_info(struct acm *acm,
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



