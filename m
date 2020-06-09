Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59551F44DA
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388067AbgFISJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:09:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41450 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388181AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pY-Km; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006VwC-GR; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Tue, 09 Jun 2020 19:04:26 +0100
Message-ID: <lsq.1591725832.609479650@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 35/61] scsi: sg: Re-fix off by one in sg_fill_request_table()
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

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

commit 587c3c9f286cee5c9cac38d28c8ae1875f4ec85b upstream.

Commit 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
introduced an off-by-one error in sg_ioctl(), which was fixed by commit
bd46fc406b30 ("scsi: sg: off by one in sg_ioctl()").

Unfortunately commit 4759df905a47 ("scsi: sg: factor out
sg_fill_request_table()") moved that code, and reintroduced the
bug (perhaps due to a botched rebase).  Fix it again.

Fixes: 4759df905a47 ("scsi: sg: factor out sg_fill_request_table()")
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -879,7 +879,7 @@ sg_fill_request_table(Sg_fd *sfp, sg_req
 
 	val = 0;
 	list_for_each_entry(srp, &sfp->rq_list, entry) {
-		if (val > SG_MAX_QUEUE)
+		if (val >= SG_MAX_QUEUE)
 			break;
 		rinfo[val].req_state = srp->done + 1;
 		rinfo[val].problem =

