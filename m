Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACC38DACC
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfHNRUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbfHNRKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 652E02084D;
        Wed, 14 Aug 2019 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802638;
        bh=wGnkXI/H79nU+O0BqQv0kJhREjEJ1fz8u7j98i5eA+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQ9KieIVVnDnsBc6rlWTW1K1zRlB8XzyW+0Acv+IbaQhD8GC1AwnZI1bJT7mcGJxg
         LzWBjsK1Zwy9zsGmcFyrzJi7c/RUXNmz42zBjGLVhRoZD9KyodDAc05iQmYlZsneXT
         nYYwMFeBRnagyyxZ28MSsvENaXhP7NuNvyb3VPzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <will@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/91] ACPI/IORT: Fix off-by-one check in iort_dev_find_its_id()
Date:   Wed, 14 Aug 2019 19:01:22 +0200
Message-Id: <20190814165752.092367336@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5a46d3f71d5e5a9f82eabc682f996f1281705ac7 ]

Static analysis identified that index comparison against ITS entries in
iort_dev_find_its_id() is off by one.

Update the comparison condition and clarify the resulting error
message.

Fixes: 4bf2efd26d76 ("ACPI: Add new IORT functions to support MSI domain handling")
Link: https://lore.kernel.org/linux-arm-kernel/20190613065410.GB16334@mwanda/
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Will Deacon <will@kernel.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 43c2615434b48..e11b5da6f828f 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -616,8 +616,8 @@ static int iort_dev_find_its_id(struct device *dev, u32 req_id,
 
 	/* Move to ITS specific data */
 	its = (struct acpi_iort_its_group *)node->node_data;
-	if (idx > its->its_count) {
-		dev_err(dev, "requested ITS ID index [%d] is greater than available [%d]\n",
+	if (idx >= its->its_count) {
+		dev_err(dev, "requested ITS ID index [%d] overruns ITS entries [%d]\n",
 			idx, its->its_count);
 		return -ENXIO;
 	}
-- 
2.20.1



