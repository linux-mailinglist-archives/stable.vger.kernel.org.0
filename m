Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499211B099B
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgDTMkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgDTMkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04ACA2070B;
        Mon, 20 Apr 2020 12:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386432;
        bh=RexPW0sUzuNzCRg2RHBHDFYUpB/jVvp7IwsrhECKk7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9ySpuG1mOzkKta1188VCYved6neW//GVGKZhPKlt/brtntnX/fWcf3gErA3RXaHV
         rIhezHxn3RTskqmqwmwNAJQoRByYStE32tzZEe+fUv0RscXeHS/MXkT20nLW4cfYQS
         lY399/AmZqvtZNWkT+KfGACp3pOInanSpO3c0FPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 20/65] Revert "ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()"
Date:   Mon, 20 Apr 2020 14:38:24 +0200
Message-Id: <20200420121510.727951157@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit e8eab1acd6cdf142fb93c47201a1ae1f3dcbfc5f which is
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
@@ -1654,6 +1654,7 @@ static int acpi_ec_add(struct acpi_devic
 
 		if (boot_ec && ec->command_addr == boot_ec->command_addr &&
 		    ec->data_addr == boot_ec->data_addr) {
+			boot_ec_is_ecdt = false;
 			/*
 			 * Trust PNP0C09 namespace location rather than
 			 * ECDT ID. But trust ECDT GPE rather than _GPE
@@ -1673,12 +1674,9 @@ static int acpi_ec_add(struct acpi_devic
 
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


