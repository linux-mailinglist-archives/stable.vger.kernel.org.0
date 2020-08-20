Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2630024B60E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgHTKbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731301AbgHTKUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:20:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A15EE2067C;
        Thu, 20 Aug 2020 10:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918834;
        bh=BH4EgUBXqCSKKBSJ4WJk4gUi3wBwFwK4qnMhCc55oyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvMrzIZ9zxwGYOB1IqlzKsMStkhIK16FfmEnRi2c902tVgHz/IPUuA/WDJ/qFZ/WC
         N0m14MkVctQVxahdVOcPOUSpFCK7fLMOt9f0VVNvyoSM97tAfl7p/iFvS7wFKvUY3p
         IjQnHIwRPjqKP0zkDzpeJwnZnVVtYbO4U5aK1Pn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 084/149] cxl: Fix kobject memleak
Date:   Thu, 20 Aug 2020 11:22:41 +0200
Message-Id: <20200820092129.791728489@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 85c5cbeba8f4fb28e6b9bfb3e467718385f78f76 ]

Currently the error return path from kobject_init_and_add() is not
followed by a call to kobject_put() - which means we are leaking
the kobject.

Fix it by adding a call to kobject_put() in the error path of
kobject_init_and_add().

Fixes: b087e6190ddc ("cxl: Export optional AFU configuration record in sysfs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Link: https://lore.kernel.org/r/20200602120733.5943-1-wanghai38@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/sysfs.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/misc/cxl/sysfs.c
+++ b/drivers/misc/cxl/sysfs.c
@@ -539,7 +539,7 @@ static struct afu_config_record *cxl_sys
 	rc = kobject_init_and_add(&cr->kobj, &afu_config_record_type,
 				  &afu->dev.kobj, "cr%i", cr->cr);
 	if (rc)
-		goto err;
+		goto err1;
 
 	rc = sysfs_create_bin_file(&cr->kobj, &cr->config_attr);
 	if (rc)
@@ -555,9 +555,6 @@ err2:
 err1:
 	kobject_put(&cr->kobj);
 	return ERR_PTR(rc);
-err:
-	kfree(cr);
-	return ERR_PTR(rc);
 }
 
 void cxl_sysfs_afu_remove(struct cxl_afu *afu)


