Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88009205D81
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbgFWUOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388713AbgFWUNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:13:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4118F20E65;
        Tue, 23 Jun 2020 20:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943232;
        bh=HxgZGib8B7jApfVRJLYV16Iqb0rLo81W0p/C/EOsT08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inDALAsOuUQXR8DzNlMaLW60AOMtgrQfowJ/RpH05WRRSFGzMWR6T14M3+ZaXwLQd
         JO3fRdR214pvXWw+GSfzv2GuQwabQz3OkNOVrs6FIMBMSxPl98rbIJTvL0RfpgpZZS
         2iyj/J2YcgHgqL9FjQP1AjRkbSuab0t9PNKcBxQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Qiushi Wu <wu000273@umn.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 312/477] scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj
Date:   Tue, 23 Jun 2020 21:55:09 +0200
Message-Id: <20200623195422.285864109@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 0267ffce562c8bbf9b57ebe0e38445ad04972890 ]

kobject_init_and_add() takes reference even when it fails. If this
function returns an error, kobject_put() must be called to properly
clean up the memory associated with the object.

Link: https://lore.kernel.org/r/20200528201353.14849-1-wu000273@umn.edu
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_boot_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index e4857b7280338..a64abe38db2d4 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -352,7 +352,7 @@ iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_kset,
 	boot_kobj->kobj.kset = boot_kset->kset;
 	if (kobject_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,
 				 NULL, name, index)) {
-		kfree(boot_kobj);
+		kobject_put(&boot_kobj->kobj);
 		return NULL;
 	}
 	boot_kobj->data = data;
-- 
2.25.1



