Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE533BC0AF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhGEPhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233435AbhGEPgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF32261A1D;
        Mon,  5 Jul 2021 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499112;
        bh=Cu5gKInQhBuXt9wr8GYj+02+hl0rME7bI/i5jZLGIFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AL2HqlqHKyxXDzHaFs8Pzv9JaunE6lmHQdxqJhfGmC5WPRew6kCl/zM2YGRtTSsNC
         cpaZ4MsfFT5oYyAO9UDQFVYp8mRvaoVUjPdChOaxzePDjLsCAw1XRlR05yr1o/RMiK
         oqd3y6OG00ho9mdi4fY7Mc91Jx+TEKVr4FqAwuiTCmY9s/MQJF9uHJAwfGc4tUDDZk
         pF4j95C8kPUIXCciHMWFD+zXl0yISRjAT2CoePsDDC4YV+aeHye5bqbAlQFoS30Dqx
         Jwj2rafje0/NaoU+bRwdeJLFbtMJAWmG/5A1dV05k5COEp74cVRfWwNHylCw446l+I
         XqG8Tf49ubiMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/15] ACPI: tables: Add custom DSDT file as makefile prerequisite
Date:   Mon,  5 Jul 2021 11:31:34 -0400
Message-Id: <20210705153136.1522245-13-sashal@kernel.org>
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
index cd1abc9bc325..f9df9541f2ce 100644
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

