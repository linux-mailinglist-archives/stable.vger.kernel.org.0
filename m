Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8587699CBC
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404326AbfHVRYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404314AbfHVRYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:45 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E342342A;
        Thu, 22 Aug 2019 17:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494685;
        bh=3NOsZgv9qepVKA8m8KpNcbf4kQz1Z8kGHzTNDuKpb2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJQfIGD1h+Yd5wWjGfhYBNXfzAEAfdiY5nyxJ5Zj8+qw6JgkPXXxGaSR7fT6kyMLz
         4ltAXLJ0tk1dAHLepelI9G1llJaOVabN6IKsvPV7PPkGtnNInK0rL18hg9chLtZvez
         VD2IGnHgpgOTIW0P7/i7dYWZbwA9WNqI/hexFUU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/71] scsi: qla2xxx: Fix possible fcport null-pointer dereferences
Date:   Thu, 22 Aug 2019 10:19:06 -0700
Message-Id: <20190822171729.296560191@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e82f04ec6ba91065fd33a6201ffd7cab840e1475 ]

In qla2x00_alloc_fcport(), fcport is assigned to NULL in the error
handling code on line 4880:
    fcport = NULL;

Then fcport is used on lines 4883-4886:
    INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
	INIT_WORK(&fcport->reg_work, qla_register_fcport_fn);
	INIT_LIST_HEAD(&fcport->gnl_entry);
	INIT_LIST_HEAD(&fcport->list);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, qla2x00_alloc_fcport() directly returns NULL
in the error handling code.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aef1e1a555350..0e154fea693e7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4252,7 +4252,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 		ql_log(ql_log_warn, vha, 0xd049,
 		    "Failed to allocate ct_sns request.\n");
 		kfree(fcport);
-		fcport = NULL;
+		return NULL;
 	}
 	INIT_WORK(&fcport->del_work, qla24xx_delete_sess_fn);
 	INIT_LIST_HEAD(&fcport->gnl_entry);
-- 
2.20.1



