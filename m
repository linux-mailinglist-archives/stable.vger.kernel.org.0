Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22D93BC041
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhGEPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhGEPeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A18619B4;
        Mon,  5 Jul 2021 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499064;
        bh=tUscZYqNKtQK/14FPL202v1ysf+GerKJT/5b0/XDNiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHlLl2dyQvmwEyVtrFJqsdC5VYYBuNuMtUi6+OgjiRirX0BAZgcm+/wHODQ0pWr20
         Duwhcp6EaWPVbrEBiHwGnVvriUUiG5iuSvjMfpbkBnkxboDnACaZp8nXr4v927UNP7
         rYWsJhhIceJAP7oLwrGPHQbB8FBuXcmt1ESr/T1EA4A9+7571ct4pOpuJUR90H4yv8
         sOAFNd3I1UWOItB5uuSnsdUTdkvpJGGCouMuHIJRzgFiMKx9wNyttDMEpLo21L7SUa
         UvGzSJ777nCtekRvqGYOxOIr5hsVLNcs+FWaqH4tM4dqz3U31cvRAeDC3aUqe1z5Nn
         5sDepLcDlQIkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/26] ACPI: tables: Add custom DSDT file as makefile prerequisite
Date:   Mon,  5 Jul 2021 11:30:33 -0400
Message-Id: <20210705153039.1521781-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d1059c1b1146870c52f3dac12cb7b6cbf39ed27f ]

A custom DSDT file is mostly used during development or debugging,
and in that case it is quite likely to want to rebuild the kernel
after changing ONLY the content of the DSDT.

This patch adds the custom DSDT as a prerequisite to tables.o
to ensure a rebuild if the DSDT file is updated. Make will merge
the prerequisites from multiple rules for the same target.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index ef1ac4d127da..1c81504046d4 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -8,6 +8,11 @@ ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 #
 # ACPI Boot-Time Table Parsing
 #
+ifeq ($(CONFIG_ACPI_CUSTOM_DSDT),y)
+tables.o: $(src)/../../include/$(subst $\",,$(CONFIG_ACPI_CUSTOM_DSDT_FILE)) ;
+
+endif
+
 obj-$(CONFIG_ACPI)		+= tables.o
 obj-$(CONFIG_X86)		+= blacklist.o
 
-- 
2.30.2

