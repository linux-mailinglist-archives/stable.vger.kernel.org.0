Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DEB2A51FC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbgKCUpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731050AbgKCUph (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD2422409;
        Tue,  3 Nov 2020 20:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436337;
        bh=d3CuJi4DX4CEbIJEOeVUaWWVfcTcqAn8gtBCReOXWx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuOEZDidKLmPB0itjKreCC6/E5nSnuiAYg6SL3nr0CfckD5nvIoOKKdnKY5/P/p6A
         zEjRpwBWxymTsjmBbYr6H5GphBRC6rN+1/KZwHmjXDcYvAOSiQK8NFb52ThpOls0vC
         YVYB7uVa5esrOS5pBD5fg34F/XMZKelRqqV+1PCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jim@photojim.ca,
        Ben Hutchings <ben@decadent.org.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 206/391] ACPI / extlog: Check for RDMSR failure
Date:   Tue,  3 Nov 2020 21:34:17 +0100
Message-Id: <20201103203400.798812397@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit 7cecb47f55e00282f972a1e0b09136c8cd938221 upstream.

extlog_init() uses rdmsrl() to read an MSR, which on older CPUs
provokes a error message at boot:

    unchecked MSR access error: RDMSR from 0x179 at rIP: 0xcd047307 (native_read_msr+0x7/0x40)

Use rdmsrl_safe() instead, and return -ENODEV if it fails.

Reported-by: jim@photojim.ca
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_extlog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -222,9 +222,9 @@ static int __init extlog_init(void)
 	u64 cap;
 	int rc;
 
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-
-	if (!(cap & MCG_ELOG_P) || !extlog_get_l1addr())
+	if (rdmsrl_safe(MSR_IA32_MCG_CAP, &cap) ||
+	    !(cap & MCG_ELOG_P) ||
+	    !extlog_get_l1addr())
 		return -ENODEV;
 
 	rc = -EINVAL;


