Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8946E804
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 13:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhLIMIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 07:08:39 -0500
Received: from foss.arm.com ([217.140.110.172]:55442 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237070AbhLIMIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 07:08:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDC872B;
        Thu,  9 Dec 2021 04:05:05 -0800 (PST)
Received: from usa.arm.com (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9AB583F5A1;
        Thu,  9 Dec 2021 04:05:04 -0800 (PST)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     linux-kernel@vger.kernel.org, soc@kernel.org, arm@kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Pedro Batista <pedbap.g@gmail.com>,
        Cristian Marussi <cristian.marussi@arm.com>
Subject: [PATCH v2] firmware: arm_scpi: Fix string overflow in SCPI genpd driver
Date:   Thu,  9 Dec 2021 12:04:56 +0000
Message-Id: <20211209120456.696879-1-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Without the bound checks for scpi_pd->name, it could result in the buffer
overflow when copying the SCPI device name from the corresponding device
tree node as the name string is set at maximum size of 30.

Let us fix it by using devm_kasprintf so that the string buffer is
allocated dynamically.

Cc: stable@vger.kernel.org
Fixes: 8bec4337ad40 ("firmware: scpi: add device power domain support using genpd")
Reported-by: Pedro Batista <pedbap.g@gmail.com>
Cc: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 drivers/firmware/scpi_pm_domain.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Hi ARM SoC team,

Can you apply this directly as I don't have any other fix at the moment.

Regards,
Sudeep

v1->v2:
	- Fixed accidentally dropped '.' in the name
	- Used devm_kasprintf instead of combination of kasprintf and
	  devm_kstrdup

v1: https://lore.kernel.org/r/20211206153150.565685-1-sudeep.holla@arm.com/

diff --git a/drivers/firmware/scpi_pm_domain.c b/drivers/firmware/scpi_pm_domain.c
index 51201600d789..800673910b51 100644
--- a/drivers/firmware/scpi_pm_domain.c
+++ b/drivers/firmware/scpi_pm_domain.c
@@ -16,7 +16,6 @@ struct scpi_pm_domain {
 	struct generic_pm_domain genpd;
 	struct scpi_ops *ops;
 	u32 domain;
-	char name[30];
 };

 /*
@@ -110,8 +109,13 @@ static int scpi_pm_domain_probe(struct platform_device *pdev)

 		scpi_pd->domain = i;
 		scpi_pd->ops = scpi_ops;
-		sprintf(scpi_pd->name, "%pOFn.%d", np, i);
-		scpi_pd->genpd.name = scpi_pd->name;
+		scpi_pd->genpd.name = devm_kasprintf(dev, GFP_KERNEL,
+						     "%pOFn.%d", np, i);
+		if (!scpi_pd->genpd.name) {
+			dev_err(dev, "Failed to allocate genpd name:%pOFn.%d\n",
+				np, i);
+			continue;
+		}
 		scpi_pd->genpd.power_off = scpi_pd_power_off;
 		scpi_pd->genpd.power_on = scpi_pd_power_on;

--
2.25.1

