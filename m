Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927683C4D69
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbhGLHND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244622AbhGLHLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C7AB60FF0;
        Mon, 12 Jul 2021 07:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073694;
        bh=+iO7CxnzvqzVAeUkTGfv6Xxx3DoJ7K22SSdc+7/GvIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YqpQq7YU98Q7JQ8XPc7427Johxy5SoGzqxeNTKaceSDe3k5bSDHufmO/OnvB2I6s
         m3GMirimxK4wDnZ14uPQI0ersBkwgoeOha0QTxjcahQJ8GI02A5l5VfjkYi4pqYJCB
         qrMnQy39w3+U7fJKdTjtvliDNtjEScX+K0ghEb7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 328/700] ACPI: tables: FPDT: Add missing acpi_put_table() in acpi_init_fpdt()
Date:   Mon, 12 Jul 2021 08:06:51 +0200
Message-Id: <20210712061011.290830782@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit dd9eaa23e72572d4f1c03f2e5d2e14a5b5793e79 ]

acpi_init_fpdt() forgets to call acpi_put_table() in an error path.

Add the missing function call to fix it.

Fixes: d1eb86e59be0 ("ACPI: tables: introduce support for FPDT table")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_fpdt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_fpdt.c b/drivers/acpi/acpi_fpdt.c
index a89a806a7a2a..4ee2ad234e3d 100644
--- a/drivers/acpi/acpi_fpdt.c
+++ b/drivers/acpi/acpi_fpdt.c
@@ -240,8 +240,10 @@ static int __init acpi_init_fpdt(void)
 		return 0;
 
 	fpdt_kobj = kobject_create_and_add("fpdt", acpi_kobj);
-	if (!fpdt_kobj)
+	if (!fpdt_kobj) {
+		acpi_put_table(header);
 		return -ENOMEM;
+	}
 
 	while (offset < header->length) {
 		subtable = (void *)header + offset;
-- 
2.30.2



