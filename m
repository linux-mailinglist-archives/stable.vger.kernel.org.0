Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02AD1F44C3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732218AbgFISIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:08:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41366 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388162AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001p1-B8; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vwd-Qb; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Li Bin" <huawei.libin@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Tue, 09 Jun 2020 19:04:35 +0100
Message-ID: <lsq.1591725832.632953791@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 44/61] scsi: sg: add sg_remove_request in sg_common_write
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

From: Li Bin <huawei.libin@huawei.com>

commit 849f8583e955dbe3a1806e03ecacd5e71cce0a08 upstream.

If the dxfer_len is greater than 256M then the request is invalid and we
need to call sg_remove_request in sg_common_write.

Link: https://lore.kernel.org/r/1586777361-17339-1-git-send-email-huawei.libin@huawei.com
Fixes: f930c7043663 ("scsi: sg: only check for dxfer_len greater than 256M")
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Li Bin <huawei.libin@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -808,8 +808,10 @@ sg_common_write(Sg_fd * sfp, Sg_request
 	SCSI_LOG_TIMEOUT(4, printk("sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			  (int) cmnd[0], (int) hp->cmd_len));
 
-	if (hp->dxfer_len >= SZ_256M)
+	if (hp->dxfer_len >= SZ_256M) {
+		sg_remove_request(sfp, srp);
 		return -EINVAL;
+	}
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {

