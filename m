Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035D017F9C1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgCJM7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgCJM7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:59:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8590520674;
        Tue, 10 Mar 2020 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845179;
        bh=JU/E6Hyc3lT/mzdd3OXkf1eaDqIKOPhrJqDCJo67chE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bss3sntZ3MR+AEM0Jd9VMSkyTuR6avggC0iMUR2wJeLqZ26KXpSZb+FJQdkvwgTFL
         HIxfVupD4cfBwDVgYjI3+M64RwhIwzOPGSBmPiR/56IXZ3dyDQG6HeLbJgESvrCAXs
         86HJF13nqDDx8uFP4qWjK7SCiu4qcQe5J0UE/Z7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ronald=20Tschal=C3=A4r?= <ronald@innovation.ch>
Subject: [PATCH 5.5 091/189] serdev: Fix detection of UART devices on Apple machines.
Date:   Tue, 10 Mar 2020 13:38:48 +0100
Message-Id: <20200310123648.924250076@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronald Tschalär <ronald@innovation.ch>

commit 35d4670aaec7206b5ef19c842ca33076bde562e4 upstream.

On Apple devices the _CRS method returns an empty resource template, and
the resource settings are instead provided by the _DSM method. But
commit 33364d63c75d6182fa369cea80315cf1bb0ee38e (serdev: Add ACPI
devices by ResourceSource field) changed the search for serdev devices
to require valid, non-empty resource template, thereby breaking Apple
devices and causing bluetooth devices to not be found.

This expands the check so that if we don't find a valid template, and
we're on an Apple machine, then just check for the device being an
immediate child of the controller and having a "baud" property.

Cc: <stable@vger.kernel.org> # 5.5
Fixes: 33364d63c75d ("serdev: Add ACPI devices by ResourceSource field")
Signed-off-by: Ronald Tschalär <ronald@innovation.ch>
Link: https://lore.kernel.org/r/20200211194723.486217-1-ronald@innovation.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serdev/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/serdev.h>
 #include <linux/slab.h>
+#include <linux/platform_data/x86/apple.h>
 
 static bool is_registered;
 static DEFINE_IDA(ctrl_ida);
@@ -630,6 +631,15 @@ static int acpi_serdev_check_resources(s
 	if (ret)
 		return ret;
 
+	/*
+	 * Apple machines provide an empty resource template, so on those
+	 * machines just look for immediate children with a "baud" property
+	 * (from the _DSM method) instead.
+	 */
+	if (!lookup.controller_handle && x86_apple_machine &&
+	    !acpi_dev_get_property(adev, "baud", ACPI_TYPE_BUFFER, NULL))
+		acpi_get_parent(adev->handle, &lookup.controller_handle);
+
 	/* Make sure controller and ResourceSource handle match */
 	if (ACPI_HANDLE(ctrl->dev.parent) != lookup.controller_handle)
 		return -ENODEV;


