Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640B63BA162
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 15:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhGBNp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 09:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232696AbhGBNp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 09:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 876596142D;
        Fri,  2 Jul 2021 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625233374;
        bh=AYm6WKJ+TZhob2+LiBgKZ9p9qBKekXiMOR4Tkn4xqR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfRcUan9HIWQnCRbQW6o7dChLwSYizd5MAAq9MGrpU1eDowsrTJI7zopZaWb5y44T
         LA98G8R0M/ypkvnNQHu/ek8g16hH+C+OPE9jowF/S19LN05YMEwbCvfJuElOlswRnO
         5aW0TaQLJyrgzzsYDP/ppsFwu+Qe88ZD6/jCobauRM70uM+3WYrtNlyHaJl0oo5QfF
         1/1MszHxz0UWkos5UUl6DYJWVh2g34w7oOzZG1wjouxvmpvRRXLCGmRlCIB9VbTKyq
         QtPJSB+5w7cm92DJAfPQTakg0Pv6w+2NLeuoxZonO2AYD1pm3+2FheQvGsbIe12XWO
         t2HtYAtacVdFw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lzJRS-0006Q2-WD; Fri, 02 Jul 2021 15:42:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/6] USB: serial: cp210x: fix control-characters error handling
Date:   Fri,  2 Jul 2021 15:42:22 +0200
Message-Id: <20210702134227.24621-2-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702134227.24621-1-johan@kernel.org>
References: <20210702134227.24621-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the unlikely event that setting the software flow-control characters
fails the other flow-control settings should still be updated.

Fixes: 7748feffcd80 ("USB: serial: cp210x: add support for software flow control")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 09b845d0da41..b41e2c7649fb 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1217,9 +1217,7 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 		chars.bXonChar = START_CHAR(tty);
 		chars.bXoffChar = STOP_CHAR(tty);
 
-		ret = cp210x_set_chars(port, &chars);
-		if (ret)
-			return;
+		cp210x_set_chars(port, &chars);
 	}
 
 	mutex_lock(&port_priv->mutex);
-- 
2.31.1

