Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F174D1F44B6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388185AbgFISHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:07:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41500 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388189AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001p5-Ov; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006VwO-Jm; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hannes Reinecke" <hare@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Cristian Crinteanu" <crinteanu.cristian@gmail.com>,
        "Chris Clayton" <chris2553@googlemail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>
Date:   Tue, 09 Jun 2020 19:04:30 +0100
Message-ID: <lsq.1591725832.612343351@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 39/61] scsi: sg: fix SG_DXFER_FROM_DEV transfers
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

From: Johannes Thumshirn <jthumshirn@suse.de>

commit 68c59fcea1f2c6a54c62aa896cc623c1b5bc9b47 upstream.

SG_DXFER_FROM_DEV transfers do not necessarily have a dxferp as we set
it to NULL for the old sg_io read/write interface, but must have a
length bigger than 0. This fixes a regression introduced by commit
28676d869bbb ("scsi: sg: check for valid direction before starting the
request")

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: 28676d869bbb ("scsi: sg: check for valid direction before starting the request")
Reported-by: Chris Clayton <chris2553@googlemail.com>
Tested-by: Chris Clayton <chris2553@googlemail.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Chris Clayton <chris2553@googlemail.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Cristian Crinteanu <crinteanu.cristian@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -795,8 +795,11 @@ static bool sg_is_valid_dxfer(sg_io_hdr_
 		if (hp->dxferp || hp->dxfer_len > 0)
 			return false;
 		return true;
-	case SG_DXFER_TO_DEV:
 	case SG_DXFER_FROM_DEV:
+		if (hp->dxfer_len < 0)
+			return false;
+		return true;
+	case SG_DXFER_TO_DEV:
 	case SG_DXFER_TO_FROM_DEV:
 		if (!hp->dxferp || hp->dxfer_len == 0)
 			return false;

