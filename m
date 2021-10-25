Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACA443A377
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhJYT7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239537AbhJYT5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:57:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FCF461165;
        Mon, 25 Oct 2021 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191208;
        bh=wRKLkpQqqHe3cbvwURGBjjZnolQyzLpKfzC4g/g6FMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znD9fNgBmIUpzOyY3JpudGZpk8/lP3r82hC78GDzAsN6H4d+Toxhbc4gYoQh0MttB
         QvDwErjjx7mvVWm2cap9dE/HtyIO9kvklDl59QOWcDjRmSZ0nGNziSdr55H/GmeScd
         nUM91BV/iF5u3/YZHvt+lorMwb1lya6G6HWWYUfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Joy Gu <jgu@purestorage.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 152/169] scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()
Date:   Mon, 25 Oct 2021 21:15:33 +0200
Message-Id: <20211025191036.762933989@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joy Gu <jgu@purestorage.com>

[ Upstream commit 7fb223d0ad801f633c78cbe42b1d1b55f5d163ad ]

Commit 8c0eb596baa5 ("[SCSI] qla2xxx: Fix a memory leak in an error path of
qla2x00_process_els()"), intended to change:

        bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN

to:

        bsg_job->request->msgcode != FC_BSG_RPT_ELS

but changed it to:

        bsg_job->request->msgcode == FC_BSG_RPT_ELS

instead.

Change the == to a != to avoid leaking the fcport structure or freeing
unallocated memory.

Link: https://lore.kernel.org/r/20211012191834.90306-2-jgu@purestorage.com
Fixes: 8c0eb596baa5 ("[SCSI] qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Joy Gu <jgu@purestorage.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index d42b2ad84049..2304f54fdc93 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -415,7 +415,7 @@ done_unmap_sg:
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
+	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;
-- 
2.33.0



