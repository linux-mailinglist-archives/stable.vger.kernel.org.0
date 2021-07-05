Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB183BC0CC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhGEPhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233506AbhGEPgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E30AD61C18;
        Mon,  5 Jul 2021 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499123;
        bh=I3izLJNUmoAdfeCBSK9qtUKZYViYQap6iNtnK9J94ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvLXoPzj1BflofhAbtQ74Mfv7xNLBKX0fiq2cArNWl3Idthm55lK3NeO/HF4fBaza
         oiRZNW+sW9xNnEj6p5ld0A//unpq9Jb4xvWJjRt2R5nPnbLgXMXH26hFIOlZbg7xrN
         ljC9vtf2xz8Nx5ok09kmG/V+w/TVQPm1AP+pkwRY0bS3TY/3/CM4ykSdDaaUKCblft
         g7wWA7kEgUWgd4MGQBYYEtOzwDTglEcvWGWieAjDM93g3hzfQBiKmSGJ62BDIzOTHv
         e9aadu9It2w6r9qBcfICz1za5mz5d5P914EsenFDvHDr98SspysquTXQtjdtnb1hrZ
         XNQ7YFspef6kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/9] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:31:52 -0400
Message-Id: <20210705153155.1522423-6-sashal@kernel.org>
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
index 6b2c9d68d810..1c13e5fe10d9 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1184,6 +1184,7 @@ static int __init acpi_init(void)
 	init_acpi_device_notify();
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2

