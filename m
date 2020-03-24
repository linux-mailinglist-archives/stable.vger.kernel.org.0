Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F96190F4D
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCXNTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgCXNTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:19:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F281F208C3;
        Tue, 24 Mar 2020 13:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055961;
        bh=vJrG/HTDAoQhWIIOQI6UiUU70aPd5X2uwA4CofUHJ2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jdWZhaVm/6sB5nQbFy77eJU9LTqNRmyjdKxcMDq7iPQ/XSV/hZM+15JLXVs6nC6J3
         +a9qV9UaFGSjUvwG/7ATQfJFABFacqY3D4AFnuu8xE7Lc+3xUNZTshaDmGi1HfbqAb
         ktoUR6F6LJHAEGBkvJzfUDxeM+XUFuECYFS/QdXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrea Gagliardi La Gala <andrea.lagala@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.4 043/102] usb: typec: ucsi: displayport: Fix NULL pointer dereference
Date:   Tue, 24 Mar 2020 14:10:35 +0100
Message-Id: <20200324130811.093330367@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
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
@@ -273,6 +273,9 @@ void ucsi_displayport_remove_partner(str
 		return;
 
 	dp = typec_altmode_get_drvdata(alt);
+	if (!dp)
+		return;
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


