Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7543FDB7B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343733AbhIAMlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345047AbhIAMk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 453D661213;
        Wed,  1 Sep 2021 12:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499805;
        bh=4RyrASzB5xiC0pIFKT4U1pwY5jfaK2cnXKgU/ZysE4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ya+mm78lAU6knCA1S/N6HHaymzZUlK8fx8QK2Il82xUibWYQfrv2YBRiP0feto70W
         MGPPhtWuEOT1miZQ0eTUoB9IOaYuE4BFVIer0s37gE6eKtPsuXZmVs9fMSuGcTU2yh
         O6uYJucDt1t5ATkPACFb4A+94RFdc8jY1WKj4R/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Benjamin Berg <bberg@redhat.com>
Subject: [PATCH 5.10 092/103] usb: typec: ucsi: acpi: Always decode connector change information
Date:   Wed,  1 Sep 2021 14:28:42 +0200
Message-Id: <20210901122303.634239910@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <bberg@redhat.com>

commit 47ea2929d58c35598e681212311d35b240c373ce upstream.

Normal commands may be reporting that a connector has changed. Always
call the usci_connector_change handler and let it take care of
scheduling the work when needed.
Doing this makes the ACPI code path identical to the CCG one.

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Benjamin Berg <bberg@redhat.com>
Link: https://lore.kernel.org/r/20201009144047.505957-2-benjamin@sipsolutions.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -103,11 +103,12 @@ static void ucsi_acpi_notify(acpi_handle
 	if (ret)
 		return;
 
+	if (UCSI_CCI_CONNECTOR(cci))
+		ucsi_connector_change(ua->ucsi, UCSI_CCI_CONNECTOR(cci));
+
 	if (test_bit(COMMAND_PENDING, &ua->flags) &&
 	    cci & (UCSI_CCI_ACK_COMPLETE | UCSI_CCI_COMMAND_COMPLETE))
 		complete(&ua->complete);
-	else if (UCSI_CCI_CONNECTOR(cci))
-		ucsi_connector_change(ua->ucsi, UCSI_CCI_CONNECTOR(cci));
 }
 
 static int ucsi_acpi_probe(struct platform_device *pdev)


