Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B61D9F4C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437635AbfJPVyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437628AbfJPVyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:00 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0273721925;
        Wed, 16 Oct 2019 21:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262840;
        bh=crHSjvYMY9d/dYMyzSZHnf5e6SCkxwWPOlxaPZTBiYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMZ2FeIqjN4VWz9UfJCHqhsD73vH2J9Opawrtqzve26HOXU93jRrhghOW1T7stJwx
         ufQui9dmkYsMuZZ6wPxr5cOjVGWb3kp9CqFuQNSnJTwTY2rymb1fM0yJVsyKTU2QMQ
         C6OSDnjJh8JHmNcQrK3Hi4WhVe4j8kUf5ShX8ZfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 45/79] USB: usblp: fix runtime PM after driver unbind
Date:   Wed, 16 Oct 2019 14:50:20 -0700
Message-Id: <20191016214807.819152517@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 9a31535859bfd8d1c3ed391f5e9247cd87bb7909 upstream.

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191001084908.2003-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/usblp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -474,10 +474,12 @@ static int usblp_release(struct inode *i
 
 	mutex_lock(&usblp_mutex);
 	usblp->used = 0;
-	if (usblp->present) {
+	if (usblp->present)
 		usblp_unlink_urbs(usblp);
-		usb_autopm_put_interface(usblp->intf);
-	} else		/* finish cleanup from disconnect */
+
+	usb_autopm_put_interface(usblp->intf);
+
+	if (!usblp->present)		/* finish cleanup from disconnect */
 		usblp_cleanup(usblp);
 	mutex_unlock(&usblp_mutex);
 	return 0;


