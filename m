Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451AE1F44F6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388552AbgFISKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41374 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388160AbgFISF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pM-9B; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vvu-Ai; Tue, 09 Jun 2020 19:05:53 +0100
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
        "Todd Poynor" <toddpoynor@google.com>
Date:   Tue, 09 Jun 2020 19:04:20 +0100
Message-ID: <lsq.1591725832.86967356@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 29/61] scsi: sg: recheck MMAP_IO request length with
 lock held
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

From: Todd Poynor <toddpoynor@google.com>

commit 8d26f491116feaa0b16de370b6a7ba40a40fa0b4 upstream.

Commit 1bc0eb044615 ("scsi: sg: protect accesses to 'reserved' page
array") adds needed concurrency protection for the "reserve" buffer.
Some checks that are initially made outside the lock are replicated once
the lock is taken to ensure the checks and resulting decisions are made
using consistent state.

The check that a request with flag SG_FLAG_MMAP_IO set fits in the
reserve buffer also needs to be performed again under the lock to ensure
the reserve buffer length compared against matches the value in effect
when the request is linked to the reserve buffer.  An -ENOMEM should be
returned in this case, instead of switching over to an indirect buffer
as for non-MMAP_IO requests.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1772,9 +1772,12 @@ sg_start_req(Sg_request *srp, unsigned c
 		    !sfp->res_in_use) {
 			sfp->res_in_use = 1;
 			sg_link_reserve(sfp, srp, dxfer_len);
-		} else if ((hp->flags & SG_FLAG_MMAP_IO) && sfp->res_in_use) {
+		} else if (hp->flags & SG_FLAG_MMAP_IO) {
+			res = -EBUSY; /* sfp->res_in_use == 1 */
+			if (dxfer_len > rsv_schp->bufflen)
+				res = -ENOMEM;
 			mutex_unlock(&sfp->f_mutex);
-			return -EBUSY;
+			return res;
 		} else {
 			res = sg_build_indirect(req_schp, sfp, dxfer_len);
 			if (res) {

