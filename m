Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FDD37C482
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhELPbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235307AbhELP1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:27:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE51661C1B;
        Wed, 12 May 2021 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832349;
        bh=J9cJo23zK/3+m4CkPC9+6rXi/ZvGwdrqclw+xclHUqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtJuxxs5dXhJypS41e/ePHA5mB2muFiAlN4vtbzPRsx/QCfqbpuiqc0FEkE5OJ8zT
         Ot3ZJN/NdM+Kx2Yg+ywaaK6odu8mKcmdTUyHBSakptAZ6dzsbk6l+4FBw5FAEj8LlH
         jW9xJV8uO+mtgteoLSFJfLcWMtOqdnlZ3cPsuqdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/530] USB: cdc-acm: fix unprivileged TIOCCSERIAL
Date:   Wed, 12 May 2021 16:45:53 +0200
Message-Id: <20210512144827.823018960@linuxfoundation.org>
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
index 0876468c2e7d..63824552e5d0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -955,8 +955,6 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 		if ((close_delay != acm->port.close_delay) ||
 		    (closing_wait != acm->port.closing_wait))
 			retval = -EPERM;
-		else
-			retval = -EOPNOTSUPP;
 	} else {
 		acm->port.close_delay  = close_delay;
 		acm->port.closing_wait = closing_wait;
-- 
2.30.2



