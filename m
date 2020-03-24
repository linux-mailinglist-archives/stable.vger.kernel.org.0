Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885CA1910A8
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgCXNXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729242AbgCXNXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:23:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D93208CA;
        Tue, 24 Mar 2020 13:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056184;
        bh=aauUJe8eZw5qsJ6PPC3zQSTUg4bXpUhcqoAUnxE6Ras=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PV250dFYFN2rxB7lZ73KRUu55gczbsKn8bTxh9qqTVSjhn853zdA/anIXd2SjOkfk
         hRnJtgH+cuanwHrI7qmN1RC8bttP41I2uz18t2qSKxQQk1WMwm1QT+p94LNZVUbYFU
         xrr31YbcUYP+YH9IFHZ/bZsWqoIpb2htLgTtyg0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrea Gagliardi La Gala <andrea.lagala@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.5 049/119] usb: typec: ucsi: displayport: Fix NULL pointer dereference
Date:   Tue, 24 Mar 2020 14:10:34 +0100
Message-Id: <20200324130813.206966428@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit d16e7b62c5adcd13832c6b0ba364c3468d21b856 upstream.

If the registration of the DisplayPort was not successful,
or if the port does not support DisplayPort alt mode in the
first place, the function ucsi_displayport_remove_partner()
will fail with NULL pointer dereference when it attempts to
access the driver data.

Adding a check to the function to make sure there really is
driver data for the device before modifying it.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Reported-by: Andrea Gagliardi La Gala <andrea.lagala@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206365
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200311130006.41288-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/displayport.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -271,6 +271,9 @@ void ucsi_displayport_remove_partner(str
 		return;
 
 	dp = typec_altmode_get_drvdata(alt);
+	if (!dp)
+		return;
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


