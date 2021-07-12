Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB33C48B9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbhGLGkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238156AbhGLGj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23A661205;
        Mon, 12 Jul 2021 06:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071784;
        bh=fzRpnx2vPU6mQq96uyKWuxG9StcxCh97J7gGpygdDYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgqncR6NF4M+iozHjLwK61k2cTCGtUNZhtO6lecx9uDQz5wBI0ISoe7eLy6ADJWNN
         kHEla00HQTUpG2gT9qIVSY/lnU8gnY9BLywUrAv4mLQyXGJyHKutjT/TJCaO0KG0hL
         n0ERVbwan2Qnf/rr+2pzFw4dnIs2NX0bXWMrhcME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/593] ACPI: tables: Add custom DSDT file as makefile prerequisite
Date:   Mon, 12 Jul 2021 08:06:01 +0200
Message-Id: <20210712060905.141248014@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 44e412506317..4466156474ee 100644
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



