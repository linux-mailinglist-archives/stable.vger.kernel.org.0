Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A491B0A3E
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgDTMqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbgDTMqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:46:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF5E620736;
        Mon, 20 Apr 2020 12:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386765;
        bh=hv4cWLPnu3sR62KqgvIlKb9q2gks5q9m242+DGUCV0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TQ9DnhZR1P9eOda0+prpByhWQSlgYR5/4QUFVDmu8irmhjeJVAC53ZvlOo9y8c7I
         bffeif847cA0MWgtJVws9iCMw1bKMpBaEnf41IOohPRCeqsnWYfh863fFdXgB3bfcz
         4HjnjFfxbX1E8S6aejpT2pzki8F+5/Z88cyKfeic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/60] Revert "ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()"
Date:   Mon, 20 Apr 2020 14:38:56 +0200
Message-Id: <20200420121506.546978281@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit ce7a61a0d57d2dd613941d8aef82a5b54fb2e396 which is
commit 65a691f5f8f0bb63d6a82eec7b0ffd193d8d8a5f upstream.

Rafael writes:
	It has not been marked for -stable or otherwise requested to be
	included AFAICS.  Also it depends on other mainline commits that
	have not been included into 5.6.5.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1573,6 +1573,7 @@ static int acpi_ec_add(struct acpi_devic
 
 		if (boot_ec && ec->command_addr == boot_ec->command_addr &&
 		    ec->data_addr == boot_ec->data_addr) {
+			boot_ec_is_ecdt = false;
 			/*
 			 * Trust PNP0C09 namespace location rather than
 			 * ECDT ID. But trust ECDT GPE rather than _GPE
@@ -1592,12 +1593,9 @@ static int acpi_ec_add(struct acpi_devic
 
 	if (ec == boot_ec)
 		acpi_handle_info(boot_ec->handle,
-				 "Boot %s EC initialization complete\n",
+				 "Boot %s EC used to handle transactions and events\n",
 				 boot_ec_is_ecdt ? "ECDT" : "DSDT");
 
-	acpi_handle_info(ec->handle,
-			 "EC: Used to handle transactions and events\n");
-
 	device->driver_data = ec;
 
 	ret = !!request_region(ec->data_addr, 1, "EC data");


