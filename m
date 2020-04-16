Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15491AC7AA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbgDPO5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392535AbgDPNzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7BF020732;
        Thu, 16 Apr 2020 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045332;
        bh=0ZzAX2FSs2sfE8UahH9v8hh73bqQgv9fyahjVD79mw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNQJ8Bp3jWgdmQtQVrGLGBun2sHipDkeYBIhKeOa02ZykWv0UmNgKL9y2Mb/misPV
         liFZ3j6z+8e5zORAGYAkqpy/FpITl763SdaM4EA6AG++OKLsgyg2l/H/klPn5FZ0cm
         KLub9e7YjPOL1mGbhiGxwv7Fqcv/t38OzXVUCSxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.6 090/254] ACPI: EC: Avoid printing confusing messages in acpi_ec_setup()
Date:   Thu, 16 Apr 2020 15:22:59 +0200
Message-Id: <20200416131337.194760816@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c823c17a8ea4db4943152388a0beb9a556715716 upstream.

It doesn't really make sense to pass ec->handle of the ECDT EC to
acpi_handle_info(), because it is set to ACPI_ROOT_OBJECT in
acpi_ec_ecdt_probe(), so rework acpi_ec_setup() to avoid using
acpi_handle_info() for printing messages.

First, notice that the "Used as first EC" message is not really
useful, because it is immediately followed by a more meaningful one
from either acpi_ec_ecdt_probe() or acpi_ec_dsdt_probe() (the latter
also includes the EC object path), so drop it altogether.

Second, use pr_info() for printing the EC configuration information.

While at it, make the code in question avoid printing invalid GPE or
IRQ numbers and make it print the GPE/IRQ information only when the
driver is ready to handle events.

Fixes: 72c77b7ea9ce ("ACPI / EC: Cleanup first_ec/boot_ec code")
Fixes: 406857f773b0 ("ACPI: EC: add support for hardware-reduced systems")
Cc: 5.5+ <stable@vger.kernel.org> # 5.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1584,14 +1584,19 @@ static int acpi_ec_setup(struct acpi_ec
 		return ret;
 
 	/* First EC capable of handling transactions */
-	if (!first_ec) {
+	if (!first_ec)
 		first_ec = ec;
-		acpi_handle_info(first_ec->handle, "Used as first EC\n");
+
+	pr_info("EC_CMD/EC_SC=0x%lx, EC_DATA=0x%lx\n", ec->command_addr,
+		ec->data_addr);
+
+	if (test_bit(EC_FLAGS_EVENT_HANDLER_INSTALLED, &ec->flags)) {
+		if (ec->gpe >= 0)
+			pr_info("GPE=0x%x\n", ec->gpe);
+		else
+			pr_info("IRQ=%d\n", ec->irq);
 	}
 
-	acpi_handle_info(ec->handle,
-			 "GPE=0x%x, IRQ=%d, EC_CMD/EC_SC=0x%lx, EC_DATA=0x%lx\n",
-			 ec->gpe, ec->irq, ec->command_addr, ec->data_addr);
 	return ret;
 }
 


