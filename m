Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242D4272E32
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgIUQrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgIUQq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B8082388B;
        Mon, 21 Sep 2020 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706818;
        bh=Ene7O8YK1qgIDkHOO2I0Sb/9C+Q1OqyCAPRST8nYiRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5dVXI/BX9FWZtbScPZ7AikaubENPYiGAhaS9Z+hnHukiozlCQPu26Umuf8+RwQoU
         rXRi8ZjdJ2onG7KZXRwUxaKv+Gv6EZRJZUgGeGY+UxaSSbMLw5SXbMOe+Xnglaa8vl
         RM3+wc3axaXua/Sq35zxMc1t6LjJRmXUvVWTtnDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.8 089/118] usb: typec: ucsi: acpi: Increase command completion timeout value
Date:   Mon, 21 Sep 2020 18:28:21 +0200
Message-Id: <20200921162040.486534913@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 130a96d698d7bee9f339832d1e47ab26aad8dbf1 upstream.

UCSI specification quite clearly states that if a command
can't be completed in 10ms, the firmware must notify
about BUSY condition. Unfortunately almost none of the
platforms (the firmware on them) generate the BUSY
notification even if a command can't be completed in time.

The driver already considered that, and used a timeout
value of 5 seconds, but processing especially the alternate
mode discovery commands takes often considerable amount of
time from the firmware, much more than the 5 seconds. That
happens especially after bootup when devices are already
connected to the USB Type-C connector. For now on those
platforms the alternate mode discovery has simply failed
because of the timeout.

To improve the situation, increasing the timeout value for
the command completion to 1 minute. That should give enough
time for even the slowest firmware to process the commands.

Fixes: f56de278e8ec ("usb: typec: ucsi: acpi: Move to the new API")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200916090034.25119-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -78,7 +78,7 @@ static int ucsi_acpi_sync_write(struct u
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ua->complete, msecs_to_jiffies(5000)))
+	if (!wait_for_completion_timeout(&ua->complete, 60 * HZ))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:


