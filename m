Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81CD3BC038
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhGEPe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232191AbhGEPd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C84561997;
        Mon,  5 Jul 2021 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499054;
        bh=hAVNta6d91vA0pdkMWrny0dPdD0kZ9rrGyEGpV4URqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjP3fnoOM2wC6KH5eS9X1V0YicMeH8a15T0lLmIN+pjY7S0PzWhLXFWTXTIzY2J/r
         MlDzS0jPp68x6+U8As2OB4xYdvE5vc/4dd7bxkiWKu8Tesn83vYzuRb+6do1wD+WGL
         IMEHfUsxDcyiv8CmIZi6zKDewlHEtPwODELiOD5PgHn40mTspgD6xpcGaxKEXVxprj
         Ga3iHQ6634AsqCtPiJoldD41/pJr9MgwXnDNww3EwMWYXw7+wYsnc+7nG7lOUNiVko
         anRet6b76CIUetllHqJJe3lNmjmXjrJ9I+umNoUs3jmKH0Mh6nNnZZapTn9Y89LkIt
         ZGxFISjuwcJMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/26] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon,  5 Jul 2021 11:30:25 -0400
Message-Id: <20210705153039.1521781-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
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
index 54002670cb7a..bbd9c93fc4c2 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1240,6 +1240,7 @@ static int __init acpi_init(void)
 
 	result = acpi_bus_init();
 	if (result) {
+		kobject_put(acpi_kobj);
 		disable_acpi();
 		return result;
 	}
-- 
2.30.2

