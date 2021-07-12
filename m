Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A97F3C4CA8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbhGLHGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243568AbhGLHFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BF28610E5;
        Mon, 12 Jul 2021 07:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073333;
        bh=MPFBS+A6c3odh1pN+vIUijy2uFTRPT9dQxfejmj/eSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsxqD1Uh+omSOVV3MzNgqroyhrXVGZ8OTe+mwa9NjvEVtkv6wi4M3iKqdIhPW1KQT
         j2ghYiNzWx8Fj1FpZgaxYlxFBIk9nILCfR4sjwNHKxTJR95RWrz+9wDbScwBDszM57
         EYvj15JQb7owNyNX4YpDyR2EIP4hskfWOlIEqPOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Jian-Hong Pan <jhp@endlessos.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 205/700] ACPI: EC: Make more Asus laptops use ECDT _GPE
Date:   Mon, 12 Jul 2021 08:04:48 +0200
Message-Id: <20210712060955.866167051@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 13565629ce0a..e8c5da2b964a 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1846,6 +1846,22 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
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



