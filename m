Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEB719B1D8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388359AbgDAQic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388483AbgDAQi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:38:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E5720658;
        Wed,  1 Apr 2020 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759109;
        bh=dFjXY1QlWtybV0vDkb/h3x6ZtJMyOFc9h+GDlPWsSm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8Vnt3l8mDvTVJ1z3RYdoIkQlvf17etSQFxQCTc5ANElsybkOfL+wIOWGBTxGIC1K
         Ihrz9N1zan7qu/0EA3cmWXKqq/SVhkw3GVbvzRugdFlY0t2Xb9el+BlFz7KwDrSTBN
         QFbYpvnhTEypbapXLx0nnUAQvfue2dOvphYIX9Ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Mallet <anthony.mallet@laas.fr>,
        Oliver Neukum <oneukum@suse.com>,
        Matthias Reichl <hias@horus.com>
Subject: [PATCH 4.9 077/102] USB: cdc-acm: restore capability check order
Date:   Wed,  1 Apr 2020 18:18:20 +0200
Message-Id: <20200401161545.546407859@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

commit 62d65bdd9d05158aa2547f8ef72375535f3bc6e3 upstream.

commit b401f8c4f492c ("USB: cdc-acm: fix rounding error in TIOCSSERIAL")
introduced a regression by changing the order of capability and close
settings change checks. When running with CAP_SYS_ADMIN setting the
close settings to the values already set resulted in -EOPNOTSUPP.

Fix this by changing the check order back to how it was before.

Fixes: b401f8c4f492c ("USB: cdc-acm: fix rounding error in TIOCSSERIAL")
Cc: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Matthias Reichl <hias@horus.com>
Link: https://lore.kernel.org/r/20200327150350.3657-1-hias@horus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -863,16 +863,16 @@ static int set_serial_info(struct acm *a
 
 	mutex_lock(&acm->port.mutex);
 
-	if ((new_serial.close_delay != old_close_delay) ||
-            (new_serial.closing_wait != old_closing_wait)) {
-		if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN)) {
+		if ((new_serial.close_delay != old_close_delay) ||
+	            (new_serial.closing_wait != old_closing_wait))
 			retval = -EPERM;
-		else {
-			acm->port.close_delay  = close_delay;
-			acm->port.closing_wait = closing_wait;
-		}
-	} else
-		retval = -EOPNOTSUPP;
+		else
+			retval = -EOPNOTSUPP;
+	} else {
+		acm->port.close_delay  = close_delay;
+		acm->port.closing_wait = closing_wait;
+	}
 
 	mutex_unlock(&acm->port.mutex);
 	return retval;


