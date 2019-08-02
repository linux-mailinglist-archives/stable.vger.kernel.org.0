Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D1F7F1D9
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391930AbfHBJmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391926AbfHBJmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB674217D6;
        Fri,  2 Aug 2019 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738964;
        bh=lepQzYX7YjyN1jZN4ayvq/iA11ZCONR178Epf1Sy2hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlm6Mx7526jSR4/uA5aYTrbXXudPunmtBIZN6vXaNxqtJuIPDsd1ftmb34lUf0c5G
         9z/QuQjAC18v9BEJPUOv0YAXs34CFrmst5mSnTawTb2EclHEmXkCo8s762MpDc+sDO
         xAR1nC3onkPtrjaQ/yL+G+//zZAoTLquS4uGdnGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Lee Jones <lee.jones@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 049/223] acpi/arm64: ignore 5.1 FADTs that are reported as 5.0
Date:   Fri,  2 Aug 2019 11:34:34 +0200
Message-Id: <20190802092242.086830110@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 252a6d9c1da5..1a95d135def2 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -157,10 +157,14 @@ static int __init acpi_fadt_sanity_check(void)
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



