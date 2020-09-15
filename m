Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0CF26B72A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgIPASf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgIOOWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:22:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A812222B8;
        Tue, 15 Sep 2020 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179483;
        bh=miPX4RjeJn5w/r+hKoXTnbvZZrD4git9/cOHZbzQ3fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORQvH7gO/gnIOHufprZ1c6i0WJ+m861rPmNBqoJrLl9UXtRWHdGbszLNMi129Pm5V
         vmCfjIso/m5dnfjphqVK5AwFEvP7gjbVfzRYm5sbiD1IHaAWMRudAHmEcQGfGwLsah
         lz0rz0W357noFZ7wYExwFTyOYokxEp32s7AERVyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 4.19 78/78] usb: typec: ucsi: acpi: Check the _DEP dependencies
Date:   Tue, 15 Sep 2020 16:13:43 +0200
Message-Id: <20200915140637.507948901@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
@@ -64,11 +64,15 @@ static void ucsi_acpi_notify(acpi_handle
 
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


