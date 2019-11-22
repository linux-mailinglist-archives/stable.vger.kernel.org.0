Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9214106122
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVFyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfKVFxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE892068F;
        Fri, 22 Nov 2019 05:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401989;
        bh=DqeW1U78vlTUIlsSZ6UY5jGKiwesidoeQuHKuMlvuJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK5KdBqaWiD+JOm/8CPRdG89yDO+nf4SDbOJcITUi1qpNBjArn70DSlmCWX6v7OOE
         H1p1xuEhqYlERej8cwO53i33fe4nSvxv6jQM82ALmPpwhFMM5H9NGrR+XCQMCNnCcx
         CbnQnksFbbxosKjgSLwnu2mYvjo2dX6KCGandiUE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>, Borislav Petkov <bp@suse.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 207/219] ACPI / APEI: Don't wait to serialise with oops messages when panic()ing
Date:   Fri, 22 Nov 2019 00:48:58 -0500
Message-Id: <20191122054911.1750-199-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 78b0b690f6558ed788dccafa45965325dd11ba89 ]

oops_begin() exists to group printk() messages with the oops message
printed by die(). To reach this caller we know that platform firmware
took this error first, then notified the OS via NMI with a 'panic'
severity.

Don't wait for another CPU to release the die-lock before panic()ing,
our only goal is to print this fatal error and panic().

This code is always called in_nmi(), and since commit 42a0bb3f7138
("printk/nmi: generic solution for safe printk in NMI"), it has been
safe to call printk() from this context. Messages are batched in a
per-cpu buffer and printed via irq-work, or a call back from panic().

Link: https://patchwork.kernel.org/patch/10313555/
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f008ba7c9cedc..0c46b79e31b1e 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -33,7 +33,6 @@
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/cper.h>
-#include <linux/kdebug.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/ratelimit.h>
@@ -949,7 +948,6 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 
 		sev = ghes_severity(ghes->estatus->error_severity);
 		if (sev >= GHES_SEV_PANIC) {
-			oops_begin();
 			ghes_print_queued_estatus();
 			__ghes_panic(ghes);
 		}
-- 
2.20.1

