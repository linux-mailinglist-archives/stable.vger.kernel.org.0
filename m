Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5323B1F449F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbgFISGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:06:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41792 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388202AbgFISGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:06:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pW-E2; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vw8-Fb; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Christoph Hellwig" <hch@lst.de>,
        "Eric Dumazet" <edumazet@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hannes Reinecke" <hare@suse.com>,
        "Hannes Reinecke" <hare@suse.de>,
        "Bart Van Assche" <bart.vanassche@wdc.com>
Date:   Tue, 09 Jun 2020 19:04:25 +0100
Message-ID: <lsq.1591725832.201648349@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 34/61] scsi: sg: fixup infoleak when using
 SG_GET_REQUEST_TABLE
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 3e0097499839e0fe3af380410eababe5a47c4cf9 upstream.

When calling SG_GET_REQUEST_TABLE ioctl only a half-filled table is
returned; the remaining part will then contain stale kernel memory
information.  This patch zeroes out the entire table to avoid this
issue.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -881,7 +881,6 @@ sg_fill_request_table(Sg_fd *sfp, sg_req
 	list_for_each_entry(srp, &sfp->rq_list, entry) {
 		if (val > SG_MAX_QUEUE)
 			break;
-		memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
 		rinfo[val].req_state = srp->done + 1;
 		rinfo[val].problem =
 			srp->header.masked_status &
@@ -1098,8 +1097,8 @@ sg_ioctl(struct file *filp, unsigned int
 		else {
 			sg_req_info_t *rinfo;
 
-			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
-								GFP_KERNEL);
+			rinfo = kzalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
+					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);

