Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73253328919
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhCARuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:50:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238938AbhCARn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:43:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB3C864F67;
        Mon,  1 Mar 2021 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617901;
        bh=KbjnjHMeIdsAunwaHBJbj7lGNjEnrWhqROhsuo1+y18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtSkmxig7fdJe8I74EF0aFi07dcfZj0pvacJZpsJEs5QD5bPsNyr6FDArgWtBd3/g
         GUtBPcBfYXxYiX2DMHEqxgxyMBCBypM1JVxGcGMzu9NpPZFpvJfJgx18WAvgF3wES7
         o5AYDQU+E30qbi173uNCvJMULlUY1fHQ0GhHZfJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 237/340] ACPI: configfs: add missing check after configfs_register_default_group()
Date:   Mon,  1 Mar 2021 17:13:01 +0100
Message-Id: <20210301161059.957933379@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

commit 67e40054de86aae520ddc2a072d7f6951812a14f upstream.

A list_add corruption is reported by Hulk Robot like this:
==============
list_add corruption.
Call Trace:
link_obj+0xc0/0x1c0
link_group+0x21/0x140
configfs_register_subsystem+0xdb/0x380
acpi_configfs_init+0x25/0x1000 [acpi_configfs]
do_one_initcall+0x149/0x820
do_init_module+0x1ef/0x720
load_module+0x35c8/0x4380
__do_sys_finit_module+0x10d/0x1a0
do_syscall_64+0x34/0x80

It's because of the missing check after configfs_register_default_group,
where configfs_unregister_subsystem should be called once failure.

Fixes: 612bd01fc6e0 ("ACPI: add support for loading SSDTs via configfs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_configfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_configfs.c
+++ b/drivers/acpi/acpi_configfs.c
@@ -267,7 +267,12 @@ static int __init acpi_configfs_init(voi
 
 	acpi_table_group = configfs_register_default_group(root, "table",
 							   &acpi_tables_type);
-	return PTR_ERR_OR_ZERO(acpi_table_group);
+	if (IS_ERR(acpi_table_group)) {
+		configfs_unregister_subsystem(&acpi_configfs);
+		return PTR_ERR(acpi_table_group);
+	}
+
+	return 0;
 }
 module_init(acpi_configfs_init);
 


