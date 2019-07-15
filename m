Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA49068D09
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbfGONzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732652AbfGONzv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:55:51 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 295F22083D;
        Mon, 15 Jul 2019 13:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198950;
        bh=YpG3AhvVLglUl7U+IE6syFVZYiEqt9btFZ34/cE+A20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zU/lpYsguW4T4o30AkRj3i0BWaVblIPg7DBXOK0W3hQqE/JD4tuOivCbNiXv86iBJ
         w8KQ4QWGx4A7SoFllvDQyEkp0Y/legIAaP6Mg2+vw2tKyWCl8nEyw0/DH09PmUJpKx
         Wccoc30pgwIj8j2AJ/7vLeTopvHWIkfCgFTpt6jA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lee Jones <lee.jones@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 150/249] acpi/arm64: ignore 5.1 FADTs that are reported as 5.0
Date:   Mon, 15 Jul 2019 09:45:15 -0400
Message-Id: <20190715134655.4076-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 2af22f3ec3ca452f1e79b967f634708ff01ced8a ]

Some Qualcomm Snapdragon based laptops built to run Microsoft Windows
are clearly ACPI 5.1 based, given that that is the first ACPI revision
that supports ARM, and introduced the FADT 'arm_boot_flags' field,
which has a non-zero field on those systems.

So in these cases, infer from the ARM boot flags that the FADT must be
5.1 or later, and treat it as 5.1.

Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Graeme Gregory <graeme.gregory@linaro.org>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/acpi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 2804330c95dc..3a58e9db5cfe 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -152,10 +152,14 @@ static int __init acpi_fadt_sanity_check(void)
 	 */
 	if (table->revision < 5 ||
 	   (table->revision == 5 && fadt->minor_revision < 1)) {
-		pr_err("Unsupported FADT revision %d.%d, should be 5.1+\n",
+		pr_err(FW_BUG "Unsupported FADT revision %d.%d, should be 5.1+\n",
 		       table->revision, fadt->minor_revision);
-		ret = -EINVAL;
-		goto out;
+
+		if (!fadt->arm_boot_flags) {
+			ret = -EINVAL;
+			goto out;
+		}
+		pr_err("FADT has ARM boot flags set, assuming 5.1\n");
 	}
 
 	if (!(fadt->flags & ACPI_FADT_HW_REDUCED)) {
-- 
2.20.1

