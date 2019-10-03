Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CE8CA31F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbfJCQM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388035AbfJCQMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E9520700;
        Thu,  3 Oct 2019 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119144;
        bh=o9aX2bau2Ui2FjhVZKIimH8ZL1iyt0Febi4Bh0UHciM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQfh8jDxCIiswM3HN7mFguwudPeC5/bgpahoLMmEtSnSgIP8pN2Pdi/COqZlnFIIg
         F/0HDBHIKXOrg9I7bnjwhkomnq2+igyPg0ZJIpzqx5iNSZ/W5SFdBgB0/cGTNU9ugz
         ET54q96myHf9CTCDv+aWqoEqX+DYNzFXKfi35Bcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Ales Novak <alnovak@suse.cz>,
        Shane Seymour <shane.seymour@hpe.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 142/185] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
Date:   Thu,  3 Oct 2019 17:53:40 +0200
Message-Id: <20191003154509.969401555@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <Martin.Wilck@suse.com>

commit 57adf5d4cfd3198aa480e7c94a101fc8c4e6109d upstream.

cdb in send_mode_select() is not zeroed and is only partially filled in
rdac_failover_get(), which leads to some random data getting to the
device. Users have reported storage responding to such commands with
INVALID FIELD IN CDB. Code before commit 327825574132 was not affected, as
it called blk_rq_set_block_pc().

Fix this by zeroing out the cdb first.

Identified & fix proposed by HPE.

Fixes: 327825574132 ("scsi_dh_rdac: switch to scsi_execute_req_flags()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20190904155205.1666-1-martin.wilck@suse.com
Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Ales Novak <alnovak@suse.cz>
Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -546,6 +546,8 @@ static void send_mode_select(struct work
 	spin_unlock(&ctlr->ms_lock);
 
  retry:
+	memset(cdb, 0, sizeof(cdb));
+
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "


