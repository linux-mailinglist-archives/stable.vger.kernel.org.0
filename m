Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4129D3BC0D1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhGEPhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233529AbhGEPg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B82161C1D;
        Mon,  5 Jul 2021 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499125;
        bh=fV6bIYL1TAT2KqUVFIlxoCnLkvrPe4BRbeM0ImjmfBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIgOT+uJkuTSBD9gsqKJkgDdbNwDG8lrcfXviEqQvqV/43NNvUOrB3bDLl7tQDmRP
         wEsz1yfpjxP2OCjWDc1fkNMKMImJTargwG9I7EuDy8YxZ27H3k0c+wH6Wrr4gINijZ
         gWQbbRpzkeWT6wNaiagfBs+PmyHsgJ5b+x5afEE7NwMBtbwXaGkZBQMJnYOGS7oflK
         koImz0RZjrpYUg5KOQGE2v/tMIhFMbqB0ZtkJgGwc1AiU07zXEq60XPJTWzR04JxPB
         gN79edWyfW/J8rqVtLDshP8cV88qFh1quavbvS37CQiHHIkED52t3UrmzxK8yoxX8Z
         HKuWM2Ic1baqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/9] ACPI: tables: Add custom DSDT file as makefile prerequisite
Date:   Mon,  5 Jul 2021 11:31:54 -0400
Message-Id: <20210705153155.1522423-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153155.1522423-1-sashal@kernel.org>
References: <20210705153155.1522423-1-sashal@kernel.org>
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
index 4c5678cfa9c4..c466d7bc861a 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -7,6 +7,11 @@ ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
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

