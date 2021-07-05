Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2153BC0B3
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhGEPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233428AbhGEPgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB7A061990;
        Mon,  5 Jul 2021 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499110;
        bh=v7iF50Bzn4if2LlZ1Ia8/TQL6XSxe8GjQb6u9hcTzT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJYbh7Z67aLPaD/uX+fpoSh8MmuY/1D96wN4DMF7m5Dxn/k7QlThDtMf4LNGlZJro
         fOawS9EeRF0oh1x6/3p0K9kRaCfhJq7IzMMeIe6IZZfcwv372XzsIEkCiqTSLQRClX
         XRfV6mCNIJ7GBLwunzo+yYtglZeYN7Yo1YrLKKzPSZgaCT0eup1SEz7hHys17TWQ6L
         hnGGEXNYqUi3/uU+gIn1K7qN6mlyP+MyW2MbenS8ULx2bnxYVgfQ/4GgiHvyYnMD3r
         Y+85W5mu5NrQUWt0prpO/1WvnpGfzyH4xu9sgDyeSyeHTQYgNXgc/ZJ1KEkm7iJQei
         U1xLT6iqcq89w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 11/15] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:31:32 -0400
Message-Id: <20210705153136.1522245-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
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
index 1cb7c6a52f61..7ea02bb50c73 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1249,6 +1249,7 @@ static int __init acpi_init(void)
 	init_acpi_device_notify();
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2

