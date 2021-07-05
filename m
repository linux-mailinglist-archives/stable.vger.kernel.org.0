Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36693BBFEE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhGEPdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232692AbhGEPdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DE79619AA;
        Mon,  5 Jul 2021 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499025;
        bh=gD4mp4a9Q6gxyCGTWtos+XvRDZiiDOibuXhFg6BVkpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M05v4UWSDBedppTHE4TP56UgUcPspIBtr2W0pv9eV9P07vZFi9r8sTsVLMQFktprK
         Ug7VXibo5Kiq7a2P14wqxo28D7eJsToTzIVnl40BX2iOmnOP9gQM58BDowUaJ5+C5Q
         iheczwCT2FIoq4t2ezkQk5wCn2X0xxvJ1XVAs99r6WK+wTx55RmWfSqFN4QwXy5Ixe
         Tc7+AkRD3p7YxopKSLVJFnf0eLxLROfMHehcVuEId7rqJKlmzNgGxIeWcooKcqUukA
         NN0JhKRAztOMNdizimdcACUnkT1cESvR/QohfmbB5qCkfHXl9n+ezTOGx3EZoDf31H
         Ni59rU0ge2NZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/41] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:29:39 -0400
Message-Id: <20210705153001.1521447-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153001.1521447-1-sashal@kernel.org>
References: <20210705153001.1521447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 4ac7a817f1992103d4e68e9837304f860b5e7300 ]

Although the system will not be in a good condition or it will not
boot if acpi_bus_init() fails, it is still necessary to put the
kobject in the error path before returning to avoid leaking memory.

Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 1682f8b454a2..e317214aabec 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1245,6 +1245,7 @@ static int __init acpi_init(void)
 
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2

