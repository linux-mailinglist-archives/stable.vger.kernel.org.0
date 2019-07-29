Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB27993E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbfG2UOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730022AbfG2T2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:28:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BE52171F;
        Mon, 29 Jul 2019 19:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428530;
        bh=AQNp5ECe9sgyjFWOGgvv1e6tRkk2iwL30xwMF+qUeZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9EnJhSZ3jwZdGyexIDK9WfXewr0s1Wr0UcVpjQMx0f5zUBg6G9JUyUX51xydxT/W
         k/b06tnSa2j7QqRKd3va9gJCqC3SJxXjVnRmeFw5iREfFNnQppgyKdfKZuQLVt2mis
         m+wFhEM5tBGlorXQR7pkYao4U4//Vmh9PJgaBEdU=
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
Subject: [PATCH 4.14 066/293] acpi/arm64: ignore 5.1 FADTs that are reported as 5.0
Date:   Mon, 29 Jul 2019 21:19:17 +0200
Message-Id: <20190729190829.714016734@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index b3162715ed78..285f0b4851fc 100644
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



