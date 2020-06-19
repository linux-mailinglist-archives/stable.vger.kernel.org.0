Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80F6201875
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbgFSQsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733303AbgFSOkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:40:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDA621556;
        Fri, 19 Jun 2020 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577610;
        bh=hfapDkEfZmE1hECKHBeJP8PA9TACADmdyv6ViXtOqws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjmM2MahXkgxn17jaaDaZa8JtsrPnmzONYZEkrqJolf90whg663DyhEGCpGKsUKBR
         +XAPNTOG64RsQ6GAi+kPBRi838L0Lwc/9zwX6EwaE3svM1tSBhrvTLOQaB117bkGRB
         8kbxZX/kpLMfXGOQtOlT11lEa3y8SubV64JPcmnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 018/128] ACPI: GED: add support for _Exx / _Lxx handler methods
Date:   Fri, 19 Jun 2020 16:31:52 +0200
Message-Id: <20200619141621.125988620@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit ea6f3af4c5e63f6981c0b0ab8ebec438e2d5ef40 upstream.

Per the ACPI spec, interrupts in the range [0, 255] may be handled
in AML using individual methods whose naming is based on the format
_Exx or _Lxx, where xx is the hex representation of the interrupt
index.

Add support for this missing feature to our ACPI GED driver.

Cc: v4.9+ <stable@vger.kernel.org> # v4.9+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/evged.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/acpi/evged.c
+++ b/drivers/acpi/evged.c
@@ -82,6 +82,8 @@ static acpi_status acpi_ged_request_inte
 	struct resource r;
 	struct acpi_resource_irq *p = &ares->data.irq;
 	struct acpi_resource_extended_irq *pext = &ares->data.extended_irq;
+	char ev_name[5];
+	u8 trigger;
 
 	if (ares->type == ACPI_RESOURCE_TYPE_END_TAG)
 		return AE_OK;
@@ -90,14 +92,28 @@ static acpi_status acpi_ged_request_inte
 		dev_err(dev, "unable to parse IRQ resource\n");
 		return AE_ERROR;
 	}
-	if (ares->type == ACPI_RESOURCE_TYPE_IRQ)
+	if (ares->type == ACPI_RESOURCE_TYPE_IRQ) {
 		gsi = p->interrupts[0];
-	else
+		trigger = p->triggering;
+	} else {
 		gsi = pext->interrupts[0];
+		trigger = p->triggering;
+	}
 
 	irq = r.start;
 
-	if (ACPI_FAILURE(acpi_get_handle(handle, "_EVT", &evt_handle))) {
+	switch (gsi) {
+	case 0 ... 255:
+		sprintf(ev_name, "_%c%02hhX",
+			trigger == ACPI_EDGE_SENSITIVE ? 'E' : 'L', gsi);
+
+		if (ACPI_SUCCESS(acpi_get_handle(handle, ev_name, &evt_handle)))
+			break;
+		/* fall through */
+	default:
+		if (ACPI_SUCCESS(acpi_get_handle(handle, "_EVT", &evt_handle)))
+			break;
+
 		dev_err(dev, "cannot locate _EVT method\n");
 		return AE_ERROR;
 	}


