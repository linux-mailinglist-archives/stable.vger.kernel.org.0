Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7833490CE0
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbiAQQ7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:59:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48928 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241382AbiAQQ7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:59:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 435CC60EDB;
        Mon, 17 Jan 2022 16:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB90BC36AE3;
        Mon, 17 Jan 2022 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438775;
        bh=3Efeav5/jfwkBywK9Tb1QYQGO5lWAXrOAFpR3Rex+s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnHnkdMMmQtfe2/7BvRmMgIEhUGe9AZ/zOjU4AWEWn8OCWrVVZDONCU2TNfhC10fi
         67hmusa57rjp8KSvjVx0ZyLsCjhu+4YXO9K2lnOXSpEB7deNd2QQdgNJP26vZBqlHt
         jI59Aglj4hFQ6lFXTxRInsoujgdc+a88SAiN3vfhF64zOXqIrz8O/gOSUEqyp/MkXi
         piKcmfaXOpbRX2lj81KB1X7DshJ8zmHJAG+Kebnn4yWYdyjgcp1Ceg5552/bbZMbW1
         2zzdmodwHKAR+HOPCx4oAmkQTDDCw7CyadGX7jcrRsjBMJSgpSmYYtE3gTpvc3EI9j
         9vXh5YXmhhzEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.16 18/52] dm: fix alloc_dax error handling in alloc_dev
Date:   Mon, 17 Jan 2022 11:58:19 -0500
Message-Id: <20220117165853.1470420-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d751939235b9b7bc4af15f90a3e99288a8b844a7 ]

Make sure ->dax_dev is NULL on error so that the cleanup path doesn't
trip over an ERR_PTR.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20211129102203.2243509-2-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 662742a310cbb..acc84dc1bded5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1786,8 +1786,10 @@ static struct mapped_device *alloc_dev(int minor)
 	if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
 		md->dax_dev = alloc_dax(md, md->disk->disk_name,
 					&dm_dax_ops, 0);
-		if (IS_ERR(md->dax_dev))
+		if (IS_ERR(md->dax_dev)) {
+			md->dax_dev = NULL;
 			goto bad;
+		}
 	}
 
 	format_dev_t(md->name, MKDEV(_major, minor));
-- 
2.34.1

