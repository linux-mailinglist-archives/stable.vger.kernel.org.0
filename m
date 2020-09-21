Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48210273009
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgIURBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729228AbgIUQjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:39:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C5F238EE;
        Mon, 21 Sep 2020 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706349;
        bh=PQSAbPp/SO39R20BoR+qN6FK+isHUo3NjRid7Kpzh9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+ERLZt+oDhiT/gneu4HA2ygVqvC5HJDb5yQ/cHhHk8w91rAVihDKZm9VB5osfrVr
         YA0eEwul58FCwMypMj+OjB2FCEdyqtWq1kDTRIdG9iEkv6GxsszPLWUUatSPFHSHus
         uxKkrYfehuyB5krjWETpfgCfyOuu8xZ+yEbSQ6SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 65/94] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Mon, 21 Sep 2020 18:27:52 +0200
Message-Id: <20200921162038.520595740@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
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
index e64a13f0bce17..61a2da30f94b7 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -795,7 +795,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			return res;
+			goto ex_err;
 		ccb = &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device = pm8001_dev;
 		ccb->ccb_tag = ccb_tag;
-- 
2.25.1



