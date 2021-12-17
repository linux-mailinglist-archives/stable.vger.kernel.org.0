Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE0478D50
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhLQOVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:21:07 -0500
Received: from foss.arm.com ([217.140.110.172]:57954 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234555AbhLQOVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Dec 2021 09:21:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC7F91474;
        Fri, 17 Dec 2021 06:21:06 -0800 (PST)
Received: from usa.arm.com (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EA63C3F5A1;
        Fri, 17 Dec 2021 06:21:05 -0800 (PST)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, linux-kernel@vger.kernel.org,
        Pedro Batista <pedbap.g@gmail.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [BACKPORT v4.9 - v4.19] firmware: arm_scpi: Fix string overflow in SCPI genpd driver
Date:   Fri, 17 Dec 2021 14:20:56 +0000
Message-Id: <20211217142056.866487-1-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 865ed67ab955428b9aa771d8b4f1e4fb7fd08945 upstream.

Without the bound checks for scpi_pd->name, it could result in the buffer
overflow when copying the SCPI device name from the corresponding device
tree node as the name string is set at maximum size of 30.

Let us fix it by using devm_kasprintf so that the string buffer is
allocated dynamically.

Fixes: 8bec4337ad40 ("firmware: scpi: add device power domain support using genpd")
Reported-by: Pedro Batista <pedbap.g@gmail.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org #v4.9, v4.14, v4.19
Cc: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20211209120456.696879-1-sudeep.holla@arm.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/firmware/scpi_pm_domain.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/scpi_pm_domain.c b/drivers/firmware/scpi_pm_domain.c
index f395dec27113..a6e62a793fbe 100644
--- a/drivers/firmware/scpi_pm_domain.c
+++ b/drivers/firmware/scpi_pm_domain.c
@@ -27,7 +27,6 @@ struct scpi_pm_domain {
 	struct generic_pm_domain genpd;
 	struct scpi_ops *ops;
 	u32 domain;
-	char name[30];
 };
 
 /*
@@ -121,8 +120,13 @@ static int scpi_pm_domain_probe(struct platform_device *pdev)
 
 		scpi_pd->domain = i;
 		scpi_pd->ops = scpi_ops;
-		sprintf(scpi_pd->name, "%s.%d", np->name, i);
-		scpi_pd->genpd.name = scpi_pd->name;
+		scpi_pd->genpd.name = devm_kasprintf(dev, GFP_KERNEL,
+						     "%s.%d", np->name, i);
+		if (!scpi_pd->genpd.name) {
+			dev_err(dev, "Failed to allocate genpd name:%s.%d\n",
+				np->name, i);
+			continue;
+		}
 		scpi_pd->genpd.power_off = scpi_pd_power_off;
 		scpi_pd->genpd.power_on = scpi_pd_power_on;
 
-- 
2.25.1

