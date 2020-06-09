Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0AA1F44FC
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbgFISKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41388 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388166AbgFISF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pS-GF; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vw3-Du; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Tue, 09 Jun 2020 19:04:23 +0100
Message-ID: <lsq.1591725832.751468300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 32/61] scsi: sg: off by one in sg_ioctl()
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bd46fc406b30d1db1aff8dabaff8d18bb423fdcf upstream.

If "val" is SG_MAX_QUEUE then we are one element beyond the end of the
"rinfo" array so the > should be >=.

Fixes: 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1072,7 +1072,7 @@ sg_ioctl(struct file *filp, unsigned int
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			val = 0;
 			list_for_each_entry(srp, &sfp->rq_list, entry) {
-				if (val > SG_MAX_QUEUE)
+				if (val >= SG_MAX_QUEUE)
 					break;
 				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
 				rinfo[val].req_state = srp->done + 1;

