Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAFC2ABC9D
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbgKINjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730689AbgKINDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56626216C4;
        Mon,  9 Nov 2020 13:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927014;
        bh=EO39JHmwbidWafUliPC9EV1rvv8YHW5Upw6Y2l7PU9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZNLKYc+eGa809qeNrjYSHgWaVfJq3emGSuO+ln7cNF3VDUKD303o4RuR+T47wVC+
         wcOZVOj3qcNzUNejBs1udcINNUF3hnlFvI6JjeEdCTSAfDiRxg6Uptxma4P+Lz5UcS
         YT0eoryN3NtUOD/5VYtHF4qtuV7hoTsP5iZxaZAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jim@photojim.ca,
        Ben Hutchings <ben@decadent.org.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 051/117] ACPI / extlog: Check for RDMSR failure
Date:   Mon,  9 Nov 2020 13:54:37 +0100
Message-Id: <20201109125028.092400503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
@@ -223,9 +223,9 @@ static int __init extlog_init(void)
 	u64 cap;
 	int rc;
 
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-
-	if (!(cap & MCG_ELOG_P) || !extlog_get_l1addr())
+	if (rdmsrl_safe(MSR_IA32_MCG_CAP, &cap) ||
+	    !(cap & MCG_ELOG_P) ||
+	    !extlog_get_l1addr())
 		return -ENODEV;
 
 	if (get_edac_report_status() == EDAC_REPORTING_FORCE) {


