Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02953BC0A2
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhGEPg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232816AbhGEPfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:35:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D99161AC0;
        Mon,  5 Jul 2021 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499103;
        bh=5KqFaq0lcX9UFg/77cuYyckorO3nTTfDYTCY9UOwWyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHCsTZtNjoUa7JSz+jo1odvYAmKr5fAnH45MuYMGgJndKWXoebTpPj4A4dR0YjeGc
         YHFw34VcG1ZG7qETaSB6KE1Ov5akr21ccYizqTvsF0XQSmqEBVCVXT+nisMaJD8DoC
         TM53yiAPdI9MqVDJsNLjxGv7V2pysvakn7Z1UwXvn4nTb0KTGhlIpiwYIRq57VE5nQ
         0gZi52xlXRGNkpP4oTlIJ0HVyrt+qeSb+OZPfIHUC4LthIRcMwoZiEXMQl2llQxKs7
         3y501wmZtP5JRbu97DET8Ku6TfZ3jztHd6aKrnG0jteUvAUBSINNHf6CQNPZU0brjP
         YQELuaLdWNYRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Chiu <chris.chiu@canonical.com>,
        Jian-Hong Pan <jhp@endlessos.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/15] ACPI: EC: Make more Asus laptops use ECDT _GPE
Date:   Mon,  5 Jul 2021 11:31:26 -0400
Message-Id: <20210705153136.1522245-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 6306f0431914beaf220634ad36c08234006571d5 ]

More ASUS laptops have the _GPE define in the DSDT table with a
different value than the _GPE number in the ECDT.

This is causing media keys not working on ASUS X505BA/BP, X542BA/BP

Add model info to the quirks list.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 37aacb39e692..f8fc30be6871 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1886,6 +1886,22 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "GL702VMK"),}, NULL},
 	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X505BA", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X505BA"),}, NULL},
+	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X505BP", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X505BP"),}, NULL},
+	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X542BA", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X542BA"),}, NULL},
+	{
+	ec_honor_ecdt_gpe, "ASUSTeK COMPUTER INC. X542BP", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "X542BP"),}, NULL},
+	{
 	ec_honor_ecdt_gpe, "ASUS X550VXK", {
 	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "X550VXK"),}, NULL},
-- 
2.30.2

