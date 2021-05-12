Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8994437CB70
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbhELQfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241189AbhELQ0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 388E161554;
        Wed, 12 May 2021 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834619;
        bh=Zi3dydaXI06i0eQgVxWiAOpGUlzb5Slw37i/xhO1EFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPEel/K8s0KqpbfmaH62Jn3gTLUu9/Hiq9P9rBgV1tEGitb+FBLLqXfsd4JTfE2CW
         R8WUL7STwrq21gtQ2OmQ9qsFgnOcg/sSpuaL0EvSH0RmuAnVC99CKlIOYL+wG2Ow3O
         KNDG5W7UO2WmfFcblHGnoZ0XdFmgdbNUuQwty2ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 017/677] staging: fwserial: fix TIOCSSERIAL permission check
Date:   Wed, 12 May 2021 16:41:03 +0200
Message-Id: <20210512144837.798396284@linuxfoundation.org>
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

commit 2104eb283df66a482b60254299acbe3c68c03412 upstream.

Changing the port close-delay parameter is a privileged operation so
make sure to return -EPERM if a regular user tries to change it.

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Cc: stable@vger.kernel.org      # 3.8
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/fwserial/fwserial.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1232,20 +1232,24 @@ static int set_serial_info(struct tty_st
 			   struct serial_struct *ss)
 {
 	struct fwtty_port *port = tty->driver_data;
+	unsigned int cdelay;
 
 	if (ss->irq != 0 || ss->port != 0 || ss->custom_divisor != 0 ||
 	    ss->baud_base != 400000000)
 		return -EPERM;
 
+	cdelay = msecs_to_jiffies(ss->close_delay * 10);
+
 	mutex_lock(&port->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
-		if (((ss->flags & ~ASYNC_USR_MASK) !=
+		if (cdelay != port->port.close_delay ||
+		    ((ss->flags & ~ASYNC_USR_MASK) !=
 		     (port->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&port->port.mutex);
 			return -EPERM;
 		}
 	}
-	port->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
+	port->port.close_delay = cdelay;
 	mutex_unlock(&port->port.mutex);
 
 	return 0;


