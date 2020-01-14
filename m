Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367D913A53D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgANKFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729568AbgANKFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09D8924679;
        Tue, 14 Jan 2020 10:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996346;
        bh=rdnAqln+pjo34z88vpAB74Pfr8H4svabBXYjPIaWrj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukd7tlEqUxPmU9BED74Z73VPok0NSJemrHM8bUsMgzuY3+vnfimvXBUWUlh8IkGGs
         LUWeF5er925pHmcZ05JAoth0PSzXUHOUJH93913iprqSbxb2r/UbAfnFrsqWcyzmg/
         9aFu3BBJ5Ci5vNVvuD9KZf1NK3gWBzbS1xPeZU3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.4 41/78] staging: vt6656: Fix non zero logical return of, usb_control_msg
Date:   Tue, 14 Jan 2020 11:01:15 +0100
Message-Id: <20200114094359.096762080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 58c3e681b04dd57c70d0dcb7b69fe52d043ff75a upstream.

Starting with commit 59608cb1de1856
("staging: vt6656: clean function's error path in usbpipe.c")
the usb control functions have returned errors throughout driver
with only logical variable checking.

However, usb_control_msg return the amount of bytes transferred
this means that normal operation causes errors.

Correct the return function so only return zero when transfer
is successful.

Cc: stable <stable@vger.kernel.org> # v5.3+
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/08e88842-6f78-a2e3-a7a0-139fec960b2b@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/usbpipe.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -59,7 +59,9 @@ int vnt_control_out(struct vnt_private *
 
 	kfree(usb_buffer);
 
-	if (ret >= 0 && ret < (int)length)
+	if (ret == (int)length)
+		ret = 0;
+	else
 		ret = -EIO;
 
 end_unlock:
@@ -103,7 +105,9 @@ int vnt_control_in(struct vnt_private *p
 
 	kfree(usb_buffer);
 
-	if (ret >= 0 && ret < (int)length)
+	if (ret == (int)length)
+		ret = 0;
+	else
 		ret = -EIO;
 
 end_unlock:


