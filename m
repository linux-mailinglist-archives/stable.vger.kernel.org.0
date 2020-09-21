Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993FE272DC6
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgIUQnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbgIUQnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3500923998;
        Mon, 21 Sep 2020 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706589;
        bh=kK9BT5mjTQ8XF5WRbFDzOIgCtUNac6wLSe0z0LkB2mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xg2Ifxr6tMO+yrpb3h3/8NqVgkMLlwvlFUi2QEpWF6yUh+dY1fMGgzdxvZyrgWxCD
         DxV7XVcnUuniJdoWKtoX2/nfiiAvCK96sWd5hWmgl6TBXYWHrXiyerRrrtJV4pQ6Ie
         TlU0uJaVwR/M8GnqYrf9+ztbKHM+SKqx/NR3vQFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 014/118] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Mon, 21 Sep 2020 18:27:06 +0200
Message-Id: <20200921162036.993726776@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit ea403fde7552bd61bad6ea45e3feb99db77cb31e ]

When pm8001_tag_alloc() fails, task should be freed just like it is done in
the subsequent error paths.

Link: https://lore.kernel.org/r/20200823091453.4782-1-dinghao.liu@zju.edu.cn
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b7cbc312843e9..da9fd8a5f8cae 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -818,7 +818,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
-- 
2.25.1



