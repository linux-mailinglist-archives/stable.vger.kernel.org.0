Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC61B461F10
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379488AbhK2Sm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43154 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353698AbhK2Sk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27577B815B1;
        Mon, 29 Nov 2021 18:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2A5C53FC7;
        Mon, 29 Nov 2021 18:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211056;
        bh=C+Rp5BvfjDxstLqWBW0v8ghentmBObYzDQbcyXkYMSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKBlNyWBZGfJCn1EFBIss2plPoa9UMi8CzOqXWMlbBorVQQ3pIFWmSpptdfjt3xy0
         NE1yiVfhYUEwfqDPBCgnKxvbjfqZPoVZPImbdw2OeSIjSg3vfFkZ0lpcjjYNvy14mm
         k24kkIhPBzBSdguIpo0utPSLGnzCDVbozv+fnWkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/179] scsi: qla2xxx: edif: Fix off by one bug in qla_edif_app_getfcinfo()
Date:   Mon, 29 Nov 2021 19:18:01 +0100
Message-Id: <20211129181721.807466682@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e11e285b9cd132db21568b5d29c291f590841944 ]

The > comparison needs to be >= to prevent accessing one element beyond the
end of the app_reply->ports[] array.

Link: https://lore.kernel.org/r/20211109115219.GE16587@kili
Fixes: 7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs")
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 9240e788b011d..a04693498dc01 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -865,7 +865,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			    "APP request entry - portid=%06x.\n", tdid.b24);
 
 			/* Ran out of space */
-			if (pcnt > app_req.num_ports)
+			if (pcnt >= app_req.num_ports)
 				break;
 
 			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
-- 
2.33.0



