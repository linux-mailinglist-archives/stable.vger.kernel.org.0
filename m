Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC93CD7C0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbhGSOSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242204AbhGSOS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69719611EF;
        Mon, 19 Jul 2021 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706743;
        bh=QOY03wTlX/CMjWwkWu3pHzGGekmK57YqisyZ77PQhtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+fLUPHLf6HNHYJ5Z6C1CqHZkNbVv0beYCRbCcRx3pOf+R731Jj/HbvBDZlTxPHyK
         m73IHzHH24FBxqiw3RM6YRiW5jPpKIt0XzhYRd1SWFap+ckBeIH5K6BCDrFvPDE8Ph
         a65ZPg/OQ72cBVYhq8t2jwK3zTO3jrOlpKH2EjNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 045/188] ACPI: bus: Call kobject_put() in acpi_init() error path
Date:   Mon, 19 Jul 2021 16:50:29 +0200
Message-Id: <20210719144923.553345674@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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



