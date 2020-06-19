Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DA420183C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbgFSQsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387825AbgFSOkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:40:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1770620773;
        Fri, 19 Jun 2020 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577622;
        bh=vufx0vyQjbhKY6H1Jy6DAqwq30Pr95FUeTOb5XINOxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/UyZlNJace8g7YuDpoz/zC/Ng8ZfZQMWWAKa2L9QpX+Md9egy5Y1SMUZSovg4uXD
         J7IQopgadXQC4Jwyxwe97PMLiHxzPPrTYfOMr8OoFIG7XEnpyDaaiFfZ4jf8SRgYDA
         wxPdoCmplUk79uGUOf2h3vpR/2bqKK+jbJgoIQAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.9 003/128] scsi: return correct blkprep status code in case scsi_init_io() fails.
Date:   Fri, 19 Jun 2020 16:31:37 +0200
Message-Id: <20200619141620.323404815@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <jthumshirn@suse.de>

commit e7661a8e5ce10b5321882d0bbaf3f81070903319 upstream.

When instrumenting the SCSI layer to run into the
!blk_rq_nr_phys_segments(rq) case the following warning emitted from the
block layer:

blk_peek_request: bad return=-22

This happens because since commit fd3fc0b4d730 ("scsi: don't BUG_ON()
empty DMA transfers") we return the wrong error value from
scsi_prep_fn() back to the block layer.

[mkp: silenced checkpatch]

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: fd3fc0b4d730 scsi: don't BUG_ON() empty DMA transfers
Cc: <stable@vger.kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[iwamatsu: - backport for 4.4.y and 4.9.y
    - Use rq->nr_phys_segments instead of blk_rq_nr_phys_segments]
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1029,10 +1029,10 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 	bool is_mq = (rq->mq_ctx != NULL);
-	int error;
+	int error = BLKPREP_KILL;
 
 	if (WARN_ON_ONCE(!rq->nr_phys_segments))
-		return -EINVAL;
+		goto err_exit;
 
 	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)


