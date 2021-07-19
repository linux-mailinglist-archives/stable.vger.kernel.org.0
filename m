Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C023CDCD4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhGSOx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239402AbhGSOun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF7961073;
        Mon, 19 Jul 2021 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708682;
        bh=gCYkJ+EsoqmEnBOC4tgRbE1MyFFuqUjlAaZ3W1U/j+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fppiF/AKCnGaKrv254iBprfFxWotwAPQSEVkasy/UsUZWauLSZ2pgKEa3lkPAGbeq
         IUN3cpfDzjpBM4IkhL50FGUiYcyNp2oNJbPtoi/uZ8Tvzw4oDErAjXZGr8jQbdXsfi
         ehZrCKdYIG7KIKWuIWhtY47QoQVLlN+S7SW38mNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/421] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon, 19 Jul 2021 16:48:19 +0200
Message-Id: <20210719144949.162569308@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



