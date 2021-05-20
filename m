Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0577538A715
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbhETKd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234377AbhETKbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F80761C40;
        Thu, 20 May 2021 09:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504347;
        bh=ym+m/yQwNqgv38CotRp6lsOUloY4oq5yNC1CYHl0Vso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ienvgTBfSQbRy6o9gokC+R2GIh4O9NLrMmzO+mPAtMtLMOBRNwKrUoS4zOxXcYXGq
         YBxE1L9oGbcduy4+HZhNUINfKrxwdIgwBooS+of+lGHD09AuUc/LKY77paXNscMp5N
         UswSBqSWA2nO0IHM2mGAcuyFWTymglik1lTeWA0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 171/323] USB: cdc-acm: fix unprivileged TIOCCSERIAL
Date:   Thu, 20 May 2021 11:21:03 +0200
Message-Id: <20210520092125.974336930@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 22a7f67e70e7..fbf7cb8d34e7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -999,8 +999,6 @@ static int set_serial_info(struct acm *acm,
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



