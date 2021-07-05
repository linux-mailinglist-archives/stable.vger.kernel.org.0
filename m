Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188543BC103
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhGEPiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233105AbhGEPhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:37:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64904619C8;
        Mon,  5 Jul 2021 15:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499135;
        bh=QOY03wTlX/CMjWwkWu3pHzGGekmK57YqisyZ77PQhtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmruyhxoRQaBJh9o7dDYGfwKhhIGfTWAcM5ljW691I1+SC+yAU5wGLqk9HFIhxf8P
         RkIwzfdQyZ07ON/R59b/1d5g8WJBpYkyQLuUpP7COKXtlkQrv8IiSM4HN+ZUMrRaWU
         PZcUhfVEmHId+3kN8Uc8QWn3BDZ3qWTocwlJ3CaHZjpy45d8JI7+q/ewm3USjeyDfw
         X56u/dWy+5CCfQMGc7/XmvhJ8cZMmMc1mte2gnsaMt/AxFiOHflAF/ijqezNOwk725
         1r8JTv8k5NFqouTVwLtE9xpgbYTmH3D6riaawiIJzU/6qCMaggclVjC0JS+cF2G265
         gkGinop8OsNzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/7] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:32:05 -0400
Message-Id: <20210705153208.1522553-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153208.1522553-1-sashal@kernel.org>
References: <20210705153208.1522553-1-sashal@kernel.org>
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
index 521d1b28760c..d016eba51a95 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1087,6 +1087,7 @@ static int __init acpi_init(void)
 	init_acpi_device_notify();
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2

