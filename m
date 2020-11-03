Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B872A5691
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732981AbgKCU6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:58:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731757AbgKCU6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:58:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CC53223AC;
        Tue,  3 Nov 2020 20:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437116;
        bh=Or27/3b6cRIcdARZiqOBJNlM//9C/2yDExnkL/5Hcgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zt+ujbMgUramFXieDjZGvHxcITYWX/iEEXtlzA2JXTjLKOBWSKaoxsFA2M/MIWiLP
         gPCGdj/IUdbtMd2wAvC7kAZ0eRgQYrbqo2WBCdPpmJ+795uHng9HWPF2fCCARAz4c2
         +slj5uJm20j0gDoHf3k3bljssZl4UNAb4CBPH6fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 116/214] ACPI: EC: PM: Drop ec_no_wakeup check from acpi_ec_dispatch_gpe()
Date:   Tue,  3 Nov 2020 21:36:04 +0100
Message-Id: <20201103203301.754728418@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e0e9ce390d7bc6a705653d4a8aa4ea92c9a65e53 upstream.

It turns out that in some cases there are EC events to flush in
acpi_ec_dispatch_gpe() even though the ec_no_wakeup kernel parameter
is set and the EC GPE is disabled while sleeping, so drop the
ec_no_wakeup check that prevents those events from being processed
from acpi_ec_dispatch_gpe().

Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1968,9 +1968,6 @@ bool acpi_ec_dispatch_gpe(void)
 	if (acpi_any_gpe_status_set(first_ec->gpe))
 		return true;
 
-	if (ec_no_wakeup)
-		return false;
-
 	/*
 	 * Dispatch the EC GPE in-band, but do not report wakeup in any case
 	 * to allow the caller to process events properly after that.


