Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33424272D77
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgIUQka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgIUQkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1AB823998;
        Mon, 21 Sep 2020 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706413;
        bh=Cm7zi0oycO/VORlrjs1Rf7bW3IHMkcejIpXZaKzDbZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU9DBIPtIoXHKZZxnIqadFP06nG9GpS5B/nDOkJbetZQKsABVPjWgeuHLRjiyBD7c
         k6GUcloO9SLyVX4zl3PMtH7z9xQEP1IzYG9LLeouP8sbULCweo3PBhPFGclls+CR04
         bJkXv41ZU9hl/JGAjPG470KiISFqrTeoIXvNAqfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 4.14 59/94] usb: typec: ucsi: acpi: Check the _DEP dependencies
Date:   Mon, 21 Sep 2020 18:27:46 +0200
Message-Id: <20200921162038.260737209@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 1f3546ff3f0a1000971daef58406954bad3f7061 upstream.

Failing probe with -EPROBE_DEFER until all dependencies
listed in the _DEP (Operation Region Dependencies) object
have been met.

This will fix an issue where on some platforms UCSI ACPI
driver fails to probe because the address space handler for
the operation region that the UCSI ACPI interface uses has
not been loaded yet.

Fixes: 8243edf44152 ("usb: typec: ucsi: Add ACPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200904110918.51546-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/ucsi_acpi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -67,11 +67,15 @@ static void ucsi_acpi_notify(acpi_handle
 
 static int ucsi_acpi_probe(struct platform_device *pdev)
 {
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 	struct ucsi_acpi *ua;
 	struct resource *res;
 	acpi_status status;
 	int ret;
 
+	if (adev->dep_unmet)
+		return -EPROBE_DEFER;
+
 	ua = devm_kzalloc(&pdev->dev, sizeof(*ua), GFP_KERNEL);
 	if (!ua)
 		return -ENOMEM;


