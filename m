Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B0C40961C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347123AbhIMOsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346236AbhIMOqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FF06321D;
        Mon, 13 Sep 2021 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541520;
        bh=P47A4EtjqGRKwQlLlvdFzcGgy/zmVjDudGfV3o6Y2dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kid79A/uqNqlNwp2uhgZKPc7SbjN9/H++ENpeYvaR1NDyAO+lvDrQj9F5Pn2iMU18
         cZNxw8Xq9UT5IfVz2nZT1cZTy0a6EOetAvUjKlKv+jc/HerZhmWsao+ui2TMMV38LQ
         f4tLxygUCXiHBOhdrBeZvdxtJ5pSZuWor2tMd6ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.14 329/334] ACPI: PRM: Find PRMT table before parsing it
Date:   Mon, 13 Sep 2021 15:16:23 +0200
Message-Id: <20210913131124.562905529@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aubrey Li <aubrey.li@intel.com>

commit 3265cc3ec52e75fc8daf189954cebda27ad26b2e upstream.

Find and verify PRMT before parsing it, which eliminates a
warning on machines without PRMT:

	[    7.197173] ACPI: PRMT not present

Fixes: cefc7ca46235 ("ACPI: PRM: implement OperationRegion handler for the PlatformRtMechanism subtype")
Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: 5.14+ <stable@vger.kernel.org> # 5.14+
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/prmt.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -288,10 +288,18 @@ invalid_guid:
 
 void __init init_prmt(void)
 {
+	struct acpi_table_header *tbl;
 	acpi_status status;
-	int mc = acpi_table_parse_entries(ACPI_SIG_PRMT, sizeof(struct acpi_table_prmt) +
+	int mc;
+
+	status = acpi_get_table(ACPI_SIG_PRMT, 0, &tbl);
+	if (ACPI_FAILURE(status))
+		return;
+
+	mc = acpi_table_parse_entries(ACPI_SIG_PRMT, sizeof(struct acpi_table_prmt) +
 					  sizeof (struct acpi_table_prmt_header),
 					  0, acpi_parse_prmt, 0);
+	acpi_put_table(tbl);
 	/*
 	 * Return immediately if PRMT table is not present or no PRM module found.
 	 */


