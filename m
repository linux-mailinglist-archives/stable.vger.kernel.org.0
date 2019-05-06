Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E6014C31
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfEFOh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbfEFOh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4490320449;
        Mon,  6 May 2019 14:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153447;
        bh=GUiVy+722ByJzV1vIVKdMdL5x+aWBD1kEf1es+X2vUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fr1FjVKlmt36gqaPndBc7bSzIEf7OVYKrae4EGA7qzXmuXBZYOqz40F7UELwZ2l4M
         Tc58wiEZT+wz1DSXeoI1S8m9kq1o+XCH/GeQ6FnjOXtbDfQx3JlHWrGAk92Bc8MR/d
         +YmyoHef0hfkH9sT+zo8473lX6iDxhwawEfzWGCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Mike Christie <mchristi@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.0 093/122] scsi: RDMA/srpt: Fix a credit leak for aborted commands
Date:   Mon,  6 May 2019 16:32:31 +0200
Message-Id: <20190506143103.030056875@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 40ca8757291ca7a8775498112d320205b2a2e571 upstream.

Make sure that the next time a response is sent to the initiator that the
credit it had allocated for the aborted request gets freed.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: 131e6abc674e ("target: Add TFO->abort_task for aborted task resources release") # v3.15
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2887,8 +2887,19 @@ static void srpt_queue_tm_rsp(struct se_
 	srpt_queue_response(cmd);
 }
 
+/*
+ * This function is called for aborted commands if no response is sent to the
+ * initiator. Make sure that the credits freed by aborting a command are
+ * returned to the initiator the next time a response is sent by incrementing
+ * ch->req_lim_delta.
+ */
 static void srpt_aborted_task(struct se_cmd *cmd)
 {
+	struct srpt_send_ioctx *ioctx = container_of(cmd,
+				struct srpt_send_ioctx, cmd);
+	struct srpt_rdma_ch *ch = ioctx->ch;
+
+	atomic_inc(&ch->req_lim_delta);
 }
 
 static int srpt_queue_status(struct se_cmd *cmd)


