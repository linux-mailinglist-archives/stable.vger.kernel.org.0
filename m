Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1738D2A53E6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbgKCVFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387858AbgKCVFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:05:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F774205ED;
        Tue,  3 Nov 2020 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437544;
        bh=cEYcqo0HfhMWwa15jk3JBkbvGR1AGq4Ir29tctpU3jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGUvQP+HmnOjW5v2we+NW/DuJE0fslsQDVkRXdDswRy7sQtXXh09y/tCDzky26PVN
         EJavYqY8/0rEGoTSTTBwCGuNngn4Ofdt1OR9RZqLh8McYzraMnbCB59On1aHQjrSmF
         NbTMCAJQyT6b/ZtIGIRtDHl39qf8BkcXNralJ9SE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jim@photojim.ca,
        Ben Hutchings <ben@decadent.org.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 121/191] ACPI / extlog: Check for RDMSR failure
Date:   Tue,  3 Nov 2020 21:36:53 +0100
Message-Id: <20201103203244.614399960@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -224,9 +224,9 @@ static int __init extlog_init(void)
 	u64 cap;
 	int rc;
 
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-
-	if (!(cap & MCG_ELOG_P) || !extlog_get_l1addr())
+	if (rdmsrl_safe(MSR_IA32_MCG_CAP, &cap) ||
+	    !(cap & MCG_ELOG_P) ||
+	    !extlog_get_l1addr())
 		return -ENODEV;
 
 	if (edac_get_report_status() == EDAC_REPORTING_FORCE) {


