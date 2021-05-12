Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3266437C515
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhELPdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234982AbhELP0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:26:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C86E619EE;
        Wed, 12 May 2021 15:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832273;
        bh=E8NAsm444CS1PX3bfV1zlCkMeo/zNbsFaO2va+Kysok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCrt48424wwknvTogbzMdX/xhUCpXE63n1q9zM3NL3gatsj4zAv58sCXbrXb3cv+E
         fjbxNVTcN/YB++oVrEsDCVHlmnuYHGkZyOC9wvsodNinsJJKI0pMMHzcijvGdOE5Zg
         JoEkDDVaS8rXJ5c7RqKpMq6FwpeIS0BZJpowLpu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/530] staging: fwserial: fix TIOCSSERIAL implementation
Date:   Wed, 12 May 2021 16:45:21 +0200
Message-Id: <20210512144826.781072131@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit a7eaaa9d1032e68669bb479496087ba8fc155ab6 ]

TIOCSSERIAL is a horrid, underspecified, legacy interface which for most
serial devices is only useful for setting the close_delay and
closing_wait parameters.

A non-privileged user has only ever been able to set the since long
deprecated ASYNC_SPD flags and trying to change any other *supported*
feature should result in -EPERM being returned. Setting the current
values for any supported features should return success.

Fix the fwserial implementation which was returning -EPERM also for a
privileged user when trying to change certain unsupported parameters,
and instead return success consistently.

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fwserial/fwserial.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 440d11423812..2888b80a2c1a 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1234,10 +1234,6 @@ static int set_serial_info(struct tty_struct *tty,
 	struct fwtty_port *port = tty->driver_data;
 	unsigned int cdelay;
 
-	if (ss->irq != 0 || ss->port != 0 || ss->custom_divisor != 0 ||
-	    ss->baud_base != 400000000)
-		return -EPERM;
-
 	cdelay = msecs_to_jiffies(ss->close_delay * 10);
 
 	mutex_lock(&port->port.mutex);
-- 
2.30.2



