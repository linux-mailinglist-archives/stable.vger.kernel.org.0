Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7954B3BC07C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhGEPgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbhGEPfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:35:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB9D2619C3;
        Mon,  5 Jul 2021 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499089;
        bh=gCYkJ+EsoqmEnBOC4tgRbE1MyFFuqUjlAaZ3W1U/j+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7BtrPVYUFpN3dvawHEcabpzWjEdwiOKaLrxlLyfE2OuOa7bNdzdFbmU5ZDO4AhCX
         IyJeOMZHuruLO/zQPaD8rG1WZMw8egrsrbQpP2pR7t52eaYALY2y2jwCAddkGKIB4P
         4hMX7fdEbqKwsTY5w+IfXl5AeYH6vUaO4VnL/h13WfEtROwq+jhcU6KbdZgtIeKh/t
         OtuTwhMbXIVLEOjeQFERRfwCUjM+1nw5b0LU6j6JV78VjJjpeUnnAL/mDUseZodt8f
         X2c79gdRWc1IAVkrZXedp/c6sGPF8UX2kF9b9cz9goRpYCaN+H1WNJBWrHFnVo3aob
         c77Pc1pxForUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/17] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:31:08 -0400
Message-Id: <20210705153114.1522046-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153114.1522046-1-sashal@kernel.org>
References: <20210705153114.1522046-1-sashal@kernel.org>
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
index d60e57d14c85..d9dc9d2f38d5 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1240,6 +1240,7 @@ static int __init acpi_init(void)
 	init_acpi_device_notify();
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2

